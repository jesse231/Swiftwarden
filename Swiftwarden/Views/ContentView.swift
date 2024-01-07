import SwiftUI
import UniformTypeIdentifiers

extension View {
    private func newWindowInternal(with title: String) -> NSWindow {
        let window = NSWindow(
            contentRect: NSRect(x: 20, y: 20, width: 680, height: 600),
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered,
            defer: false)
        window.center()
        window.isReleasedWhenClosed = false
        window.title = title
        window.makeKeyAndOrderFront(nil)
        return window
    }

    func openNewWindow(with title: String = "new Window") {
        self.newWindowInternal(with: title).contentView = NSHostingView(rootView: self)
    }
}

class Account: ObservableObject {
    @Published var user = User()
    var selectedCiphers: [Cipher] = []
    @Published var api: Api = Api()
}

struct ContentView: View {
    @State var loginSuccess = false
    var account = Account()
    var body: some View {
        if loginSuccess {
            MainView().environmentObject(account)
                .environment(\.api, account.api)
        } else {
            LoginView(loginSuccess: $loginSuccess).environmentObject(account)
        }

    }
}

struct ContentView_Previews: PreviewProvider {

    static var previews: some View {
        Group {
            ContentView()
        }
    }
}
