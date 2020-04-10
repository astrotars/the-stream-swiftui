import SwiftUI
import Combine
import GetStream
import GetStreamActivityFeed
import Alamofire

final class Account: ObservableObject {
    @Published var user: String = ""
    
    func login(_ userToLogIn: String) {
        
        Alamofire
            .request("https://399cf11e.ngrok.io/v1/users",
                     method: .post,
                     parameters: ["user" : userToLogIn],
                     encoding: JSONEncoding.default)
            .responseJSON { response in
                print(response)
//                Client.config = .init(apiKey: response["apiKey"]!,
//                                      appId: response[""])
//
//
//                Client.shared.setupUser(
//                    GetStreamActivityFeed.User(name: username,
//                                               id: username),
//                    token: "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoidXNlci1vbmUifQ.sdK3E8Y-ZYuIY7VWK6-9kQ5gWKZNfJL6KBr_p-BsVak"
//                ) { [weak self] (result) in self?.username = "blah"
//
//                }
        }
        
        
        
    }
    
    var isLoggedIn: Bool {
        !user.isEmpty
    }
}
