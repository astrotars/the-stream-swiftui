import SwiftUI

struct ProfileView: View {
    @State var message: String = ""
    @State var items: [FeedItem] = []
    @EnvironmentObject var account: Account
    
    var body: some View {
        VStack() {
            HStack() {
                TextField("Say something...", text: $message, onCommit: createFeedItem)
                Button(action: createFeedItem) { Text("Send") }
            }.padding()
            FeedView(items: items)
        }.onAppear(perform: fetch)
    }
    
    private func createFeedItem() {
        account.createFeedItem(message) { self.fetch() }
        message = ""
    }
    
    private func fetch() {
        account.fetchFeed(.profile) { items in
            self.items = items
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(items: [])
    }
}
