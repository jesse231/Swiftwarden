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

struct ContentView: View {
    @State var loginSuccess = false
    @State var account : Account = Account(sync: Response())
    var body: some View {
        if loginSuccess {
            MainView()
        } else {
            LoginView(loginSuccess: $loginSuccess, account: $account)
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
