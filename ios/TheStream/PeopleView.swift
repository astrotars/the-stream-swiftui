import SwiftUI
import VoxeetSDK

struct PeopleView: View {
    @EnvironmentObject var account: Account
    @State var users: [String] = []
    @State var showFollowedAlert: Bool = false
    @State var tag: Int? = nil
    
    var body: some View {
        List {
            ForEach(users.indices, id: \.self) { i in
                HStack() {
                    Text(self.users[i]).onTapGesture {
                        self.tag = i
                    }
                    NavigationLink(destination: PrivateChatView(user: self.account.user!, withUser: self.users[i]), tag: i, selection: self.$tag) {
                        Spacer()
                    }
                    Image(systemName: "message").onTapGesture {
                        self.tag = i
                    }
                    Image(systemName: "video").onTapGesture {
                        let options = VTConferenceOptions()
                        options.alias = [self.account.user!, self.users[i]].sorted().joined(separator: "-")
                        
                        VoxeetSDK.shared.conference.create(options: options, success: { conference in
                            let joinOptions = VTJoinOptions()
                            joinOptions.constraints.video = false
                            VoxeetSDK.shared.conference.join(conference: conference, options: joinOptions, success: { conference in
                            }, fail: { error in print(error)
                            })
                        }, fail: { error in print(error)
                        })
                    }
                    Image(systemName: "plus.circle").onTapGesture {
                        self.account.follow(self.users[i]) {
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
