//
//  CipherOptions.swift
//  Swiftwarden
//
//  Created by Jesse Seeligsohn on 2023-06-30.
//

import SwiftUI

struct CipherOptions: View {
    @EnvironmentObject var account: Account
    @Binding var folder: String?
    @Binding var favorite: Bool
    @Binding var reprompt: RepromptState
    var body: some View {
        Form {
            Picker(selection: $folder, label: Text("Folder")) {
                ForEach(account.user.getFolders(), id: \.self) {folder in
                    Text(folder.name).tag(folder.id)
                }
            }
            Toggle("Favorite", isOn: Binding<Bool>(
                get: {
                    return favorite ?? false
                },
                set: { newValue in
                    favorite = newValue
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
        .formStyle(.grouped)
        .padding([.leading, .trailing], -25)
        .scrollContentBackground(.hidden)
    }
}

struct CipherOptions_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            EditingField(title: "Test", text: .constant("Test")) {
            }
            CipherOptions(folder: .constant(""), favorite: .constant(false), reprompt: .constant(.none)).environmentObject(Account())
        }
        .padding()
    }
}
