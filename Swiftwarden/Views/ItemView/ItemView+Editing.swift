//
//  ItemView+Editing.swift
//  Swiftwarden
//
//  Created by Jesse Seeligsohn on 2023-05-14.
//

import SwiftUI
import NukeUI

extension ItemView {
    var EditingView: some View {
        return AnyView (
            Group{
                HStack{
                    Spacer()
                    Button {
                        Task {
                            let index = account.user.getCiphers(deleted: true).firstIndex(of: account.selectedCipher)
                            var modCipher = cipher!
                            modCipher.name = name
                            modCipher.login?.username = username
                            modCipher.login?.password = password
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
                            
                            self.editing = false
                        }
                        
                        
                        
                    } label: {
                        Text("Done")
                    }
                }
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
                        Button (action: {
                            favorite = !favorite
                            account.selectedCipher.favorite = favorite
                            Task {
                                try await account.api.updatePassword(cipher: account.selectedCipher)
                            }
                        } ){
                            if (favorite) {
                                Image(systemName: "star.fill")
                                    .foregroundColor(.yellow)
                            } else {
                                Image(systemName: "star")
                                
                            }
                        }.buttonStyle(.plain)
                    }
                    Divider()
                    EditingField(title: "Username", content: $username).padding(.bottom, 8)
                    EditingField(title: "Password", content: $password, secure: true).padding(.bottom, 8)
                    EditingField(title: "Website", content: $url).padding(.bottom, 8)
                    
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
