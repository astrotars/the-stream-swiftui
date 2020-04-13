import SwiftUI
import Combine
import GetStream
import GetStreamActivityFeed
import Alamofire

typealias FeedCompletion = (_ result: [FeedItem]) -> Void
typealias CreateFeedItemCompletion = () -> Void
typealias UsersCompletion = (_ result: [String]) -> Void

final class Account: ObservableObject {
    enum FeedType {
        case profile
        case timeline
    }
    
    @Published var user: String?
    @Published var isAuthed: Bool = false
    @Published var timelineItems: [FeedItem] = []
    @Published var profileItems: [FeedItem] = []
    
    var authToken: String?
    var feedToken: String?
    var userFeed: FlatFeed?
    var timelineFeed: FlatFeed?
    
    func login(_ userToLogIn: String) {
        Alamofire
            .request("https://cb72f977.ngrok.io/v1/users",
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
    
    func fetchFeed(_ feedType: FeedType, completion: @escaping FeedCompletion) {
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
    
    func createFeedItem(_ message: String, completion: @escaping CreateFeedItemCompletion) {
        let activity = FeedItem(actor: User(id: self.user!), verb: "post", object: UUID().uuidString, message: message)
        
        userFeed?.add(activity) { result in
            completion()
        }
    }
    
    func fetchUsers(completion: @escaping UsersCompletion) {
        Alamofire
            .request("https://cb72f977.ngrok.io/v1/users",
                     method: .get,
                     headers: ["Authorization" : "Bearer \(authToken!)"])
            .responseJSON { response in
                let body = response.value as! NSDictionary
                let users = body["users"]! as! [String]
                completion(users)
        }
    }
    
    private func setupFeed() {
        Alamofire
            .request("https://cb72f977.ngrok.io/v1/stream-feed-credentials",
                     method: .post,
                     headers: ["Authorization" : "Bearer \(authToken!)"])
            .responseJSON { [weak self] response in
                print(response)
                let body = response.value as! NSDictionary
                let feedToken = body["token"]! as! String
                let appId = body["appId"] as! String
                let apiKey = body["apiKey"] as! String
                
                if let user = self?.user {
                    Client.config = .init(apiKey: apiKey,
                                          appId: appId)
                    
                    
                    Client.shared.setupUser(
                        GetStreamActivityFeed.User(name: user,
                                                   id: user),
                        token: feedToken
                    ) { [weak self] (result) in
                        self?.isAuthed = true
                        self?.userFeed = Client.shared.flatFeed(feedSlug: "user")
                        self?.timelineFeed = Client.shared.flatFeed(feedSlug: "timeline")
                    }
                }
        }
    }
    
}
