import SwiftUI

struct MainView: View {
//    @StateObject var allPasswords = Passwords()
    @EnvironmentObject var user: Account
    @State var searchText: String = ""
    @State private var showEdit: Bool = false
    @State var passwords: [Cipher]?
    @State var deleteDialog: Bool = false
    @State private var toggleSidebar = false

    var body: some View {
        NavigationView {
            SideBar(searchResults: $searchText).environmentObject(user)
//                .toolbar {
//                    Spacer()
//                }
            PasswordsList(searchText: $searchText, display: .normal)
                .frame(minWidth: 400)
                .environmentObject(user)

            ItemView(cipher: nil)
        }
        .sheet(isPresented: $showEdit, content: {
            let selected = user.selectedCipher
            PopupEdit(name: user.selectedCipher.name ?? "", username: (selected.login?.username) ?? "", password: (user.selectedCipher.login?.password) ?? "", show: $showEdit).environmentObject(user)
        })
        .searchable(text: $searchText).onChange(of: searchText) {_ in do {
        }
        }
    }
}

struct MainViewPreviews: PreviewProvider {
    static var previews: some View {
        MainView().environmentObject(Account())
    }
}
