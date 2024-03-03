import Foundation
import NukeUI
import SwiftUI

extension ItemView {
    struct PasswordView: View, Equatable {
        static func == (lhs: ItemView.PasswordView, rhs: ItemView.PasswordView) -> Bool {
            lhs.cipher == rhs.cipher
        }
        
        @Binding var cipher: Cipher?
        @Binding var editing: Bool
        @Binding var reprompt: RepromptState
        @State var showReprompt: Bool = false
        @State var showPassword: Bool = false
        
        @Environment(\.api) var api: Api
        
        func delete() async throws {
            if let cipher {
                do {
//                    try await account.user.deleteCipher(cipher: cipher)
                    self.cipher = nil
                } catch {
                    print(error)
                }
            }
        }
        func deletePermanently() async throws {
            if let cipher {
                do {
//                    try await account.user.deleteCipherPermanently(cipher: cipher)
                    self.cipher = nil
                } catch {
                    print(error)
                }
            }
        }
        func restore() async throws {
            if let cipher {
                do {
//                    try await account.user.restoreCipher(cipher: cipher)
                    self.cipher = nil
                } catch {
                    print(error)
                }
            }
        }
        
        var body: some View {

            VStack {
                HStack {
                    Icon(itemType: .password, hostname: cipher?.login?.domain, api: api)
                    VStack {
                        Text(cipher?.name ?? "")
                            .font(.system(size: 15))
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity, alignment: .topLeading)
                        Text(verbatim: "Login")
                            .font(.system(size: 10))
                            .frame(maxWidth: .infinity, alignment: .topLeading)
                    }
                    FavoriteButton(cipher: $cipher)
                }
                .padding([.leading,.trailing], 5)
                Divider()
                    .padding([.leading,.trailing], 5)
                ScrollView {
                    Group {
                        if let username = cipher?.login?.username {
                            Field(
                                title: "Username",
                                content: username,
                                buttons: {
                                    Copy(content: username)
                                })
                        }
                        if let password = cipher?.login?.password {
                            Field(
                                title: "Password",
                                content: password,
                                secure: true,
                                reprompt: $reprompt,
                                showReprompt: $showReprompt,
//                                email: account.user.getEmail(),
                                buttons: {
                                    Copy(content: password)
                                })
                        }
                        if let uris = cipher?.login?.uris {
                            ForEach(uris, id: \.self.id) { uri in
                                if let url = uri.uri {
                                    if url != "" {
                                        Field(
                                            title: "Website",
                                            content: extractHostURI(uri: url),
                                            buttons: {
                                                if hasScheme(url) {
                                                    Open(link: url)
                                                } else {
                                                    Open(link: "https://" + url)
                                                }
                                                Copy(content: url)
                                            })
                                    }
                                }
                            }
                        }
                        if let fields = cipher?.fields {
                            CustomFieldsView(fields)
                        }

                        if let notes = cipher?.notes {
                            Field(title: "Note", content: notes, buttons: {})
                        }
                    }
                    .padding([.trailing])
                }
                .padding(.trailing)
            }
            .frame(maxWidth: .infinity)
            .toolbar {
                RegularCipherOptions(cipher: $cipher, editing: $editing)
        }
            
        }
    }
    
    
}


struct ItemView_PasswordView_Previews: PreviewProvider {
    static var previews: some View {
        @State var cipher: Cipher? = Cipher(favorite: false, id: "1", login: Login(password: "test", uris: [Uris(uri: "https://google.com")], username: "test"), name: "Test", type: 1)
        ItemView.PasswordView(cipher: $cipher, editing: .constant(false), reprompt: .constant(.none))
    }
}
