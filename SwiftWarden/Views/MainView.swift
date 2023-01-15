import SwiftUI
class Passwords: ObservableObject {
    @Published var currentPassword: Datum?
    @Published var passwords: [Datum]?
    @Published var searchResults : [Datum]?
    @Published var trash : [Datum]?
    @Published var favourites : [Datum]?
    @Published var cards : [Datum]?
}

struct MainView: View {
    @StateObject var allPasswords = Passwords()
    @State private var showEdit: Bool = false
    @State var passwords: [Datum]?
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
            PopupEdit(name: selected?.name ?? "", username: (selected?.login?.username) ?? "", password: (selected?.login?.password) ?? "", show: $showEdit).environmentObject(allPasswords)
        })
        .sheet(isPresented: $showNew) {
            PopupNew(show: $showNew).environmentObject(allPasswords)
        }//Argument type '[DataValues]' does not conform to expected type 'Decoder'
        .task {
            do {
                let passes = try await Api.getPasswords()
                passwords = Encryption.decryptPasswords(passwords: passes)
                allPasswords.trash = passwords!.filter({$0.deletedDate != nil})
                passwords = passwords?.filter({$0.deletedDate == nil})
                allPasswords.passwords = passwords ?? [Datum()]
                allPasswords.favourites = passwords?.filter({$0.favorite != false}) ?? [Datum()]
                allPasswords.searchResults = passwords ?? [Datum()]
                allPasswords.cards = passwords?.filter({$0 != nil}) ?? [Datum()]
                
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
//                        let selectedItem = allPasswords.currentPassword
//                        if let searchResults = allPasswords.searchResults{
//                            if let index = searchResults.firstIndex(of: selectedItem) {
//                                allPasswords.searchResults?.remove(at: index)
//                            }
//                        }
//                        if let index = allPasswords.passwords.firstIndex(of: selectedItem) {
//                            allPasswords.passwords.remove(at: index)
//                            Task {
//                                try await Api.deletePassword(id: selectedItem.Id! )
//                            }
//                        }
                    }
                    
                }
            }
            
        })
    }
}
