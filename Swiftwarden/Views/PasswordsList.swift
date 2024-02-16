import Foundation
import NukeUI
import SwiftUI
import CoreImage
import Nuke

struct PasswordsList: View, Equatable {
    @EnvironmentObject var account: Account
    @Environment(\.route) var routeManager: RouteManager
    @Binding var searchText: String
    @State private var deleteDialog = false
    @State private var itemType: ItemType?
    @State private var filtered: [Cipher] = []
    @State private var isLoading = false
    var folderID: String?
    let prefetcher = ImagePrefetcher()
    
    static func == (lhs: PasswordsList, rhs: PasswordsList) -> Bool {
        lhs.searchText == rhs.searchText && lhs.display == rhs.display && lhs.selection == rhs.selection
    }
    
    

    var display: PasswordListType
    func passwordsToDisplay() -> [Cipher] {
        var ciphers: [Cipher]
        switch display {
        case .normal:
            ciphers = account.user.getCiphers()
        case .trash:
            ciphers = account.user.getTrash()
        case .favorite:
            ciphers = account.user.getFavorites()
        case .login:
            ciphers = account.user.getLogins()
        case .card:
            ciphers = account.user.getCards()
        case .folder:
            ciphers = account.user.getCiphersInFolder(folderID: folderID)
        case .identity:
            ciphers = account.user.getIdentities()
        case .secureNote:
            ciphers = account.user.getSecureNotes()
        }
        let filtered = ciphers.filter { cipher in
            return cipher.name?.lowercased().contains(searchText.lowercased()) ?? false || searchText == ""
        }
//        Task {
//            var urls: [URL] = []
//            for cipher in filtered {
//                if let url = URL(string: cipher.login?.domain ?? "") {
//                    urls.append(url)
//                }
//            }
//            prefetcher.startPrefetching(with: urls)
//        }
        
        return filtered
    }
    
    private func loadData() {
            guard !isLoading else { return }
            let _ = print("loadData")
            isLoading = true
            DispatchQueue.global().async {
                let loadedCiphers = passwordsToDisplay()

                DispatchQueue.main.async {
                    filtered = loadedCiphers
                    isLoading = false
                }
            }
        }
    
    init(searchText: Binding<String>, display: PasswordListType, folderID: String? = nil) {
        self._searchText = searchText
        self.display = display
        self.folderID = folderID
    }
    

    @State var selection: Set<Int> = []
    var body: some View {
        let _ = print("list")
        List(filtered.indices, id: \.self, selection: $selection) { index in
                    let cipher = filtered[index]
                    HStack {
                        Icon(itemType: ItemType.intToItemType(cipher.type ?? 1), hostname: cipher.login?.domain, api: account.api)
                        Spacer().frame(width: 20)
                            VStack {
                                if let name = cipher.name {
                                    Text(name)
                                        .id(UUID())
                                        .font(.system(size: 15)).fontWeight(.semibold)
                                        .frame(maxWidth: .infinity, alignment: .topLeading)
                                }
                                Spacer().frame(height: 5)
                                if let username = cipher.login?.username {
                                    Text(verbatim: username)
                                        .font(.system(size: 10))
                                        .frame(maxWidth: .infinity, alignment: .topLeading)
                                }
                                if let number = cipher.card?.number {
                                    let lastFour = number.count != 0 ? "*" + String(number.suffix(4)) : ""
                                    Text(verbatim: lastFour)
                                        .font(.system(size: 10))
                                        .frame(maxWidth: .infinity, alignment: .topLeading)
                                }
                                if let identity = cipher.identity {
                                    let firstName = identity.firstName != nil ? identity.firstName! + " " : ""
                                    Text(verbatim: firstName + (identity.lastName ?? ""))
                                        .font(.system(size: 10))
                                        .frame(maxWidth: .infinity, alignment: .topLeading)
                                }
                                if cipher.secureNote != nil, let notes = cipher.notes {
                                    let previewLength = 30
                                    let previewNotes = notes.count > previewLength ? String(notes.prefix(previewLength)) + "..." : String(notes.prefix(previewLength))
                                    Text(verbatim: previewNotes)
                                        .font(.system(size: 10))
                                        .frame(maxWidth: .infinity, alignment: .topLeading)
                                }
                            }
                            if cipher.favorite ?? false {
                                Spacer()
                                Image(systemName: "star.fill")
                                    .animation(.default, value: cipher.favorite)
                                    .foregroundColor(Color.yellow)
                            }
                    }
                    .tag(index)
//                    .alignmentGuide(.listRowSeparatorLeading) { viewDimensions in
//                        return 0
//                    }
                    .padding(5)
                    .listRowSeparator(.hidden)
        }
        .onChange(of: selection) { selected in
//            account.lastSelected = selected.first
            if let max = selected.max(){
            routeManager.lastSelected = filtered[max]
//            let _ = print(account.lastSelected)
            }
//            account.selectedCiphers = selected.map { filtered[$0] }
        }
        .onAppear {
            loadData()
            print("appeared")
        }
        .onChange(of: searchText) { _ in
            loadData()
        }
        .onReceive(account.user.$data) { data in
            DispatchQueue.main.async {
                loadData()
            }
        }
        .animation(.default, value: filtered)
        .toolbar {
            ToolbarItem {
                Menu {
                    Button {
                        Task {
                            itemType = .password
                        }
                    } label: {
                        Label("Add Password", systemImage: "key")
                            .foregroundColor(.primary)
                            .labelStyle(.titleAndIcon)
                    }
                    Button {
                        Task {
                            itemType = .card
                        }
                    } label: {
                        Label("Add Card", systemImage: "creditcard")
                            .foregroundColor(.primary)
                            .labelStyle(.titleAndIcon)
                    }
                    Button {
                        itemType = .identity
                    } label: {
                        Label("Add Identity", systemImage: "person")
                            .foregroundColor(.primary)
                            .labelStyle(.titleAndIcon)
                    }
                    Button {
                        itemType = .secureNote
                    } label: {
                        Label("Add Secure Note", systemImage: "doc.text")
                            .foregroundColor(.primary)
                            .labelStyle(.titleAndIcon)
                    }
                } label: {
                    Image(systemName: "plus")
                }
            }

        }
        .frame(minWidth: 350, idealWidth: 500)
        .sheet(item: $itemType) { itemType in
            let binding = Binding<ItemType?>(get: { itemType }, set: { self.itemType = $0 })
            
            AddNewItemPopup(itemType: binding)
                .environmentObject(account)
        }
    }
}

//struct PasswordsList_Previews: PreviewProvider {
//    static var previews: some View {
//        PasswordsList(searchText: .constant(""), display: .normal)
//    }
//}

