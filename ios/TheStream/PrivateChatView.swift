import SwiftUI
import StreamChat
import StreamChatCore
import StreamChatClient

struct PrivateChatView: View {
    var user: String
    var withUser: String

    @State var channelPresenter: ChannelPresenter?
    
    @ViewBuilder
    var body: some View {
        if (channelPresenter == nil) {
            Text("Loading...").onAppear(perform: loadChannel)
        } else {
            StreamChatView(channelPresenter: channelPresenter!).navigationBarTitle("Chat w/ \(withUser)")
        }
    }
    
    private func loadChannel() {
        let users = [user, withUser]
        let channelId = users.sorted().joined(separator: "-")
        let channel = Client.shared.channel(type: .messaging, id: channelId, members: users.map { User(id: $0) } )
        
        channel.create { (result) in
            self.channelPresenter = ChannelPresenter(
                channel: try! result.get().channel
            )
        }
    }
}

struct StreamChatView: UIViewControllerRepresentable {
    var channelPresenter: ChannelPresenter
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<StreamChatView>) -> ChatViewController {
        let vc = ChatViewController()
        vc.presenter = channelPresenter
        return vc
    }

    func updateUIViewController(_ uiViewController: ChatViewController, context: UIViewControllerRepresentableContext<StreamChatView>) {
        
    }
}

struct PrivateChatView_Previews: PreviewProvider {
    static var previews: some View {
        PrivateChatView(user: "sara", withUser: "bob")
    }
}
