import SwiftUI
import GetStream

struct PeopleView: View {
    @State var users: [String] = []
    @State var showFollowedAlert: Bool = false
    @EnvironmentObject var account: Account
    
    var body: some View {
        List {
            ForEach(users, id: \.self) { user in
                HStack() {
                    Text(user)
                    Spacer()
                    Image(systemName: "plus.circle").onTapGesture {
                        self.account.follow(user) {
                            self.showFollowedAlert = true
                        }
                    }
                }
            }
        }
        .onAppear(perform: fetch)
        .alert(isPresented: $showFollowedAlert) {
            Alert(title: Text("Followed"))
        }
    }
    
    private func fetch() {
        account.fetchUsers { users in
            self.users = users.filter { $0 != self.account.user! }
        }
    }
}

struct PeopleView_Previews: PreviewProvider {
    static var previews: some View {
        PeopleView(users: ["bob", "sara"])
    }
}
