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
    var user = User()
    var api: Api = Api()
    
    func logOut() {
        self.user = User()
        self.api = Api()
    }
}

struct ContentView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var account: Account
    var body: some View {
        if !appState.loggedIn {
            LoginView(loginSuccess: $appState.loggedIn)
                .frame(minWidth: 400, maxWidth: .infinity, maxHeight: .infinity)
                .background(VisualEffectView().ignoresSafeArea())
                .environmentObject(appState.account)
        } else {
            MainView()
                .environmentObject(appState.account)
                .environmentObject(appState.account.user.data)
                .environment(\.api, appState.account.api)
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
