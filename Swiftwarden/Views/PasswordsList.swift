import Foundation
import NukeUI
import SwiftUI
import CoreImage

struct PasswordsList: View {
    @Binding var searchText : String
    @EnvironmentObject var account: Account
    @State var deleteDialog = false
    @State private var showNew = false
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
    
    func extractHost(cipher: Cipher) -> String {
        if let uri = cipher.login?.uri {
            if let noScheme = uri.split(separator:"//").dropFirst().first, let host = noScheme.split(separator:"/").first {
                return String(host)
            } else {
                return uri
            }
        }
        return ""
    }
    
    var body: some View {
        let filtered = passwordsToDisplay().filter { cipher in
            cipher.name?.lowercased().contains(searchText.lowercased()) ?? false || searchText == ""
        }
        
        
        return List {
            ForEach(filtered, id: \.self.id) { cipher in
                let hostname = extractHost(cipher: cipher) // Move the declaration here
                NavigationLink(
                    destination: {
                        if let card = cipher.card {
                            CardView(card: card)
                        } else {
                            ItemView(cipher: cipher, favorite: cipher.favorite ?? false).onAppear(perform: {
                                account.selectedCipher = cipher
                            }).environmentObject(account)
                        }
                    },
                    label: {
                        Icon(hostname: hostname ?? "", account: account)
                        Spacer().frame(width: 20)
                        VStack{
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
        }
        .animation(.default, value: filtered)
//        .listStyle(.inset(alternatesRowBackgrounds: true))
        .toolbar {
            ToolbarItem {
                Button{
                    showNew = true
                }
                label: {Image(systemName: "plus")}
            }
        }
        .sheet(isPresented: $showNew) {
            PopupNew(show: $showNew)
                .environmentObject(account)
                .onDisappear {
                    account.user.objectWillChange.send()
                }
        }
    }
}
