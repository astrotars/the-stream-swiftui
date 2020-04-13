//
//  TimelineView.swift
//  TheStream
//
//  Created by Jeff Taggart on 4/13/20.
//  Copyright © 2020 Stream.io Inc. All rights reserved.
//

import SwiftUI

struct TimelineView: View {
    @EnvironmentObject var account: Account
    
    var body: some View {
        FeedView(items: account.timelineItems)
            .onAppear(perform: fetch)
    }
    
    private func fetch() {
        account.fetchTimelineFeed()
    }
}

struct TimelineView_Previews: PreviewProvider {
    static var previews: some View {
        TimelineView()
    }
}
