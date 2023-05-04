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
    
    @State private var selectedFolder : Folder = Folder();
    
    var body: some View {
        VStack(spacing: 0){
            if name.count != 0{
                Text(name).font(.title).bold()
            } else {
                Text("New Password").font(.title).bold()
            }
            Divider()
                .padding()
            TextField("Name", text: $name)
                .padding()
                .textFieldStyle(.plain)
                .background(
                    RoundedRectangle(cornerRadius: 4)
                        .strokeBorder(.gray, lineWidth: 1))
                .padding(4)
                .padding(.bottom)
            TextField("Username", text: $username)
                .padding()
                .textFieldStyle(.plain)
                .background(
                    RoundedRectangle(cornerRadius: 4)
                        .strokeBorder(.gray, lineWidth: 1))
                .padding(4)
            SecureField("Password", text: $password)
                .padding()
                .textFieldStyle(.plain)
                .background(
                    RoundedRectangle(cornerRadius: 4)
                        .strokeBorder(.gray, lineWidth: 1))
                .padding(4)
                .padding(.bottom)
            TextField("URL", text: $url)
                .padding()
                .textFieldStyle(.plain)
                .background(
                    RoundedRectangle(cornerRadius: 4)
                        .strokeBorder(.gray, lineWidth: 1))
                .padding(4)
                .padding(.bottom)
            
            VStack{
                HStack{
                    Picker(selection: $selectedFolder, content: {
                        ForEach(account.user.getFolders(), id:\.self) {folder in
                            Text(folder.name!)
                        }
                        
                    }) {
                        Text("Folder")
//                            .font(.system(size: 10))
                            .foregroundColor(.gray)
                            .padding(.trailing, 300)
                    }
                }
                
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
//                        .font(.system(size: 10))
                        .foregroundColor(.gray)
//                        .padding(.trailing, 30)
                    Spacer()
                    Toggle("Reprompt", isOn: $reprompt).labelsHidden()
                }
            }.padding(.bottom)
            // Create button with function
            HStack{
                Button( action: {show = false}) {
                    Text("Cancel")
                }
                Spacer()
                Button(action: {
                    var newCipher : Cipher
                    do {
                        newCipher = Cipher(
                            favorite: favourite,
//                            fields: [],
                            folderID: selectedFolder.id,
                            login: Login(
                                password: password,
                                uris: [try Uris(url)],
                                username: username),
                            name: name,
                            notes: nil,
                            organizationID: nil,
                            type: 1
                        )
                    } catch {
                        newCipher = Cipher(
                            favorite: favourite,
//                            fields: [],
                            folderID: selectedFolder.id,
                            login: Login(
                                password: password,
                                uris: nil,
                                username: username),
                            name: name,
                            notes: nil,
                            organizationID: nil,
                            type: 1
                        )}
                    Task {
                        try await account.user.addCipher(cipher: newCipher, api: account.api)
                    }
                    show = false
                    
                    
                }) {
                    Text("Save")
//                        .foregroundColor(.white)
//                        .font(.headline)
//                        .padding(.horizontal, 16)
//                        .padding(.vertical, 8)
////                        .background(Color.blue)
//                        .cornerRadius(10)
//                        .background(
//                                    RoundedRectangle(cornerRadius: 10)
//                                        .stroke(Color.white, lineWidth: 2)
//                                        .background(Color.blue)
//                                )
                    
                        
//                        .frame(width: 222, height: 44)
//                        .foregroundColor(Color.white)
                }
//                .buttonStyle(.plain)
//                .padding(22)
//                .frame(width: 222, height: 44)
//                .background(Color.blue)
//                .foregroundColor(Color.white)
//                .cornerRadius(10)
                //            }
            }
        }.padding()
            .frame(width: 500, height: 500)
//            .onAppear() {
//                if (account.user.getFolders() != []) {
//                    selectedFolder = account.user.getFolders()[0]
//                }
//            }
    }
}

struct PopupNew_Previews: PreviewProvider {
    @State static var show = true
//    var account : Account = Account()
//    var data = AccountData(folders: [Folder()])
    static var previews: some View {
        PopupNew(show: $show).environmentObject(Account())
    }
}
