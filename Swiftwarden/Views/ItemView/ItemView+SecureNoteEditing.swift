//
//  ItemView+Editing.swift
//  Swiftwarden
//
//  Created by Jesse Seeligsohn on 2023-05-14.
//

import SwiftUI
import NukeUI

extension ItemView {
    struct SecureNoteEditing: View {
        @Binding var cipher: Cipher?
        @Binding var editing: Bool
        var account: Account
        
        @State private var name: String
        
        @State private var folder: String?
        @State private var favorite: Bool
        @State private var reprompt: RepromptState
        
        @State private var notes = ""
        
        @State private var fields: [CustomField] = []
        
        init(cipher: Binding<Cipher?>, editing: Binding<Bool>, account: Account) {
            _cipher = cipher
            _editing = editing
            self.account = account
            
            _name = State(initialValue: account.selectedCipher.name ?? "")
            _folder = State(initialValue: account.selectedCipher.folderID ?? nil as String?)
            _favorite = State(initialValue: account.selectedCipher.favorite ?? false)
            reprompt = RepromptState.fromInt(cipher.wrappedValue?.reprompt ?? 0)
            _notes = State(initialValue: account.selectedCipher.notes ?? "")
            _fields = State(initialValue: account.selectedCipher.fields ?? [])
        }
        
        
        
        func edit () async throws {
            let index = account.user.getCiphers(deleted: true).firstIndex(of: account.selectedCipher)
            
            var modCipher = cipher!
            modCipher.name = name
            
            modCipher.notes = notes
            modCipher.fields = fields
            
            modCipher.favorite = cipher?.favorite
            modCipher.reprompt = reprompt.toInt()
            modCipher.folderID = folder
            
            try await account.user.updateCipher(cipher: modCipher, index: index)
            account.selectedCipher = modCipher
            cipher = modCipher
        }
        
        var body: some View {
            Group {
                VStack {
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
                    .padding(.bottom)
                    HStack {
                        Icon(itemType: .secureNote, account: account)
                        VStack {
                            TextField("No Name", text: $name)
                                .font(.system(size: 15))
                                .fontWeight(.semibold)
                                .textFieldStyle(.plain)
                                .frame(maxWidth: .infinity, alignment: .topLeading)
                                .padding(.bottom, -5)
                            Text(verbatim: "Secure Note")
                                .font(.system(size: 10))
                                .frame(maxWidth: .infinity, alignment: .topLeading)
                        }
                        FavoriteButton(cipher: $cipher, account: account)
                    }
                    Divider()
                    ScrollView {
                        VStack {
                            Group {
                                NotesEditView(Binding<String>(
                                    get: {
                                        return cipher?.notes ?? ""
                                    },
                                    set: { newValue in
                                        cipher?.notes = newValue
                                    }
                                ))
                                CustomFieldsEdit(fields: Binding<[CustomField]>(
                                    get: {
                                        return cipher?.fields ?? []
                                    },
                                    set: { newValue in
                                        cipher?.fields = newValue
                                    }
                                ))
                            }
                            Divider()
                            Form {
                                Picker(selection: $folder, label: Text("Folder")) {
                                    ForEach(account.user.getFolders(), id: \.self) {folder in
                                        Text(folder.name).tag(folder.id as String?)
                                    }
                                }
                                Toggle("Favorite", isOn: Binding<Bool>(
                                    get: {
                                        return self.cipher?.favorite ?? false
                                    },
                                    set: { newValue in
                                        self.cipher?.favorite = newValue
                                    }
                                )
                                )
                                Toggle("Master Password Re-prompt", isOn: Binding<Bool>(
                                    get: {
                                        return self.reprompt.reprompt()
                                    },
                                    set: { newValue in
                                        self.reprompt = newValue ? .require : .none
                                    }
                                ))
                                
                            }
                        }
                        .padding(.trailing)
                        .padding(.leading)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
    }
}

//struct SecureNoteEditing_Preview: PreviewProvider {
//    static var previews: some View {
//
//    }
//}
