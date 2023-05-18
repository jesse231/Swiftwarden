import SwiftUI

struct PopupNew: View {
    @EnvironmentObject var account : Account
    @Binding var show: Bool
    @State private var name = ""
    @State private var username = ""
    @State private var password = ""
    @State private var url = ""
    @State private var folder = "Server"
    @State private var favourite = false
    @State private var reprompt = false
    @State private var uris: [Uris] = [Uris(url: "")]
    
    @State private var selectedFolder : Folder = Folder(name: "")
    
    var body: some View {
        VStack{
            if name.count != 0{
                Text(name).font(.title).bold()
            } else {
                Text("New Password").font(.title).bold()
            }
            Divider()
            ScrollView{
                GroupBox{
                    TextField("Name", text: $name)
                        .textFieldStyle(.plain)
                        .padding(8)
                }
                .padding(.bottom, 4)
                GroupBox{
                    TextField("Username", text: $username)
                        .textFieldStyle(.plain)
                        .padding(8)
                }.padding(.bottom, 4)
                GroupBox{
                    SecureField("Password", text: $password)
                        .textFieldStyle(.plain)
                        .padding(8)
                }.padding(.bottom, 12)
                Divider()
                AddUrlList(urls: $uris)
                Divider()
                .padding(.bottom, 12)
                VStack{
                    HStack{
                        Picker(selection: $selectedFolder, content: {
                            ForEach(account.user.getFolders(), id:\.self) {folder in
                                Text(folder.name)
                            }
                            
                        }) {
                            Text("Folder")
                                .foregroundColor(.gray)
                                .padding(.trailing, 300)
                        }
                    }
                    //
                    HStack{
                        Text("Favourite")
                            .frame(alignment: .trailing)
                            .foregroundColor(.gray)
                        Spacer()
                        Toggle("Favourite", isOn: $favourite).labelsHidden()
                    }
                    
                    HStack{
                        Text("Master Password re-prompt")
                            .frame(alignment: .trailing)
                            .foregroundColor(.gray)
                        Spacer()
                        Toggle("Reprompt", isOn: $reprompt).labelsHidden()
                    }
                    .padding(.bottom, 20)
                    HStack{
                        Picker(selection: $selectedFolder, content: {
                            ForEach(account.user.getFolders(), id:\.self) {folder in
                                Text(folder.name)
                            }
                            
                        }) {
                            Text("Owner")
                                .foregroundColor(.gray)
                                .padding(.trailing, 300)
                        }
                    }
                }.padding(.bottom, 24)
                HStack{
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
                                favorite: favourite,
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
                                try await account.user.addCipher(cipher: newCipher, api: account.api)
                            }
                            catch {
                                print(error)
                            }
                            
                        }
                        show = false
                        
                    } label: {
                        Text("Save")
                    }
                }
            }
        }.padding()
            .frame(width: 500, height: 500)
            .onAppear() {
                selectedFolder = account.user.getFolders().first!
            }
    }
}

struct PopupNew_Previews: PreviewProvider {
    @State static var show = true
    var account : Account = Account()
    static var previews: some View {
        PopupNew(show: $show).environmentObject(Account())
    }
}
