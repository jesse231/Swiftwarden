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
        @State var notes: String? = ""
        
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
                    notes: notes,
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
                            EditingField(title: "Name", text: $name, showTitle: false){}
                            .padding(8)
                            .padding(.bottom, 4)
                            EditingField(title: "Username", text: $username, showTitle: false){}
                            .padding(8)
                            .padding(.bottom, 4)
                            
                            EditingField(title: "Password", text: $password, secure: true, showTitle: false){}
                            .padding(8)
                            .padding(.bottom, 12)
                            }
                        Group {
                            Divider()
                            AddUrlList(urls: $uris)
                            Divider()
                            CustomFieldsEdit(fields: $fields)
                            Divider()
                            NotesEditView(text: $notes)
                            Divider()
                            CipherOptions(folder: $folder, favorite: $favorite, reprompt: $reprompt)
                        }
                        .padding(.leading, 4)
                        .padding(.trailing, 8)
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
        .environmentObject(Account())

}
