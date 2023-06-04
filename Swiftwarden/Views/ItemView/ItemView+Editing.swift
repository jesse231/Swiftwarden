//
//  ItemView+Editing.swift
//  Swiftwarden
//
//  Created by Jesse Seeligsohn on 2023-05-14.
//

import SwiftUI
import NukeUI

extension ItemView {
    struct EditingView: View {
        @Binding var cipher: Cipher?
        @Binding var editing: Bool
        @StateObject var account: Account
        
        @State var showPassword =  false
        
        
        @State var name: String

        @State var username: String
        @State var password: String
        @State var url: String

        @State var folder: Folder// = Folder(id: "", name: "")
        @State var reprompt: RepromptState// = false

        @State var uris: [Uris] // = [Uris(url: "")]
        
        @State var showReprompt: Bool = false
        
        init(cipher: Binding<Cipher?>, editing: Binding<Bool>, account: Account) {
            _cipher = cipher
            
            _name = State(initialValue: account.selectedCipher.name ?? "")
            _username = State(initialValue: account.selectedCipher.login?.username ?? "")
            _password = State(initialValue: account.selectedCipher.login?.password ?? "")
            _url = State(initialValue: account.selectedCipher.login?.uri ?? "")
            if let folderID = account.selectedCipher.folderID {
                self.folder = account.user.getFolders().filter({$0.id == folderID}).first!
            } else {
                folder = account.user.getFolders().first!
            }
            reprompt = RepromptState.fromInt(cipher.wrappedValue?.reprompt ?? 0)
            _uris = State(initialValue: account.selectedCipher.login?.uris ?? [Uris(url: "")])
            
            _editing = editing
            _account = StateObject(wrappedValue: account)
        }

        
        func edit () async throws {
            let index = account.user.getCiphers(deleted: true).firstIndex(of: account.selectedCipher)
            var modCipher = cipher!
            modCipher.name = name
            
            modCipher.login?.username = username != "" ? username : nil
            modCipher.login?.password = password != "" ? password : nil
            if let url = uris.first?.uri {
                modCipher.login?.uris = uris
                modCipher.login?.uri = url
            } else {
                modCipher.login?.uris = nil
                modCipher.login?.uri = nil
            }
            if let folderID = folder.id {
                modCipher.folderID = folderID
            } else {
                modCipher.folderID = nil
            }
            modCipher.favorite = cipher?.favorite
            modCipher.reprompt = reprompt.toInt()
            try await account.user.updateCipher(cipher: modCipher, index: index)
            account.selectedCipher = modCipher
            cipher = modCipher
        }
        
        var body: some View {
                Group {
                    HStack {
                        Button {
                            self.editing = false
                        } label: {
                            Text("Cancel")
                        }
                        Spacer()
                        Button {
                            Task {
                                try await edit()
                                self.editing = false
                            }
                        } label: {
                            Text("Done")
                        }
                    }
                    ScrollView {
                        VStack {
                            HStack {
                                Icon(hostname: extractHost(cipher: cipher), account: account)
                                VStack {
                                    TextField("No Name", text: $name)
                                        .font(.system(size: 15))
                                        .fontWeight(.semibold)
                                        .textFieldStyle(.plain)
                                        .frame(maxWidth: .infinity, alignment: .topLeading)
                                        .padding(.bottom, -5)
                                    Text(verbatim: "Login")
                                        .font(.system(size: 10))
                                        .frame(maxWidth: .infinity, alignment: .topLeading)
                                }
                                FavoriteButton(cipher: $cipher, account: account)
                            }
                            Divider()
                            EditingField(title: "Username", text: $username) {
                            }
                            .padding()
                            if showPassword {
                                EditingField(title: "Password", text: $password) {
                                    TogglePassword(showPassword: $showPassword, reprompt: $reprompt, showReprompt: $showReprompt)
                                    GeneratePasswordButton(password: $password)
                                }
                                .padding()
                            } else {
                                EditingField(title: "Password", text: $password, secure: true) {
                                    TogglePassword(showPassword: $showPassword, reprompt: $reprompt, showReprompt: $showReprompt)
                                    GeneratePasswordButton(password: $password)
                                }.padding()
//                                    .animation(.default)
                            }
                            AddUrlList(urls: $uris)
                            .padding()

                            Picker(selection: $folder, label: Text("Folder")) {
                                ForEach(account.user.getFolders(), id: \.self) {folder in
                                    Text(folder.name)
                                }
                            }.padding()
                            HStack {
                                Text("Master Password Re-prompt")
                                    .frame(alignment: .trailing)
                                Spacer()
                                Toggle("", isOn: Binding<Bool>(
                                                get: {
                                                    return self.reprompt.reprompt()
                                                },
                                                set: { newValue in
                                                    self.reprompt = newValue ? .require : .none
                                                }
                                            ))
                            }.padding()
                        }
                        .padding(.trailing)
                        .padding(.leading)
                    }
                    .frame(maxWidth: .infinity)
                }
//                    .onAppear(
//                        perform: {
//                            name = account.selectedCipher.name ?? ""
//                            username = account.selectedCipher.login?.username ?? ""
//                            password = account.selectedCipher.login?.password ?? ""
//                            url = account.selectedCipher.login?.uris?.first?.uri ?? ""
//                            favorite = account.selectedCipher.favorite ?? false
//                            if let folderID = account.selectedCipher.folderID {
//                                self.folder = account.user.getFolders().filter({$0.id == folderID}).first!
//                            } else {
//                                folder = account.user.getFolders().first!
//                            }
//                            reprompt = account.selectedCipher.reprompt == 1 ? true : false
//
//                        })
        }
    }
}

struct ItemViewEditingPreview: PreviewProvider {
    static var previews: some View {
        let cipher = Cipher(login: Login(password: "test", username: "test"), name: "Test")
        let account = Account()

        Group {
//            ItemView(cipher: cipher, favorite: true, editing: true, reprompt: <#RepromptState#>)
//                .environmentObject(account)
//            ItemView(cipher: cipher, favorite: true, editing: false)
//                .environmentObject(account)
        }
    }
}
