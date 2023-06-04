import Foundation
import NukeUI
import SwiftUI

func extractHost(cipher: Cipher?) -> String {
    if let cipher {
        if let uri = cipher.login?.uri {
            if let noScheme = uri.split(separator: "//").dropFirst().first, let host = noScheme.split(separator: "/").first {
                return String(host)
            } else {
                return uri
            }
        }
    }
    return ""
}

func extractHostURI(uri: String?) -> String {
    if let uri {
        if let noScheme = uri.split(separator: "//").dropFirst().first, let host = noScheme.split(separator: "/").first {
                return String(host)
            } else {
                return uri
            }
        }
    return ""
}

extension ItemView {
    struct RegularView: View {
        @Binding var cipher: Cipher?
        @Binding var editing: Bool
        @Binding var reprompt: RepromptState
        @State var showReprompt: Bool = false
        @State var showPassword: Bool = false
        
        @StateObject var account: Account
        
        func delete() async throws {
            if let cipher {
                do {
                    try await account.user.deleteCipher(cipher: cipher)
                    account.selectedCipher = Cipher()
                    self.cipher = nil
                } catch {
                    print(error)
                }
            }
        }
        func deletePermanently() async throws {
            if let cipher {
                do {
                    try await account.user.deleteCipherPermanently(cipher: cipher)
                    account.selectedCipher = Cipher()
                    self.cipher = nil
                } catch {
                    print(error)
                }
            }
        }
        
        var body: some View {
            Group{
                HStack {
                    if cipher?.deletedDate == nil {
                        Button {
                            Task {
                                try await delete()
                            }
                        } label: {
                            Text("Delete")
                        }
                        Spacer()
                        Button {
                            editing = true
                        } label: {
                            Text("Edit")
                        }
                    } else {
                        Spacer()
                        Button {
                            Task {
                                try await deletePermanently()
                            }
                        } label: {
                            Text("Delete Permanently")
                        }
                    }
                }
                
                ScrollView {
                    VStack {
                        HStack {
                            Icon(hostname: extractHost(cipher: cipher), account: account)
                            VStack {
                                Text(cipher?.name ?? "")
                                    .font(.system(size: 15))
                                    .fontWeight(.semibold)
                                    .frame(maxWidth: .infinity, alignment: .topLeading)
                                Text(verbatim: "Login")
                                    .font(.system(size: 10))
                                    .frame(maxWidth: .infinity, alignment: .topLeading)

                            }
                            FavoriteButton(cipher: $cipher, account: account)

                        }
                        Divider()
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
                                content: (showPassword ? password : String(repeating: "•", count: password.count)),
                                buttons: {
                                    TogglePassword(showPassword: $showPassword, reprompt: $reprompt, showReprompt: $showReprompt)
                                    Copy(content: password)
                                })
                        }
                        if let uris = cipher?.login?.uris {
                            ForEach(uris, id: \.self.id) { uri in
                                let url = uri.uri
                                if url != "" {
                                    Field(
                                        title: "Website",
                                        content: extractHostURI(uri: url),
                                        buttons: {
                                            Open(link: url)
                                            Copy(content: url)
                                        })
                                }
                            }
                        }
                        
                    }
                    .padding(.trailing)
                }
            }
                    .frame(maxWidth: .infinity)
                    .popover(isPresented: $showReprompt) {
                        RepromptPopup(showReprompt: $showReprompt, showPassword: $showPassword, reprompt: $reprompt, account: account)
                    }

            }
    }

    
}
struct ItemViewRegularPreview: PreviewProvider {
    static var previews: some View {
        let cipher = Cipher(login: Login(password: "test", username: "test"), name: "Test")
        let account = Account()

        Group {
            ItemView(cipher: cipher, favorite: true)
                .environmentObject(account)
        }
    }
}

