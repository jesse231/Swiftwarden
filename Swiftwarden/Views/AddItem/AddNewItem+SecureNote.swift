//
//  AddNewItem+SecureNote.swift
//  Swiftwarden
//
//  Created by Jesse Seeligsohn on 2023-06-19.
//

import SwiftUI
extension AddNewItemPopup {
    struct AddSecureNote: View {
        @EnvironmentObject var account: Account
        @Binding var name: String
        @Binding var itemType: ItemType?
        
        @State private var notes: String?
        @State private var fields: [CustomField] = []
                
        @State private var folder: String?
        @State private var favorite = false
        @State private var reprompt: RepromptState = .none
        
        func create() {
            Task {
                let newCipher = Cipher(
                    favorite: favorite,
                    fields: fields,
                    folderID: folder,
                    bid: "",
                    name: name,
                    notes: notes,
                    reprompt: reprompt.toInt(),
                    secureNote: SecureNote(),
                    type: 2
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
                ScrollView {
                    VStack {
                        GroupBox {
                            TextField("Name", text: $name)
                                .textFieldStyle(.plain)
                                .padding(8)
                        }
                        Divider()
                        NotesEditView(text: $notes)
                        Divider()
                        CustomFieldsEdit(fields: $fields, showLinked: false)
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

#Preview {
    AddNewItemPopup(itemType: .constant(.secureNote))
        .environmentObject(Account())
}
