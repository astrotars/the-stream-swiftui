import SwiftUI
import Combine
import GetStream
import GetStreamActivityFeed
import StreamChatClient
import Alamofire

final class Account: ObservableObject {
    enum FeedType {
        case profile
        case timeline
    }
    
    @Published var user: String?
    @Published var isAuthed: Bool = false
    
    // MODIFY THIS LINE
    // To access your backend locally make sure it's running (follow readme in backend directory) and use something like: https://ngrok.com/
    // or turn off security policies to access localhost
    private let apiRoot = "https://d38e8e16.ngrok.io"
    private var authToken: String?
    private var feedToken: String?
    private var userFeed: FlatFeed?
    private var timelineFeed: FlatFeed?
    
    func login(_ userToLogIn: String) {
        Alamofire
            .request("\(apiRoot)/v1/users",
                method: .post,
                parameters: ["user" : userToLogIn],
                encoding: JSONEncoding.default)
            .responseJSON { [weak self] response in
                print(response)
                let body = response.value as! NSDictionary
                let authToken = body["authToken"]! as! String
                
                
                self?.user = userToLogIn
                self?.authToken = authToken
                self?.setupFeed()
        }
    }
    
    func fetchFeed(_ feedType: FeedType, completion: @escaping (_ result: [FeedItem]) -> Void) {
        let feed: FlatFeed = {
            switch(feedType) {
            case .profile:
                return userFeed!
            case .timeline:
                return timelineFeed!
            }
        }()
        
        feed.get(typeOf: FeedItem.self, pagination: .limit(50)) { r in
            completion(try! r.get().results)
        }
    }
    
    func createFeedItem(_ message: String, completion: @escaping () -> Void) {
        let activity = FeedItem(actor: User(id: self.user!), verb: "post", object: UUID().uuidString, message: message)
        
        userFeed?.add(activity) { result in
            completion()
        }
    }
    
    func fetchUsers(completion: @escaping (_ result: [String]) -> Void) {
        Alamofire
            .request("\(apiRoot)/v1/users",
                method: .get,
                headers: ["Authorization" : "Bearer \(authToken!)"])
            .responseJSON { response in
                let body = response.value as! NSDictionary
                let users = body["users"]! as! [String]
                completion(users)
        }
    }
    
    func follow(_ user: String, completion: @escaping () -> Void) {
        timelineFeed!.follow(
            toTarget: Client.shared.flatFeed(feedSlug: "user", userId: user).feedId
        ) { result in
            completion()
        }
    }
    
    func createPrivateChannel(_ user: String, _ withUser: String, completion: @escaping (Channel) -> Void) {
        let users = [user, withUser]
        let channelId = users.sorted().joined(separator: "-")
        let channel = StreamChatClient.Client.shared.channel(
            type: .messaging,
            id: channelId,
            members: users.map { StreamChatClient.User(id: $0) }
        )
        
        channel.create { (result) in
            completion(try! result.get().channel)
        }
    }
    
    func createPublicChannel(_ name: String, completion: @escaping (Channel) -> Void) {
        let id = name
            .lowercased()
            .components(separatedBy: .whitespaces)
            .joined(separator: "-")
        
        let channel = StreamChatClient.Client.shared.channel(
            type: .livestream,
            id: id,
            extraData: ChannelExtraData(name: name, imageURL: URL(string: "https://robohash.org/\(id).png"))
        )
        
        channel.create { (result) in
            completion(try! result.get().channel)
        }
    }
    
    func startCall(_ to: String, _ callId: String) {
        Alamofire
            .request("\(apiRoot)/v1/calls",
                method: .post,
                parameters: ["to" : to, "id" : callId],
                encoding: JSONEncoding.default,
                headers: ["Authorization" : "Bearer \(authToken!)"])
    }
    
    func fetchCalls(completion: @escaping (_ result: [NSDictionary]) -> Void) {
        Alamofire
            .request("\(apiRoot)/v1/calls",
                method: .get,
                headers: ["Authorization" : "Bearer \(authToken!)"])
            .responseJSON { response in
                completion(response.value as! [NSDictionary])
        }
    }
    
    func stopCall(_ callId: String) {
        Alamofire
            .request("\(apiRoot)/v1/calls/\(callId)",
                method: .delete,
                headers: ["Authorization" : "Bearer \(authToken!)"])
    }
    
    private func setupFeed() {
        Alamofire
            .request("\(apiRoot)/v1/stream-feed-credentials",
                method: .post,
                headers: ["Authorization" : "Bearer \(authToken!)"])
            .responseJSON { [weak self] response in
                let body = response.value as! NSDictionary
                let feedToken = body["token"]! as! String
                let appId = body["appId"] as! String
                let apiKey = body["apiKey"] as! String
                
                if let user = self?.user {
                    GetStream.Client.config = .init(apiKey: apiKey,
                                                    appId: appId)
                    
                    
                    GetStream.Client.shared.setupUser(
                        GetStreamActivityFeed.User(name: user,
                                                   id: user),
                        token: feedToken
                    ) { [weak self] (result) in
                        self?.userFeed = Client.shared.flatFeed(feedSlug: "user")
                        self?.timelineFeed = Client.shared.flatFeed(feedSlug: "timeline")
                        
                        self?.setupChat()
                    }
                }
        }
    }
    
    private func setupChat() {
        Alamofire
            .request("\(apiRoot)/v1/stream-chat-credentials",
                method: .post,
                headers: ["Authorization" : "Bearer \(authToken!)"])
            .responseJSON { [weak self] response in
                print(response)
                let body = response.value as! NSDictionary
                let chatToken = body["token"]! as! String
                let apiKey = body["apiKey"] as! String
                
                if let user = self?.user {
                    StreamChatClient.Client.config = .init(apiKey: apiKey, logOptions: .info)
                    StreamChatClient.Client.shared.set(
                        user: StreamChatClient.User(id: user),
                        token: chatToken
                    )
                    self?.isAuthed = true
                }
        }
    }
}
