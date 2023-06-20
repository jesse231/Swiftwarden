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
        @State private var reprompt = false
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
                        Form {
                            Picker("Folder", selection: $folder) {
                                Text("No Folder").tag(nil as String?)
                                ForEach(account.user.getFolders(), id: \.self) {folder in
                                    Text(folder.name).tag(folder.id)
                                }
                                
                            }
                            Toggle("Favorite", isOn: $favorite)
                            Toggle("Master password re-prompt", isOn: $reprompt)
                        }
                        .scaledToFit()
                        .scaledToFill()
                        .scrollDisabled(true)
                        .formStyle(.grouped)
                        .scrollContentBackground(.hidden)
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
                            reprompt: reprompt ? 1 : 0,
                            secureNote: SecureNote(),
                            type: 2
                        )
                        do {
                            self.account.selectedCipher =
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
