import Foundation
import SwiftUI
import CoreImage

struct PasswordsList: View {
    var ciphers: [Cipher]?
    @State var searchText = ""
    @EnvironmentObject var allPasswords: Passwords
    var body: some View {
        if let _ = allPasswords.searchResults {
        List {
            if let ciphers = ciphers {
                ForEach(ciphers, id: \.self) { cipher in
                    let url = URL(string: cipher.Login?.Uris?[0].Uri ?? " ")
                    let hostname = url?.host ?? "null"
                    NavigationLink(
                        destination: {
                            ItemView(cipher: cipher,  hostname: hostname, favourite: cipher.Favorite ?? false).background(.white).onAppear(perform: {
                                allPasswords.currentPassword = cipher
                            }).environmentObject(allPasswords)
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
                                if let name = cipher.Name {
                                    Text(name)
                                        .font(.system(size: 15)).fontWeight(.semibold)
                                        .frame(maxWidth: .infinity, alignment: .topLeading)
                                }
                                
                                if let username = cipher.Login?.Username {
                                    Spacer().frame(height: 5)
                                    Text(verbatim: username)
                                        .font(.system(size: 10))
                                        .frame(maxWidth: .infinity, alignment: .topLeading)
                                }
                            }
                        }
                    ).padding(5)
                }
            } else {
                Text("Loading...")
                
            }
        }.searchable(text: $searchText).onChange(of: searchText) {_ in do {
            if searchText.isEmpty{
                allPasswords.searchResults = allPasswords.passwords
            } else {
                allPasswords.searchResults =  allPasswords.passwords.filter({$0.Name?.lowercased().contains(searchText) ?? false})
            }
        }
        }
        } else {
            Text("Loading...")
        }
    }
}
