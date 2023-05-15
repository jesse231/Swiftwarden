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
    
    @State private var selectedFolder : Folder = Folder(name: "")
    
    var body: some View {
        VStack(spacing: 0){
            if name.count != 0{
                Text(name).font(.title).bold()
            } else {
                Text("New Password").font(.title).bold()
            }
            Divider()
                .padding()
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
            GroupBox{
                TextField("URL", text: $url)
                    .textFieldStyle(.plain)
                    .padding(8)
            }
            .padding(.bottom, 12)
            VStack{
                HStack{
                    Picker(selection: $selectedFolder, content: {
                        ForEach(account.user.getFolders(), id:\.self) {folder in
                            Text(folder.name)
                        }

                    }) {
                        Text("Folder")
//                            .font(.system(size: 10))
                            .foregroundColor(.gray)
                            .padding(.trailing, 300)
                    }
                }
//
                HStack{
                    Text("Favourite")
                        .frame(alignment: .trailing)
//                        .font(.system(size: 10))
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
                        let newCipher = Cipher(
                                favorite: favourite,
                                fields: nil,
                                folderID: selectedFolder.id != "No Folder" ? selectedFolder.id : nil,
                                login: Login(
                                    password: password != "" ? password : nil,
                                    uris: url != "" ? [Uris(url: url)] : nil,
                                    username: username != "" ? username : nil),
                                name: name,
                                organizationID: nil,
                                reprompt: reprompt ? 1 : 0,
                                type: 1
                            )
                        do{
                            //account.selectedCipher =
                            try await account.user.addCipher(cipher: newCipher, api: account.api)
                        }
                        //account.api.createPassword(cipher: newCipher) }
                        catch { print(error)
                        }
                        
                    }
                    //Launch itemview
                    
                    show = false
        
                } label: {
                    Text("Save")
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
