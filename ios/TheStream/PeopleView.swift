import SwiftUI
import VoxeetSDK

struct PeopleView: View {
    @EnvironmentObject var account: Account
    @State var users: [String] = []
    @State var showFollowedAlert: Bool = false
    @State var tag: Int? = nil
    @State var calls: [NSDictionary] = []
    
    let pub = NotificationCenter.default.publisher(for: .VTConferenceDestroyed)
    
    
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
                    Image(systemName: "video")
                        .foregroundColor(self.videoIconColor(self.users[i]))
                        .onTapGesture { self.startConferenceCall(self.users[i]) }
                    Image(systemName: "plus.circle").onTapGesture {
                        self.account.follow(self.users[i]) {
                            self.showFollowedAlert = true
                        }
                    }
                }
            }
        }
        .onAppear(perform: fetch)
        .onReceive(pub) { data in
            guard let conference =  data.userInfo!.values.first as? VTConference else {return}
            
            self.account.stopCall(conference.id) {
                self.fetch()
            }
        }
        .alert(isPresented: $showFollowedAlert) {
            Alert(title: Text("Followed"))
        }
    }
    
    private func fetch() {
        account.fetchUsers { users in
            self.users = users.filter { $0 != self.account.user! }
        }
        
        account.fetchCalls { calls in
            self.calls = calls
        }
    }
    
    private func startConferenceCall(_ otherUser: String) {
        let options = VTConferenceOptions()
        let alias =  [self.account.user!, otherUser].sorted().joined(separator: "-")
        options.alias = alias
        
        VoxeetSDK.shared.conference.create(options: options, success: { conference in
            self.account.startCall(otherUser, conference.id)
            
            let joinOptions = VTJoinOptions()
            
            VoxeetSDK.shared.conference.join(conference: conference, options: joinOptions, fail: { error in print(error) })
        }, fail: { error in print(error) })
    }
    
    private func videoIconColor(_ user: String) -> Color {
        if (self.calls.filter { $0["from"] as! String == user }.isEmpty) {
            return Color.black
        } else {
            return Color.red
        }
    }
}

struct PeopleView_Previews: PreviewProvider {
    static var previews: some View {
        PeopleView(users: ["bob", "sara"])
    }
}
