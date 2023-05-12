import Foundation
import NukeUI
import SwiftUI
import CoreImage

struct PasswordsList: View {
    @Binding var searchText : String
    @EnvironmentObject var user: Account
    @State var deleteDialog = false
    @State private var showNew = false

    var display : PasswordListType
    func passwordsToDisplay() -> [Cipher] {
        switch display {
        case .normal:
            return user.user.getCiphers()
        case .trash:
            return user.user.getTrash()
        case .favorite:
            return user.user.getFavorites()
        case .card:
            return user.user.getCards()
        }
    }
    
    enum PasswordListType {
        case normal
        case trash
        case favorite
        case card
    }
    
    var body: some View {
        List {
            let filtered = passwordsToDisplay().filter { cipher in
                cipher.name?.lowercased().contains(searchText.lowercased()) ?? false || searchText == ""
            }
            
            ForEach(filtered) { cipher in
                let url = (cipher.login?.uris?.isEmpty) ?? true ? nil : URL(string: cipher.login?.uris?[0].uri ?? " ")
                let hostname = url?.host ?? nil
                NavigationLink(
                    destination: {
                        ItemView(cipher: cipher,  hostname: hostname, favourite: cipher.favorite ?? false).onAppear(perform: {
                            user.selectedCipher = cipher
                        }).environmentObject(user)
                    },
                    label: {
                        Group {
                            if let hostname{
                                LazyImage(url: user.api.getIcons(host: hostname)) { state in
                                    if let image = state.image {
                                        image.resizable()
                                    }
                                }
                                .clipShape(Circle())
                                .frame(width: 35, height: 35)
                            } else {
                                Image(systemName: "lock.circle")
                                    .resizable()
                                    .frame(width: 35, height: 35)
                            }
                        }
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
                ).padding(5)
            }
        }
        .listStyle(.inset(alternatesRowBackgrounds: true))
        .toolbar {
            ToolbarItem {
                Button{
                    showNew = true
                }
                label: {Image(systemName: "plus")}
            }
        }
        .sheet(isPresented: $showNew) {
            PopupNew(show: $showNew).environmentObject(user)
        }
    }
}
