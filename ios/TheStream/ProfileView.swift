import SwiftUI

struct ProfileView: View {
    @State var message: String = ""
    @EnvironmentObject var account: Account
    
    var body: some View {
        VStack() {
            HStack() {
                TextField("Say something...", text: $message, onCommit: createFeedItem)
                Button(action: createFeedItem) { Text("Send") }
            }.padding()
            
            FeedView(items: account.profileItems)
                .onAppear(perform: fetch)
        }
    }
    
    private func createFeedItem() {
        account.createFeedItem(message)
        message = ""
    }
    
    private func fetch() {
        account.fetchProfileFeed()
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
