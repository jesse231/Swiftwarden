import SwiftUI
class Passwords: ObservableObject {
    @Published var currentPassword: Cipher?
    @Published var passwords: [Cipher]?
    @Published var searchResults : [Cipher]?
    @Published var trash : [Cipher]?
    @Published var favourites : [Cipher]?
    @Published var cards : [Cipher]?
    @Published var folders : [Folder]?
    @Published var organizations: [String:Organization]?
    @Published var keys : [String:[UInt8]] = [:]
}

class AppState : ObservableObject {
    @Published var account = Account(sync: Response())
    @Published var selectedCipher = Cipher()
}

struct MainView: View {
//    @StateObject var allPasswords = Passwords()
    @StateObject var appState = AppState()
    @State var searchText : String = ""
    @State private var showEdit: Bool = false
    @State var passwords: [Cipher]?
    @State var deleteDialog: Bool = false
    @State private var showNew = false
    
    
    
    var body: some View {
        NavigationView{
            SideBar(searchResults: $searchText).environmentObject(appState)
            PasswordsList(searchText: $searchText, display: .normal).frame(minWidth: 400)
                .environmentObject(appState)
            ItemView(cipher: nil, hostname: "null", favourite: false).background(.white)
        }
        .sheet(isPresented: $showEdit, content: {
            let selected = appState.selectedCipher
            PopupEdit(name: appState.selectedCipher.name ?? "", username: (selected.login?.username) ?? "", password: (appState.selectedCipher.login?.password) ?? "", show: $showEdit).environmentObject(appState)
        })
        .sheet(isPresented: $showNew) {
            PopupNew(show: $showNew).environmentObject(appState)
        }
        .searchable(text: $searchText).onChange(of: searchText) {_ in do {
//            print(searchText)
//            if !searchText.isEmpty{
//                allPasswords.searchResults =  allPasswords.passwords?.filter({$0.name?.lowercased().contains(searchText) ?? false})
        }
        }
        
        
        .task {
            do {
                let sync = try await Api.sync()
                let privateKey = sync.profile?.privateKey
                var privateKeyDec = try Encryption.decrypt(str: privateKey!).toBase64()
                
                // Turn the private key into PEM formatted key
                privateKeyDec = "-----BEGIN PRIVATE KEY-----\n" + privateKeyDec + "\n-----END PRIVATE KEY-----"

                let pk = try SwKeyConvert.PrivateKey.pemToPKCS1DER(privateKeyDec)
                Encryption.privateKey = try SecKeyCreateWithData(pk as CFData, [kSecAttrKeyType: kSecAttrKeyTypeRSA, kSecAttrKeyClass: kSecAttrKeyClassPrivate] as CFDictionary, nil)
                
                appState.account = Account(sync: sync)
//                print(appState.account.getCiphers())
                
                
                let passes = sync.ciphers
                passwords = appState.account.getCiphers()
//                let passes = try await Api.getPasswords()
//                passwords = decryptPasswords(dataList: passes!)
//                allPasswords.trash = passwords!.filter({$0.deletedDate != nil})
//                passwords = passwords?.filter({$0.deletedDate == nil})
//                allPasswords.passwords = passwords ?? [Cipher()]
//                allPasswords.favourites = passwords?.filter({$0.favorite != false}) ?? [Cipher()]
//                allPasswords.searchResults = passwords ?? [Cipher()]
//                allPasswords.cards = passwords?.filter({$0.card != nil}) ?? [Cipher()]
//                let folders = sync.folders
//
//                allPasswords.folders = Encryption.decryptFolders(dataList: folders!)
//                allPasswords.folders!.append(Folder(name: "No Folder", object: "Folder"))
                
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
