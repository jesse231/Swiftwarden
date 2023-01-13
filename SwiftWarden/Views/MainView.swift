import SwiftUI
class Passwords: ObservableObject {
    @Published var currentPassword = Cipher()
    @Published var passwords = [Cipher()]
    @Published var searchResults : [Cipher]?
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
    
    var body: some View {
        NavigationView{
            SideBar().environmentObject(allPasswords)
            PasswordsList(ciphers: allPasswords.searchResults).frame(minWidth: 400)
                .environmentObject(allPasswords)
            ItemView(cipher: nil, hostname: "null", favourite: false).background(.white)
        }
        .sheet(isPresented: $showEdit, content: {
            let selected = allPasswords.currentPassword
            PopupEdit(name: selected.Name ?? "", username: (selected.Login?.Username) ?? "", password: (selected.Login?.Password) ?? "", show: $showEdit).environmentObject(allPasswords)
        })
        .sheet(isPresented: $showNew) {
            PopupNew(show: $showNew).environmentObject(allPasswords)
        }
        .task {
            do {
                let passes = try await Api.getPasswords()
                passwords = Encryption.decryptPasswords(passwords: passes)
                allPasswords.trash = passwords!.filter({$0.DeletedDate != nil})
                passwords = passwords?.filter({$0.DeletedDate == nil})
                allPasswords.passwords = passwords ?? [Cipher()]
                allPasswords.favourites = passwords?.filter({$0.Favorite != false}) ?? [Cipher()]
                allPasswords.searchResults = passwords ?? [Cipher()]
                allPasswords.cards = passwords?.filter({$0.Card != nil}) ?? [Cipher()]
                
            } catch let error {
                print(error)
            }
        }
        .toolbar(content: {
            
            ToolbarItem{
                Spacer()
            }
            ToolbarItem (){
                Button (action: {
                    showNew = true
                }){
                    Label("Add", systemImage: "plus").labelStyle(.titleAndIcon)
                }
                
            }
            ToolbarItem (){
                Button (action: {
                    showEdit = true
                }){
                    Label("Edit", systemImage: "pencil").labelStyle(.titleAndIcon)
                }
                
            }
            ToolbarItem{
                Button (action: {
                    deleteDialog = true
                }){
                    Label("Delete", systemImage: "trash").labelStyle(.titleAndIcon)
                }.confirmationDialog("Are you sure you would like to delete the password?", isPresented: $deleteDialog) {
                    Button("Delete"){
                        let selectedItem = allPasswords.currentPassword
                        if let searchResults = allPasswords.searchResults{
                            if let index = searchResults.firstIndex(of: selectedItem) {
                                allPasswords.searchResults?.remove(at: index)
                            }
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
