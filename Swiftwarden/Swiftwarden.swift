import SwiftUI


@main
struct SwiftwardenApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .commands {
            SidebarCommands()
        }
        .windowToolbarStyle(.unified(showsTitle: true))
        .windowStyle(.titleBar)
    }
}
