import SwiftUI
import StreamChat
import StreamChatCore

struct ChannelsView: View {
    @EnvironmentObject var account: Account
    @State var channelName: String = ""
    
    private var channelsPresenter: ChannelsPresenter = ChannelsPresenter(filter: .in("type", ["livestream"]))
    
    var body: some View {
        VStack {
            HStack() {
                TextField("Start new channel...", text: $channelName, onCommit: createChannel)
                Button(action: createChannel) { Text("Create") }
            }.padding()
            StreamChannelsView(
                channelsPresenter: channelsPresenter
            )
        }
    }
    
    private func createChannel() {
        if (!channelName.isBlank) {
            account.createPublicChannel(channelName) { channel in
                self.channelName = ""
                self.channelsPresenter.reload()
            }
        }
    }
}

struct StreamChannelsView: UIViewControllerRepresentable {
    var channelsPresenter: ChannelsPresenter
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<StreamChannelsView>) -> ChannelsViewController {
        let vc = ChannelsViewController()
        vc.presenter = channelsPresenter
        return vc
    }
    
    func updateUIViewController(_ uiViewController: ChannelsViewController, context: UIViewControllerRepresentableContext<StreamChannelsView>) {
        
    }
}

struct ChannelsView_Previews: PreviewProvider {
    static var previews: some View {
        ChannelsView()
    }
}
