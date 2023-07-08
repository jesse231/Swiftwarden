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
        
        @State private var notes = ""
        @State private var fields: [CustomField] = []
                
        @State private var folder: String?
        @State private var favorite = false
        @State private var reprompt: RepromptState = .none
        var body: some View {
                ScrollView {
                    VStack {
                        GroupBox {
                            TextField("Name", text: $name)
                                .textFieldStyle(.plain)
                                .padding(8)
                        }
                        Divider()
                        NotesEditView($notes)
                        Divider()
                        CustomFieldsEdit(fields: $fields, showLinked: false)
                        CipherOptions(folder: $folder, favorite: $favorite, reprompt: $reprompt)
                            .environmentObject(account)
                    }
                    .padding()
                }
            Divider()
            HStack {
                Button {
                    itemType = nil
                } label: {
                    Text("Cancel")
                }
                Spacer()
                Button {
                    Task {
                        
                        let newCipher = Cipher(
                            favorite: favorite,
                            fields: fields,
                            folderID: folder,
                            name: name,
                            notes: notes != "" ? notes : nil,
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
                    itemType = nil
                } label: {
                    Text("Save")
                }
            }
        }
    }
}

struct AddSecureNote_Previews: PreviewProvider {
    static var previews: some View {
        AddNewItemPopup.AddSecureNote(name: .constant("Name"), itemType: .constant(.secureNote)).environmentObject(Account())
    }
}
