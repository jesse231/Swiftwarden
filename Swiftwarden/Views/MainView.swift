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
struct MainView: View {
    @StateObject private var searchObserver = SearchObserver()
    @EnvironmentObject var account: Account
    @State private var showEdit: Bool = false
    @State var passwords: [Cipher]?
    @State var deleteDialog: Bool = false
    @State private var toggleSidebar = false
    
    var body: some View {
        NavigationView {
            SideBar(searchResults: $searchObserver.debouncedText).environmentObject(account)
            PasswordsList(searchText: $searchObserver.debouncedText, display: .normal)
                .environmentObject(account)
                .frame(minWidth: 400)
            ItemView(cipher: nil)
            
        }
        .sheet(isPresented: $showEdit, content: {
            let selected = account.selectedCipher
            PopupEdit(name: account.selectedCipher.name ?? "", username: (selected.login?.username) ?? "", password: (account.selectedCipher.login?.password) ?? "", show: $showEdit).environmentObject(account)
        })
        .searchable(text: $searchObserver.searchText)
    }
}

struct MainViewPreviews: PreviewProvider {
    static var previews: some View {
        MainView().environmentObject(Account())
    }
}
