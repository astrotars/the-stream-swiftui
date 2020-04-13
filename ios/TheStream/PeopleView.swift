import SwiftUI
import GetStream

struct PeopleView: View {
    @State var users: [String] = []
    @EnvironmentObject var account: Account
    
    var body: some View {
        List {
            ForEach(users, id: \.self) { user in
                Text(user)
            }
        }.onAppear(perform: fetch)
    }
    
    private func fetch() {
        account.fetchUsers { users in
            self.users = users.filter { $0 != self.account.user! }
        }
    }
}

struct PeopleView_Previews: PreviewProvider {
    static var previews: some View {
        PeopleView(users: [])
    }
}
