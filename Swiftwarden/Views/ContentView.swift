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

private struct RouterKey: EnvironmentKey {
    static let defaultValue: RouteManager = .init()
}

private struct ApiManagerKey: EnvironmentKey {
    static let defaultValue: Api = .init()
}

private struct AccountDataManagerKey: EnvironmentKey {
    static let defaultValue: AccountData = .init()
}

private struct AppStateManagerKey: EnvironmentKey {
    static let defaultValue: AppState = .init()
}

extension EnvironmentValues {
    
    var route: RouteManager {
        get { self[RouterKey.self] }
        set { self[RouterKey.self] = newValue }
    }
    
    var api: Api {
        get { self[ApiManagerKey.self] }
        set { self[ApiManagerKey.self] = newValue }
    }
    
    var data: AccountData {
        get { self[AccountDataManagerKey.self] }
        set { self[AccountDataManagerKey.self] = newValue }
    }
    
    var appState: AppState {
        get { self[AppStateManagerKey.self] }
        set { self[AppStateManagerKey.self] = newValue }
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
                .environment(\.data, appState.account.user.data)
                .environment(\.api, appState.account.api)
                .environment(\.appState, appState)
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
