import SwiftUI
import StreamChat
import StreamChatCore

struct PrivateChatView: View {
    var user: String
    var withUser: String

    @EnvironmentObject var account: Account
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
        account.createPrivateChannel([user, withUser]) { channel in
            self.channelPresenter = ChannelPresenter(
                channel: channel
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
