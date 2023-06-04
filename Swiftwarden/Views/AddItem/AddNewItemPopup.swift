import SwiftUI

struct AddNewItemPopup: View {
    @EnvironmentObject var account: Account
    @Binding var show: Bool
    @State var name = ""
    @State var username = ""
    @State var password = ""
    @State var url = ""
    @State var folder = "Server"
    @State var favorite = false
    @State var reprompt = false
    @State var uris: [Uris] = [Uris(url: "")]

    @State var selectedFolder: Folder = Folder(name: "")
    
    @State var itemType: ItemType

    var body: some View {
        VStack {
            if name.count != 0 {
                Text(name).font(.title).bold()
            } else {
                Text("New Password").font(.title).bold()
            }
            Divider()
            ScrollView {
                AddPasswordView
                .padding(.trailing)
            }
            .frame(maxWidth: .infinity)
        HStack {
            Button {
                show = false
            } label: {
                Text("Cancel")
            }
            Spacer()
            Button {
                Task {
                    let url = uris.first?.uri
                    let newCipher = Cipher(
                        favorite: favorite,
                        fields: nil,
                        folderID: selectedFolder.id != "No Folder" ? selectedFolder.id : nil,
                        
                        login: Login(
                            password: password != "" ? password : nil,
                            uri: url,
                            uris: uris,
                            username: username != "" ? username : nil),
                        name: name,
                        reprompt: reprompt ? 1 : 0,
                        type: 1
                    )
                    do {
                        self.account.selectedCipher =
                        try await account.user.addCipher(cipher: newCipher)
                    } catch {
                        print(error)
                    }
                    
                }
                show = false
                
            } label: {
                Text("Save")
            }
        }
        }.padding()
            .frame(width: 500, height: 500)
            .onAppear {
                selectedFolder = account.user.getFolders().first!
            }
    }
}

struct AddNewItemPopup_Previews: PreviewProvider {
    @State static var show = true
    var account: Account = Account()
    static var previews: some View {
        AddNewItemPopup(show: $show, itemType: .password).environmentObject(Account())
    }
}
