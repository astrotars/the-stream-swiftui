import SwiftUI
import MapKit
import GetStream
import GetStreamActivityFeed

struct FeedView: View {
    @EnvironmentObject var account: Account
    
    var body: some View {
        Text("hello, \(account.user!)")
    }
}

struct FeedView_Previews: PreviewProvider {
    static var previews: some View {
        FeedView()
    }
}
