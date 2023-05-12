import SwiftUI

struct MainView: View {
//    @StateObject var allPasswords = Passwords()
    @EnvironmentObject var user : Account
    @State var searchText : String = ""
    @State private var showEdit: Bool = false
    @State var passwords: [Cipher]?
    @State var deleteDialog: Bool = false
    @State private var toggleSidebar = false
    
    
    
    var body: some View {
        NavigationView{
            SideBar(searchResults: $searchText).environmentObject(user)
                .toolbar {
                    ToolbarItem{
                        Button(action: {toggleSidebar = !toggleSidebar}) {
                            Image(systemName: "sidebar.left")
                                .help("Toggle Sidebar")
                        }
                    }
                }
            PasswordsList(searchText: $searchText, display: .normal)
                .frame(minWidth: 400)
                .environmentObject(user)
            
            ItemView(cipher: nil, hostname: "null", favourite: false)
        }
        .sheet(isPresented: $showEdit, content: {
            let selected = user.selectedCipher
            PopupEdit(name: user.selectedCipher.name ?? "", username: (selected.login?.username) ?? "", password: (user.selectedCipher.login?.password) ?? "", show: $showEdit).environmentObject(user)
        })
        .searchable(text: $searchText).onChange(of: searchText) {_ in do {
//            print(searchText)
//            if !searchText.isEmpty{
//                allPasswords.searchResults =  allPasswords.passwords?.filter({$0.name?.lowercased().contains(searchText) ?? false})
        }
        }
    }
}

struct Previews_MainView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
//            SideBar().environmentObject(Passwords())
//            PasswordsList(ciphers: [Cipher()]).frame(minWidth: 400)
//                .environmentObject(Passwords())
//            ItemView(cipher: nil, hostname: "null", favourite: false)
        }
    }
}
