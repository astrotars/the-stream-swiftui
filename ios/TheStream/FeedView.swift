import SwiftUI
import MapKit
import GetStream
import GetStreamActivityFeed

struct FeedRow: View {
    var item: FeedItem
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(item.message)
                .font(.headline)
            Text(item.actor.id)
                .font(.caption)
        }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
    }
}

struct FeedView: View {
    var items: [FeedItem]
    
    var body: some View {
        List {
            ForEach(items) { item in
                FeedRow(item: item)
            }
        }
    }
}

struct FeedView_Previews: PreviewProvider {
    static var previews: some View {
        FeedView(items: [])
    }
}
