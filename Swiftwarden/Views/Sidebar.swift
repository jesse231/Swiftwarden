import SwiftUI

struct SideBar: View {
    @EnvironmentObject var account: Account
    @Binding var searchResults: String
    
    @State var selection: Int? = 0
    @State var newFolder = false
    @State var folderName = ""
    @State var folders: [Folder] = []
    @State var text: String = ""
    @State private var deleteFolderWarning = false
    @State private var folderID: String?
    @FocusState private var isNewFolder: Bool
    
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
                ForEach(folders) { folder in
                    MenuItem(
                        label: folder.name,
                        icon: "folder.fill",
                        color: .gray,
                        destination: AnyView(PasswordsList(searchText: $searchResults, folderID: folder.id, display: .folder))
                    )
                    .contextMenu {
                        if folder.id != nil{
                            Button {
                                deleteFolderWarning = true
                                folderID = folder.id
                            } label: {
                                Text("Delete")
                            }
                        }
                    }
                    .alert(isPresented: $deleteFolderWarning) {
                        Alert(title: Text("Delete Folder"), message: Text("Are you sure you want to delete the selected folder?"),
                              primaryButton: .default(Text("Delete"), action: {
                            deleteFolderWarning = false
                            Task {
                                do {
                                    try await account.user.deleteFolder(id: folderID ?? "")
                                    folders = account.user.getFolders()
                                } catch {
                                    print(error)
                                }
                            }
                        }),
                          secondaryButton: .cancel(Text("Cancel")))
                    }
                }
                if newFolder {
                    TextField("", text: $folderName)
                        .textFieldStyle(.roundedBorder)
                    .onExitCommand(perform: {
//                        //folderName = ""
                        newFolder = false
                    })
                    .focused($isNewFolder)
                    .onSubmit {
                        print(folderName)
                                Task {
                                    do {
                                        await try account.user.addFolder(name: folderName)
                                        folderName = ""
                                        folders = account.user.getFolders()
                                    } catch {
                                        print(error)
                                    }
                                    newFolder = false
                            }
                    }
                    .onChange(of: isNewFolder, perform: { new in
                        print(new)
                        if new == false {
                            newFolder = false
                        }
                        
                    })
                }
            }
        }
        .onAppear {
            folders = account.user.getFolders()
        }
        .listStyle(SidebarListStyle())
        .toolbar {
            ToolbarItem  {
                Button {
                    folderName = ""
                    newFolder = true
                    Task {
                        // Fix swiftui set focus bug
                        try? await Task.sleep(nanoseconds: 500)
                        isNewFolder = true
                        
                    }
                } label: {
                    Image(systemName: "folder.fill")
                }
            }
        }
        .frame(minWidth: 150)
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
