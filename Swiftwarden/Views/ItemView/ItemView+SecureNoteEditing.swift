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
        
        @State private var notes: String?
        
        @State private var fields: [CustomField] = []
        
        init(cipher: Binding<Cipher?>, editing: Binding<Bool>, account: Account) {
            _cipher = cipher
            _editing = editing
            self.account = account
            
            _name = State(initialValue: cipher.wrappedValue?.name ?? "")
            _folder = State(initialValue: cipher.wrappedValue?.folderID ?? nil as String?)
            _favorite = State(initialValue: cipher.wrappedValue?.favorite ?? false)
            reprompt = RepromptState.fromInt(cipher.wrappedValue?.reprompt ?? 0)
            _notes = State(initialValue: cipher.wrappedValue?.notes)
            _fields = State(initialValue: cipher.wrappedValue?.fields ?? [])
        }
        
        
        
        func save() {
                cipher?.name = name
                
                cipher?.notes = notes
                cipher?.fields = fields
                
                cipher?.favorite = favorite
                cipher?.reprompt = reprompt.toInt()
                cipher?.folderID = folder
                
                account.user.updateCipher(cipher: cipher!)
                            
        }
        
        var body: some View {
            Group {
                VStack {
                    EditHeader(name: $name, favorite: $favorite, cipher: cipher, itemType: .secureNote)
                    ScrollView {
                        VStack {
                            Group {
                                NotesEditView(text: $notes)
                                CustomFieldsEdit(fields: $fields)
                            }
                            Divider()
                            CipherOptions(folder: $folder, favorite: $favorite, reprompt: $reprompt)
                                .environmentObject(account)
                                .padding(.bottom, 24)
                        }
                        .padding(25)
                    }
                    .toolbar {
                        EditingToolbarOptions(cipher: $cipher, editing: $editing, account: account, save: save)
                    }
                }
            }
        }
    }
}
struct ItemView_SecureNoteEditing_Previews: PreviewProvider {
    static var previews: some View {
        ItemView.SecureNoteEditing(cipher: .constant(nil), editing: .constant(true), account: .init())
    }
}
