import Foundation
import NukeUI
import SwiftUI
import CoreImage

struct PasswordsList: View, Equatable {
    static func == (lhs: PasswordsList, rhs: PasswordsList) -> Bool {
            return lhs.searchText == rhs.searchText &&
                   lhs.deleteDialog == rhs.deleteDialog &&
                   lhs.itemType == rhs.itemType &&
                   lhs.folderID == rhs.folderID &&
                   lhs.display == rhs.display
        }
    
    @Binding var searchText: String
    @EnvironmentObject var account: Account
    @State private var deleteDialog = false
    @State private var itemType: ItemType?
    var folderID: String?

    var display: PasswordListType
    func passwordsToDisplay() -> [Cipher] {

        switch display {
        case .normal:
            return account.user.getCiphers()
        case .trash:
            return account.user.getTrash()
        case .favorite:
            return account.user.getFavorites()
        case .card:
            return account.user.getCards()
        case .folder:
            return account.user.getCiphersInFolder(folderID: folderID)
        }
    }

    enum PasswordListType {
        case normal
        case trash
        case favorite
        case card
        case folder
    }

    var body: some View {
        let filtered = passwordsToDisplay().filter { cipher in
            cipher.name?.lowercased().contains(searchText.lowercased()) ?? false || searchText == ""
        }

        List(filtered, id: \.self.id) { cipher in
                NavigationLink(
                    destination: {
                            ItemView(cipher: cipher
                            ).onAppear(perform: {
                                account.selectedCipher = cipher
                            }).environmentObject(account)
                    },
                    label: {
                        Icon(itemType: ItemType.intToItemType(cipher.type ?? 1), hostname: cipher.login?.domain, account: account)
                        Spacer().frame(width: 20)
                        VStack {
                            if let name = cipher.name {
                                Text(name)
                                    .font(.system(size: 15)).fontWeight(.semibold)
                                    .frame(maxWidth: .infinity, alignment: .topLeading)
                            }

                            if let username = cipher.login?.username {
                                if username != ""{
                                    Spacer().frame(height: 5)
                                    Text(verbatim: username)
                                        .font(.system(size: 10))
                                        .frame(maxWidth: .infinity, alignment: .topLeading)
                                }
                            }
                        }
                    }
                )
                .padding(5)
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
                            .labelStyle(.titleAndIcon)
                    }
                    Button {
                        Task {
                            itemType = .card
                        }
                    } label: {
                        Label("Add Card", systemImage: "creditcard")
                            .labelStyle(.titleAndIcon)
                    }
                    Button {
                        itemType = .identity
                    } label: {
                        Label("Add Identity", systemImage: "person")
                            .labelStyle(.titleAndIcon)
                    }
                    Button {
                        itemType = .secureNote
                    } label: {
                        Label("Add Secure Note", systemImage: "doc.text")
                            .labelStyle(.titleAndIcon)
                    }
                } label: {Image(systemName: "plus")}
            }
            
        }
        .sheet(item: $itemType) { itemType in
            let binding = Binding<ItemType?>(get: { itemType }, set: { self.itemType = $0 })
            
            AddNewItemPopup(itemType: binding)
                .environmentObject(account)
                .onDisappear {
                    account.user.objectWillChange.send()
                }
        }
    }
}
