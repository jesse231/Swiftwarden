import SwiftUI


@main
struct SwiftwardenApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .windowToolbarStyle(.unified(showsTitle: true))
        .windowStyle(.titleBar)
    }
}
