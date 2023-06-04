//
//  AddNewItem+Password.swift
//  Swiftwarden
//
//  Created by Jesse Seeligsohn on 2023-05-21.
//

import SwiftUI

extension AddNewItemPopup {
    
    var AddPasswordView: some View {
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
                .padding(.bottom, 12)
            VStack {
                HStack {
                    Picker(selection: $selectedFolder, content: {
                        ForEach(account.user.getFolders(), id: \.self) {folder in
                            Text(folder.name)
                        }
                        
                    }) {
                        Text("Folder")
                            .foregroundColor(.gray)
                            .padding(.trailing, 300)
                    }
                }
                //
                HStack {
                    Text("favorite")
                        .frame(alignment: .trailing)
                        .foregroundColor(.gray)
                    Spacer()
                    Toggle("favorite", isOn: $favorite).labelsHidden()
                }
                
                HStack {
                    Text("Master Password re-prompt")
                        .frame(alignment: .trailing)
                        .foregroundColor(.gray)
                    Spacer()
                    Toggle("Reprompt", isOn: $reprompt).labelsHidden()
                }
                .padding(.bottom, 20)
                HStack {
                    Picker(selection: $selectedFolder, content: {
                        ForEach(account.user.getFolders(), id: \.self) {folder in
                            Text(folder.name)
                        }
                        
                    }) {
                        Text("Owner")
                            .foregroundColor(.gray)
                            .padding(.trailing, 300)
                    }
                }
            }.padding(.bottom, 24)
        }
    }
    
}

//struct AddNewPassword_Previews: PreviewProvider {
//    static var previews: some View {
//            AddNewItemPopup(show: $show, itemType: ItemType.none).environmentObject(Account())
//    }
//}
