import Foundation
import SwiftUI
import CoreImage

struct PasswordsList: View {
    @Binding var searchText : String
    @EnvironmentObject var appState: AppState
    @State var deleteDialog = false
    var display : PasswordListType
    func passwordsToDisplay() -> [Cipher] {
            switch display {
            case .normal:
                return appState.account.getCiphers()
            case .trash:
                return appState.account.getTrash()
            case .favorite:
                return appState.account.getFavorites()
            case .card:
                return appState.account.getCards()
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
                ForEach(passwordsToDisplay().filter { cipher in
                    cipher.name?.lowercased().contains(searchText.lowercased()) ?? false || searchText == ""
                }, id: \.self) { cipher in
                    let url = URL(string: cipher.login?.uris?[0].uri ?? " ")
                    let hostname = url?.host ?? "null"
                    NavigationLink(
                        destination: {
                            ItemView(cipher: cipher,  hostname: hostname, favourite: cipher.favorite ?? false).background(.white).onAppear(perform: {
                                appState.selectedCipher = cipher
                            }).environmentObject(appState)
                        },
                        label: {
                            Group {
                                if (hostname != "null"){
                                    AsyncImage(url: URL(string: "https://vaultwarden.seeligsohn.com/icons/\(hostname)/icon.png")) { image in
                                        image.resizable()
                                    } placeholder: {
                                        ProgressView()
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
        }.toolbar(content: {
            ToolbarItem{
                Button (action: {
                    deleteDialog = true
                }){
                    Label("Delete", systemImage: "trash").labelStyle(.titleAndIcon)
                }.confirmationDialog("Are you sure you would like to delete the password?", isPresented: $deleteDialog) {
                    Button("Delete") {
                                Task {
                                    do {
                                        try await appState.account.deleteCipher(cipher: appState.selectedCipher)
                                        appState.selectedCipher = Cipher()
                                    } catch {
                                        print(error)
                                    }
                                }
                            }
                }
            }
        })
    }
}
