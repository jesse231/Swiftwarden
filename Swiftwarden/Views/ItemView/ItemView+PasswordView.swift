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
    struct PasswordView: View {
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
            VStack {
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
                .padding(.bottom)
                
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
                                email: account.user.getEmail(),
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
                                                Open(link: url)
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
            
        }
    }
    
    
}
struct ItemViewRegularPreview: PreviewProvider {
    static var previews: some View {
        let cipher = Cipher(fields: [CustomField(type: 1, name: "test", value: "test")], login: Login(password: "test", username: "test"), name: "Test")
        
        let cipherDeleted = Cipher(deletedDate: "today", fields: [CustomField(type: 1, name: "test", value: "test")], login: Login(password: "test", username: "test"), name: "Test")
        
        let account = Account()
        
        Group {
            ItemView.PasswordView(cipher: .constant(cipher), editing: .constant(false), reprompt: .constant(.none), account: account)
                .environmentObject(account)
                .padding()
            ItemView.PasswordView(cipher: .constant(cipherDeleted), editing: .constant(false), reprompt: .constant(.none), account: account)
                .environmentObject(account)
                .padding()
        }
    }
}

