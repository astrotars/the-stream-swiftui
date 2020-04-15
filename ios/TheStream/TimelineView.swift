import SwiftUI

struct TimelineView: View {
    @State var items: [FeedItem] = []
    @EnvironmentObject var account: Account
    
    var body: some View {
        FeedView(items: items)
            .onAppear(perform: fetch)
    }
    
    private func fetch() {
        account.fetchFeed(.timeline) { items in
            self.items = items
        }
    }
}

struct TimelineView_Previews: PreviewProvider {
    static var previews: some View {
        TimelineView()
    }
}
