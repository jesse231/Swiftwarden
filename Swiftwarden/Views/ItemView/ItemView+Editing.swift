//
//  ItemView+Editing.swift
//  Swiftwarden
//
//  Created by Jesse Seeligsohn on 2023-05-14.
//

import SwiftUI
import NukeUI

extension ItemView {
    func edit () async throws {
        let index = account.user.getCiphers(deleted: true).firstIndex(of: account.selectedCipher)
        var modCipher = cipher!
        modCipher.name = name
        
        modCipher.login?.username = username != "" ? username : nil
        modCipher.login?.password = password != "" ? password : nil
        if url != "" {
            modCipher.login?.uris = [Uris(uri: url)]
            modCipher.login?.uri = url
        } else {
            modCipher.login?.uris = nil
            modCipher.login?.uri = nil
        }
        if let folderID = folder.id {
            modCipher.folderID = folderID
        } else {
            modCipher.folderID = nil
        }
        modCipher.favorite = favorite
        modCipher.reprompt = reprompt ? 1 : 0
        try await account.user.updateCipher(cipher: modCipher, api: account.api, index: index)
        account.selectedCipher = modCipher
        cipher = modCipher
    }
    
    
    var EditingView: some View {
        return AnyView (
            Group{
                HStack{
                    Button{
                        self.editing = false
                    } label : {
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
                ScrollView{
                    VStack{
                        HStack{
                            Icon(hostname: hostname, account: account)
                            VStack{
                                TextField("Name", text: $name)
                                    .font(.system(size: 15))
                                    .fontWeight(.bold)
                                    .textFieldStyle(.plain)
                                    .textFieldStyle(.plain)
                                Text(verbatim: "Login")
                                    .font(.system(size: 10))
                                    .frame(maxWidth: .infinity, alignment: .topLeading)
                            }
                            FavoriteButton(favorite: $favorite, cipher: $cipher, account: account)
                        }
                        Divider()
                        EditingField(title: "Username", text: $username, buttons: {}).padding(.bottom, 8)
                        EditingField(title: "Password", text: $password, secure: true){
                            Button {
                            } label: {
                                Image(systemName: "arrow.triangle.2.circlepath")
                            }
                    }.padding(.bottom, 8)
                        GroupBox {
                            AddUrlList(urls: $uris)
                        }
                        //                    EditingField(title: "Website", content: $url).padding(.bottom, 8)
                        
                        Picker(selection: $folder, label: Text("Folder")) {
                            ForEach(account.user.getFolders(), id:\.self) {folder in
                                Text(folder.name)
                            }
                        }
                        //                }
                        HStack{
                            Text("Master Password re-prompt")
                                .frame(alignment: .trailing)
                                .foregroundColor(.gray)
                            Spacer()
                            Toggle("Reprompt", isOn: $reprompt).labelsHidden()
                        }
                    }
                }
            }
                .onAppear(
                    perform: {
                        name = account.selectedCipher.name ?? ""
                        username = account.selectedCipher.login?.username ?? ""
                        password = account.selectedCipher.login?.password ?? ""
                        url = account.selectedCipher.login?.uris?.first?.uri ?? ""
                        favorite = account.selectedCipher.favorite ?? false
                        if let folderID = account.selectedCipher.folderID {
                            self.folder = account.user.getFolders().filter({$0.id == folderID}).first!
                        } else {
                            folder = account.user.getFolders().first!
                        }
                        reprompt = account.selectedCipher.reprompt == 1 ? true : false
                        
                    })
            
        )
    }
}
