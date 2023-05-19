import SwiftUI

struct SideBar: View {
    @EnvironmentObject var account: Account
    @Binding var searchResults: String
    @State var selection: Int? = 0

    struct MenuItem: View {
            let label: String
            let icon: String
            let color: Color
            let destination: AnyView

            var body: some View {
                NavigationLink(
                    destination: destination,
//                    tag: 1,
//                    selection: $selection,
                    label: {
                        Label {
                            Text(label)
                        } icon: {
                            Image(systemName: icon).accentColor(color)
                        }
                    }
                )
                .padding(4)
            }
        }
    var body: some View {
        List {
            Section(header: Text("Menu Items")) {
                MenuItem(
                    label: "All Items",
                    icon: "shield.lefthalf.fill",
                    color: .blue,
                    destination: AnyView(PasswordsList(searchText: $searchResults, display: .normal).environmentObject(account))
                )
                MenuItem(
                    label: "Favorites",
                    icon: "star.fill",
                    color: .yellow,
                    destination: AnyView(PasswordsList(searchText: $searchResults, display: .favorite).environmentObject(account))
                )
                MenuItem(
                    label: "Trash",
                    icon: "trash.fill",
                    color: .red,
                    destination: AnyView(PasswordsList(searchText: $searchResults, display: .trash).environmentObject(account))
                )
            }

            Section(header: Text("Types")) {
                MenuItem(
                    label: "Login",
                    icon: "arrow.right.square.fill",
                    color: .gray,
                    destination: AnyView(PasswordsList(searchText: $searchResults, display: .normal).environmentObject(account))
                )
                MenuItem(
                    label: "Card",
                    icon: "creditcard.fill",
                    color: .gray,
                    destination: AnyView(PasswordsList(searchText: $searchResults, display: .card).environmentObject(account))
                )
            }

            Section(header: Text("Folders")) {
                let folders = account.user.getFolders()
                ForEach(folders) { folder in
                    MenuItem(
                        label: folder.name,
                        icon: "folder.fill",
                        color: .gray,
                        destination: AnyView(PasswordsList(searchText: $searchResults, folderID: folder.id, display: .folder))
                    )
                }
            }
        }
        .listStyle(SidebarListStyle())
    }
}

struct SideBar_Previews: PreviewProvider {
    @State static var searchResults: String = ""

    static var previews: some View {
        NavigationView {
            SideBar(searchResults: $searchResults)
                .environmentObject(Account())
                .previewLayout(.sizeThatFits)
            Text("Second View")
            Text("Third View")
        }
    }
}
