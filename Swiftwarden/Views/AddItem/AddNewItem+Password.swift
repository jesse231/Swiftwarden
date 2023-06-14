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
        @State var username = ""
        @State var password = ""
        
        @State var favorite = false
        @State var reprompt = false
        
        @State var uris: [Uris] = [Uris(url: "")]
        @State var fields: [CustomField] = []
        @State var selectedFolder: Folder
        init(account: Account, name: Binding<String>) {
            self.account = account
            self._name = name
            _selectedFolder = State(initialValue: account.user.getFolders()[0])
        }
        
        var body: some View {
                VStack{
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
                    CustomFields(fields: $fields)
                    Divider()
//                    VStack {
                        Form {
                            Picker("Folder", selection: $selectedFolder) {
                                ForEach(account.user.getFolders(), id: \.self) {folder in
                                    Text(folder.name)
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
//                    }
//                    .background(.red)
//                    Spacer()
//                        .padding(.bottom)
                }
        }
    }
}

struct AddNewPassword_Previews: PreviewProvider {
    static var previews: some View {
        @State var show = true
        AddNewItemPopup(show: $show, itemType: ItemType.password).environmentObject(Account())
    }
}
