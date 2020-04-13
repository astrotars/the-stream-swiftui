import SwiftUI
import Combine
import GetStream
import GetStreamActivityFeed
import Alamofire

final class Account: ObservableObject {
    @Published var user: String?
    @Published var isAuthed: Bool = false
    var authToken: String?
    var feedToken: String?
    
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
    
    func setupFeed() {
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
                    }
                }
        }
    }
    
}
