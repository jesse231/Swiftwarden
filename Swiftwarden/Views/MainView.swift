import SwiftUI
import Combine
class SearchObserver : ObservableObject {
    @Published var debouncedText = ""
    @Published var searchText = ""
    
    private var subscriptions = Set<AnyCancellable>()
    
    init() {
        $searchText
            .debounce(for: .seconds(0.3), scheduler: DispatchQueue.main)
            .sink(receiveValue: { [weak self] t in
                self?.debouncedText = t
            } )
            .store(in: &subscriptions)
    }
}

class RouteManager: ObservableObject {
    @Published var lastSelected: Cipher?
    @Published var selection = Set<Int>()
}

private struct RouterKey: EnvironmentKey {
    static let defaultValue: RouteManager = .init()
}

private struct ApiManagerKey: EnvironmentKey {
    static let defaultValue: Api = .init()
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
}

struct MainView: View {
    @StateObject private var searchObserver = SearchObserver()
    private var routeManager = RouteManager()
    @State private var showEdit: Bool = false
    @State var passwords: [Cipher]?
    @State var deleteDialog: Bool = false
    @State private var toggleSidebar = false
    
    var body: some View {
        NavigationView {
            SideBar(searchResults: $searchObserver.debouncedText)
            HStack{}
            ItemView()
        }
        .environmentObject(routeManager)
        .environment(\.route, routeManager)
        .searchable(text: $searchObserver.searchText)
    }
}

//struct MainViewPreviews: PreviewProvider {
//    static var previews: some View {
//        MainView().environmentObject(Account())
//    }
//}
