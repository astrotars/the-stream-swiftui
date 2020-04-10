import SwiftUI
import Combine
import GetStream
import GetStreamActivityFeed

final class Account: ObservableObject {
    @Published var username: String = ""
    
    func login() {
        Client.config = .init(apiKey: "t2umkdedhcb6",
                              appId: "65277")
        Client.shared.setupUser(
            GetStreamActivityFeed.User(name: "User One",
                                       id: "user-one"),
            token: "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoidXNlci1vbmUifQ.sdK3E8Y-ZYuIY7VWK6-9kQ5gWKZNfJL6KBr_p-BsVak"
        ) { [weak self] (result) in self?.username = "blah"
            
        }

    }
    
    var isLoggedIn: Bool {
        !username.isEmpty
    }
}
