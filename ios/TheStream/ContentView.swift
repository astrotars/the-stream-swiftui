import SwiftUI
import GetStream
import GetStreamActivityFeed

struct ContentView: View {
    @State var user: String = ""
    @EnvironmentObject var account: Account
    
    func login() {
        account.login(user)
    }
    
    var body: some View {
        HStack() {
            if account.isAuthed {
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
                }
            } else {
                VStack(alignment: .leading) {
                    Text("Type a username to log in")
                        .font(.headline)
                    TextField("Type a username", text: $user, onCommit: login)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                    Button(action: login) { Text("Login") }
                        .frame(maxWidth: .infinity, maxHeight: 35)
                        .foregroundColor(Color.white)
                        .background(Color.blue)
                        .cornerRadius(5)
                }.padding()
                
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
