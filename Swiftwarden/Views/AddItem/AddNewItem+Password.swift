//
//  AddNewItem+Password.swift
//  Swiftwarden
//
//  Created by Jesse Seeligsohn on 2023-05-21.
//

import SwiftUI

extension AddNewItemPopup {
    struct AddPassword: View {
        var account: Account
        @Binding var name: String
        @Binding var itemType: ItemType?
        
        @State var username = ""
        @State var password = ""
        
        @State var uris: [Uris] = [Uris(url: "")]
        @State var fields: [CustomField] = []
        @State var notes: String = ""
        
        @State var favorite = false
        @State var reprompt: RepromptState = .none
        @State var folder: String?
        
        init(account: Account, name: Binding<String>, itemType: Binding<ItemType?>) {
            self.account = account
            self._name = name
            self._itemType = itemType
        }
        
        func create() {
            Task {
                let url = uris.first?.uri
                let newCipher = Cipher(
                    favorite: favorite,
                    fields: fields,
                    folderID: folder,
                    login: Login(
                        password: password != "" ? password : nil,
                        uri: url,
                        uris: uris,
                        username: username != "" ? username : nil),
                    name: name,
                    notes: notes != "" ? notes : nil,
                    reprompt: reprompt.toInt(),
                    type: 1
                )
                do {
                    try await account.user.addCipher(cipher: newCipher)
                }
                catch {
                    print(error)
                }
            }
        }
        
        
        var body: some View {
            VStack {
                ScrollView {
                    VStack {
                        Group {
                            GroupBox {
                                TextField("Name", text: $name)
                                    .textFieldStyle(.plain)
                                    .padding(8)
                            }
                            .padding(.bottom, 4)
                            GroupBox {
                                TextField("Username", text: $username)
                                    .textFieldStyle(.plain)
                                    .padding(8)
                            }.padding(.bottom, 4)
                            GroupBox {
                                SecureField("Password", text: $password)
                                    .textFieldStyle(.plain)
                                    .padding(8)
                            }.padding(.bottom, 12)
                            Divider()
                            AddUrlList(urls: $uris)
                            Divider()
                            CustomFieldsEdit(fields: $fields)
                            Divider()
                            NotesEditView($notes)
                            Divider()
                        }
                        CipherOptions(folder: $folder, favorite: $favorite, reprompt: $reprompt)
                            .environmentObject(account)
                    }
                    .padding(20)
                }
                Footer(itemType: $itemType, create: create)
                .padding(20)
                .background(.gray.opacity(0.1))
            }
        }
    }
}

#Preview {
    AddNewItemPopup.AddPassword(account: Account(), name: .constant(""), itemType: .constant(.password))

}
