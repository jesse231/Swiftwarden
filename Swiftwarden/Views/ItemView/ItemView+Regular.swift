import Foundation
import NukeUI
import SwiftUI

extension ItemView {
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

    func extractHost(uri: Uris) -> String {
        if let noScheme = uri.uri.split(separator: "//").dropFirst().first, let host = noScheme.split(separator: "/").first {
                return String(host)
            } else {
                return uri.uri
        }
    }

    var RegularView: some View {
            Group {
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
                            Icon(hostname: hostname, account: account)
                            VStack {
                                Text(name)
                                    .font(.system(size: 15))
                                    .fontWeight(.semibold)
                                    .frame(maxWidth: .infinity, alignment: .topLeading)
                                Text(verbatim: "Login")
                                    .font(.system(size: 10))
                                    .frame(maxWidth: .infinity, alignment: .topLeading)

                            }
                            FavoriteButton(favorite: $favorite, cipher: $cipher, account: account)

                        }
                        Divider()
                        if cipher?.login?.username != nil {
                            Field(
                                title: "Username",
                                content: username,
                                buttons: {
                                    Copy(content: username)
                                })
                        }
                        if cipher?.login?.password != nil {
                            Field(
                                title: "Password",
                                content: (showPassword ? password : String(repeating: "•", count: password.count)),
                                buttons: {
                                    Hide(toggle: $showPassword)
                                    Copy(content: password)
                                })
                        }
                        if let uris = cipher?.login?.uris {
                            ForEach(uris, id: \.self.id) { uri in
                                if uri.uri != "" {
                                    Field(
                                        title: "Website",
                                        content: extractHost(uri: uri),
                                        buttons: {
                                            Open(link: uri.uri)
                                            Copy(content: uri.uri)
                                        })
                                }
                            }
                        }

                    }
                    .padding(.trailing)
                    //Spacer()
                }
                .frame(maxWidth: .infinity)

            }
            .onDisappear {
                showPassword = false
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

