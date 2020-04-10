import SwiftUI
import GetStream
import GetStreamActivityFeed

struct BlueView: View {
    var body: some View {
        Color.blue
    }
}

struct ContentView: View {
    @EnvironmentObject var account: Account
    
    var body: some View {
        HStack() {
            if account.isLoggedIn {
                TabView {
                    FeedView()
                        .tabItem {
                            Image(systemName: "list.dash")
                            Text("Timeline")
                    }
                    ProfileView()
                        .tabItem {
                            Image(systemName: "person.fill")
                            Text("Profile")
                    }
                    BlueView()
                        .tabItem {
                            Image(systemName: "person.2.fill")
                            Text("People")
                    }
                    
                }
            } else {
                BlueView()
            }
        }.onAppear() {
            self.account.login()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
