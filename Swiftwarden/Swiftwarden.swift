import SwiftUI
import Cocoa
import AppKit
class AppState: ObservableObject {
    @Published var loggedIn = false
    @Published var selectedType: PasswordListType = .login
    @Published var email = UserDefaults.standard.string(forKey: "email") {
        didSet {
            let defaults = UserDefaults.standard
            defaults.set(email, forKey: "email")
        }
    }
    @Published var server = UserDefaults.standard.string(forKey: "server") { didSet {
        let defaults = UserDefaults.standard
        defaults.set(server, forKey: "server")
    }
        
    
    }
    var account = Account()
}

class AppDelegate: NSObject, NSApplicationDelegate {
    private var windowControllers: [NSWindowController] = []

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        showBlurredWindow()
    }

    private func showBlurredWindow() {
        guard let window = NSApplication.shared.windows.first else { assertionFailure(); return }


        window.styleMask.insert(NSWindow.StyleMask.fullSizeContentView)
        window.titlebarAppearsTransparent = true
    }
}
struct VisualEffectView: NSViewRepresentable {
    func makeNSView(context: Context) -> NSVisualEffectView {
        let effectView = NSVisualEffectView()
        effectView.state = .active
        return effectView
    }
    
    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {
    }
}



@main
struct SwiftwardenApp: App {
    @StateObject var appState = AppState()
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
        }
        .commands {
            SidebarCommands()
            ToolbarCommands()
        }
        .windowToolbarStyle(.unified(showsTitle: true))
        .windowStyle(.titleBar)
    }
}
