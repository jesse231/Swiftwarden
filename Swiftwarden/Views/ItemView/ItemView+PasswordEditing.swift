//
//  ItemView+Editing.swift
//  Swiftwarden
//
//  Created by Jesse Seeligsohn on 2023-05-14.
//

import SwiftUI
import NukeUI

extension ItemView {
    struct PasswordEditing: View {
        @Binding var cipher: Cipher? {
            didSet {
                name = cipher?.name ?? ""
                // Update other properties as needed
            }
        }
        @Binding var editing: Bool
        @StateObject var account: Account
        
        @State var showPassword =  false
        
        
        @State var name: String
        
        @State var username: String
        @State var password: String
        @State var url: String
        
        @State var folder: String?
        @State var favorite: Bool
        @State var reprompt: RepromptState
        
        @State var uris: [Uris]
        @State var customFields: [CustomField]
        
        @State var showReprompt: Bool = false
        
        init(cipher: Binding<Cipher?>, editing: Binding<Bool>, account: Account) {
            _cipher = cipher
            _name = State(initialValue: cipher.wrappedValue?.name ?? "")
            _username = State(initialValue: cipher.wrappedValue?.login?.username ?? "")
            _password = State(initialValue: cipher.wrappedValue?.login?.password ?? "")
            _url = State(initialValue: cipher.wrappedValue?.login?.uri ?? "")
            self.folder = cipher.wrappedValue?.folderID
            self.favorite = cipher.wrappedValue?.favorite ?? false
            reprompt = RepromptState.fromInt(cipher.wrappedValue?.reprompt ?? 0)
            _uris = State(initialValue: cipher.wrappedValue?.login?.uris ?? [Uris(url: "")])
            
            _editing = editing
            _account = StateObject(wrappedValue: account)
            _customFields = State(initialValue: cipher.wrappedValue?.fields ?? [])
        }
        
        func save() {
            let index = account.user.getIndex(of: cipher!)
                cipher?.name = name
                
                cipher?.login?.username = username != "" ? username : nil
                cipher?.login?.password = password != "" ? password : nil
                if let url = uris.first?.uri, url != "" {
                    cipher?.login?.uris = uris
                    cipher?.login?.domain = extractHostURI(uri: url)
                    cipher?.login?.uri = url
                } else {
                    cipher?.login?.uris = nil
                    cipher?.login?.uri = nil
                }
                cipher?.folderID = folder
                cipher?.favorite = favorite
                cipher?.reprompt = reprompt.toInt()
                cipher?.fields = customFields
                account.user.updateCipher(cipher: cipher!, index: index)
        }
        
        
        
        var body: some View {
                VStack {
                    HStack {
                        if let url = uris.first?.uri {
                            Icon(itemType: .password, hostname: extractHostURI(uri: url))
                        } else {
                            Icon(itemType: .password)
                        }
                        VStack {
                            TextField("No Name", text: $name)
                                .font(.system(size: 15))
                                .fontWeight(.semibold)
                                .textFieldStyle(.plain)
                                .frame(maxWidth: .infinity, alignment: .topLeading)
                                .padding(.bottom, -3)
                            Text(verbatim: "Login")
                                .font(.system(size: 10))
                                .frame(maxWidth: .infinity, alignment: .topLeading)
                        }
                        FavoriteEditingButton(favorite: $favorite)
                    }
                    .padding([.leading,.trailing], 5)
                    Divider()
                        .padding([.leading,.trailing], 5)
                    ScrollView {
                        VStack {
                            EditingField(title: "Username", text: $username) {
                            }
//                            .padding()
                            if showPassword {
                                EditingField(title: "Password", text: $password) {
                                    TogglePassword(showPassword: $showPassword, reprompt: $reprompt, showReprompt: $showReprompt)
                                    GeneratePasswordButton(password: $password)
                                }
                                .padding(.top)
                            } else {
                                EditingField(title: "Password", text: $password, secure: true) {
                                    GeneratePasswordButton(password: $password)
                                }
                                .padding(.top)
                            }
                            Divider()
                            AddUrlList(urls: $uris)
                                .padding(.top)
                            Divider()
                            CustomFieldsEdit(fields: $customFields)
                            NotesEditView(Binding<String>(
                                get: {
                                    return cipher?.notes ?? ""
                                },
                                set: { newValue in
                                    cipher?.notes = newValue != "" ? newValue : nil
                                }
                            ))
                            Divider()
                            CipherOptions(folder: $folder, favorite: $favorite, reprompt: $reprompt)
                                .environmentObject(account)
                                .padding(.bottom, 24)
                        }
                        .padding(.trailing)
                        .padding(.leading)
                    }
                    .frame(maxWidth: .infinity)
            }
            .toolbar {
                EditingToolbarOptions(cipher: $cipher, editing: $editing, account: account, save: save)
            }
        }
    }
}

//struct PasswordEditingPreview: PreviewProvider {
//    static var previews: some View {
//        let cipher = Cipher(login: Login(password: "test", username: "test"), name: "Test")
//        let account = Account()
//        HStack{
//            ItemView.PasswordEditing(cipher: .constant(cipher), editing: .constant(true), account: account)
//                .padding()
//                .frame(height: 1000)
//            ItemView.PasswordView(cipher: .constant(cipher), editing: .constant(false), reprompt: .constant(.none), account: account)
//                .environmentObject(account)
//                .padding()
//        }
//    }
//}
