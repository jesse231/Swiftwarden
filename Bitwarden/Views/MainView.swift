//
//  MainView.swift
//  Bitwarden
//
//  Created by Jesse Seeligsohn on 2023-01-11.
//

import SwiftUI
class Passwords: ObservableObject {
    @Published var currentPassword = Cipher()
    @Published var passwords = [Cipher()]
    @Published var searchResults = [Cipher()]
    @Published var trash = [Cipher()]
    @Published var favourites = [Cipher()]
    @Published var cards = [Cipher()]
}

struct MainView: View {
    @StateObject var allPasswords = Passwords()
    @State private var showEdit: Bool = false
    @State var passwords: [Cipher]?
    @State var deleteDialog: Bool = false
    @State private var showNew = false
    var email : String
    var password : String
    var base: String
    var body: some View {
        NavigationView{
            SideBar().environmentObject(allPasswords)
            PasswordsList(ciphers: allPasswords.searchResults)
            .environmentObject(allPasswords)
            ItemView(cipher: Cipher(), hostname: "null", favourite: false).background(.white)
        }
        .sheet(isPresented: $showEdit, content: {
            let selected = allPasswords.currentPassword
            PopupEdit(name: selected.Name ?? "", username: (selected.Login?.Username) ?? "", password: (selected.Login?.Password) ?? "", show: $showEdit).environmentObject(allPasswords)
        })
        .sheet(isPresented: $showNew) {
            let selected = allPasswords.currentPassword
            PopupNew(show: $showNew).environmentObject(allPasswords)
        }
        .task {
            do {
                try await Api(username: email, password: password, base: base)
                let passes = try await Api.getPasswords()
                
                passwords = Encryption.decryptPasswords(passwords: passes)
                
                allPasswords.trash = passwords!.filter({$0.DeletedDate != nil})

                passwords = passwords?.filter({$0.DeletedDate == nil})
                allPasswords.passwords = passwords ?? [Cipher()]
                allPasswords.favourites = passwords?.filter({$0.Favorite != false}) ?? [Cipher()]
                allPasswords.searchResults = passwords ?? [Cipher()]
                allPasswords.cards = passwords?.filter({$0.Card != nil}) ?? [Cipher()]
                print("-------------------------")
                print(try Encryption.encrypt(str: "192.168.2.31:8081"))
//                print(String(bytes: try Encryption.decrypt(str: Encryption.encrypt(str: "192.168.2.31:8081")), encoding: .utf8))
//                print(String(bytes: try Encryption.decrypt(str: "2.ebbYvLMAn9GnPYVnAqtp9Q==|NPJo259FPfJKPmrPo/Hi/w==|0zVcpzJcP4/3nEwrb1b7DURNE33JSvJGiMX53ZF2jiE="), encoding: .utf8))
//                trash = try await getTrash()
                } catch let error {
                print(error)
            }
        }
                .toolbar(content: {
//            ToolbarItem{
//                HStack{
//                    TextField("Search Vault", text: $searchText)
//                        .textFieldStyle(.roundedBorder)
//                        .frame(width: 260)
//
//                    Button (action: {}){
//                        Image(systemName: "plus")
//                            .foregroundColor(.white)
//                    }.background(.blue)
//                        .buttonStyle(.borderedProminent)
//                        .cornerRadius(7)
//                }
//            }

            ToolbarItem{
                Spacer()
            }
            ToolbarItem (){
                Button (action: {
                    showNew = true
                }){
                    Label("Add", systemImage: "plus.app.fill").labelStyle(.titleAndIcon)
                }

            }
            ToolbarItem (){
                Button (action: {
                    showEdit = true
//                    print(selectedItem)
                }){
                    Label("Edit", systemImage: "pencil").labelStyle(.titleAndIcon)
                }

            }
            ToolbarItem{
                Button (action: {
                    deleteDialog = true
                }){
                    Label("Delete", systemImage: "trash.fill").labelStyle(.titleAndIcon)
                }.confirmationDialog("Are you sure you would like to delete the password?", isPresented: $deleteDialog) {
                    Button("Delete"){
                        let selectedItem = allPasswords.currentPassword
                        if let index = allPasswords.searchResults.firstIndex(of: selectedItem) {
                            allPasswords.searchResults.remove(at: index)
                        }
                        if let index = allPasswords.passwords.firstIndex(of: selectedItem) {
                            allPasswords.passwords.remove(at: index)
                            Task {
                                try await Api.deletePassword(id: selectedItem.Id! )
                            }
                        }
                    }
                    
                }
            }

        })
    }
}
