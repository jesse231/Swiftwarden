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
        @Binding var show: Bool
        
        @State var username = ""
        @State var password = ""
        
        @State var favorite = false
        @State var reprompt = false
        
        @State var uris: [Uris] = [Uris(url: "")]
        @State var fields: [CustomField] = []
        @State var selectedFolder: Folder
        init(account: Account, name: Binding<String>, show: Binding<Bool>) {
            self.account = account
            self._name = name
            _selectedFolder = State(initialValue: account.user.getFolders()[0])
            _show = show
        }
        
        
        var body: some View {
            VStack {
                ScrollView {
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
                        CustomFieldsEdit(fields: $fields)
                        Divider()
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
                    }
                    .padding()
                }
                HStack{
                    Button {
                        show = false
                    } label: {
                        Text("Cancel")
                    }
                    Spacer()
                    Button {
                        Task {
                            let url = uris.first?.uri
                            let newCipher = Cipher(
                                favorite: favorite,
                                fields: fields,
                                folderID: selectedFolder.id != "No Folder" ? selectedFolder.id : nil,
                                login: Login(
                                    password: password != "" ? password : nil,
                                    uri: url,
                                    uris: uris,
                                    username: username != "" ? username : nil),
                                name: name,
                                reprompt: reprompt ? 1 : 0,
                                type: 1
                            )
                            do {
                                self.account.selectedCipher =
                                try await account.user.addCipher(cipher: newCipher)
                            }
                            catch {
                                print(error)
                            }
                            
                        }
                        show = false
                    } label: {
                        Text("Save")
                    }
                }
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
