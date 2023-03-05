import SwiftUI

struct SideBar: View {
    @EnvironmentObject var appState : AppState
    @Binding var searchResults : String
    @EnvironmentObject var allPasswords : Passwords
    @State var selection: Int? = 0
    
    var body: some View {
//        let _ = print(searchResults)
        let menuItems: [(label: String, icon: String, color: Color, destination: AnyView)] = [
            (label: "All Items", icon: "shield.lefthalf.fill", color: Color.blue, destination: AnyView(PasswordsList(searchText: $searchResults, display: .normal).environmentObject(appState))),
            (label: "Favorites", icon: "star.fill", color: Color.yellow, destination: AnyView(PasswordsList(searchText: $searchResults, display: .favorite).environmentObject(appState))),
            (label: "Trash", icon: "trash.fill", color: Color.red, destination: AnyView(PasswordsList(searchText: $searchResults, display: .trash).environmentObject(appState))),
        ]
        
        let types: [(label: String, icon: String, color: Color, destination: AnyView)] = [
            (label: "Login", icon: "arrow.right.square.fill", color: Color.gray, destination: AnyView(PasswordsList(searchText: $searchResults, display: .normal).environmentObject(appState))),
            (label: "Card", icon: "creditcard.fill", color: Color.gray, destination: AnyView(PasswordsList(searchText: $searchResults, display: .card).environmentObject(appState))),
            //            (label: "Identity", icon: "person.crop.square.fill", color: Color.gray, destination: AnyView(TrashView())),
            //            (label: "Secure Note", icon: "lock.fill", color: Color.gray, destination: AnyView(PasswordsList(ciphers: allPasswords.passwords).environmentObject(allPasswords))),
        ]
        
        List {
            
            ForEach(0..<menuItems.count) { i in
                NavigationLink(
                    destination: menuItems[i].destination,
                    // Fix for allowing default to be selected
                                        tag: i,
                                        selection: $selection,
                    label: {
                        Label {
                            Text(menuItems[i].label)
                        } icon: {
                            Image(systemName: menuItems[i].icon).accentColor(menuItems[i].color)
                        }
                    }
                ).padding(4)
            }
            
            Section(header: Text("Types")) {
                ForEach(0..<types.count) { i in
                    
                    NavigationLink(
                        destination: types[i].destination,
                        label: {
                            Label {
                                Text(types[i].label)
                            } icon: {
                                Image(systemName: types[i].icon).accentColor(types[i].color)
                            }
                        }).padding(4)
                }
            }
            Section(header: Text("Folders")) {
                if let folders = appState.account.getFolders() {
                    ForEach(folders) {folder in
                        HStack {
                            Image(systemName: "folder")
                            Text(folder.name!)
                        }
                    }
                }
            }
        }.listStyle(SidebarListStyle())
    }
}

struct SidebarView_Previews: PreviewProvider {
    static var previews: some View {
        Text("")
//        SideBar().environmentObject(<#T##object: ObservableObject##ObservableObject#>)
    }
}
