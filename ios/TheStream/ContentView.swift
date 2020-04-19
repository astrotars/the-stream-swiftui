import SwiftUI

struct ContentView: View {
    @State var user = ""
    @EnvironmentObject var account: Account
    
    func login() {
        account.login(user)
    }
    
    @ViewBuilder
    var body: some View {
        if account.isAuthed {
            NavigationView {
                TabView {
                    TimelineView()
                        .tabItem {
                            Image(systemName: "list.dash")
                            Text("Timeline")
                    }
                    ProfileView()
                        .tabItem {
                            Image(systemName: "person.fill")
                            Text("Profile")
                    }
                    PeopleView()
                        .tabItem {
                            Image(systemName: "person.2.fill")
                            Text("People")
                    }
                    ChannelsView()
                        .tabItem {
                            Image(systemName: "grid.circle")
                            Text("Channels")
                    }
                }
                .navigationBarTitle("TheStream", displayMode: .inline)
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
