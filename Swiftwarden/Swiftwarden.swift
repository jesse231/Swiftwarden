import SwiftUI


@main
struct SwiftwardenApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .windowStyle(DefaultWindowStyle())
        .windowToolbarStyle(UnifiedWindowToolbarStyle(showsTitle: true))
        //.windowToolbarStyle(.unifiedCompact)
//        .windowToolbarStyle(UnifiedWindowToolbarStyle(showsTitle: false))//UnifiedWindowToolbarStyle(showsTitle: false))
//                .windowStyle(HiddenTitleBarWindowStyle())

    }
}
