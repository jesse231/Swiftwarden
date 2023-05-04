import SwiftUI

struct MainView: View {
//    @StateObject var allPasswords = Passwords()
    @EnvironmentObject var user : Account
    @State var searchText : String = ""
    @State private var showEdit: Bool = false
    @State var passwords: [Cipher]?
    @State var deleteDialog: Bool = false
    @State private var showNew = false
    
    
    
    var body: some View {
        NavigationView{
            SideBar(searchResults: $searchText).environmentObject(user)
            PasswordsList(searchText: $searchText, display: .normal).frame(minWidth: 400)
                .environmentObject(user)
            ItemView(cipher: nil, hostname: "null", favourite: false).background(.white)
        }
        .sheet(isPresented: $showEdit, content: {
            let selected = user.selectedCipher
            PopupEdit(name: user.selectedCipher.name ?? "", username: (selected.login?.username) ?? "", password: (user.selectedCipher.login?.password) ?? "", show: $showEdit).environmentObject(user)
        })
        .sheet(isPresented: $showNew) {
            PopupNew(show: $showNew).environmentObject(user)
        }
        .searchable(text: $searchText).onChange(of: searchText) {_ in do {
//            print(searchText)
//            if !searchText.isEmpty{
//                allPasswords.searchResults =  allPasswords.passwords?.filter({$0.name?.lowercased().contains(searchText) ?? false})
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
                    Label("Add", systemImage: "plus.square").labelStyle(.titleAndIcon)
                }
                
            }
            ToolbarItem (){
                Button (action: {
                    showEdit = true
                }){
                    Label("Edit", systemImage: "square.and.pencil").labelStyle(.titleAndIcon)
                }
                
            }
        })
    }
}

struct Previews_MainView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
//            SideBar().environmentObject(Passwords())
//            PasswordsList(ciphers: [Cipher()]).frame(minWidth: 400)
//                .environmentObject(Passwords())
            ItemView(cipher: nil, hostname: "null", favourite: false).background(.white)
        }
    }
}
