import SwiftUI

struct PopupNew: View {
    @EnvironmentObject var appState : AppState
//    @EnvironmentObject var account: Account
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
                Picker(selection: $selectedFolder, content: {
                        ForEach(appState.account.getFolders(), id:\.self) {folder in
                            Text(folder.name!)
                    }
                    
                }) {
                    Text("Folder")
                        .font(.system(size: 10))
                        .foregroundColor(.gray)
                }
                
                HStack{
                    Text("Favourite")
                        .frame(alignment: .trailing)
                        .font(.system(size: 10))
                        .foregroundColor(.gray)
                    Toggle("Favourite", isOn: $favourite).labelsHidden()
                }
                
                HStack{
                    Text("Master Password re-prompt")
                        .frame(alignment: .trailing)
                        .font(.system(size: 10))
                        .foregroundColor(.gray)
                    Toggle("Reprompt", isOn: $reprompt).labelsHidden()
                }
            }.padding(.bottom)
            // Create button with function
            HStack{
                Button( action: {show = false}) {
                    Text("Cancel")
                        .padding(22)
                        .frame(width: 222, height: 44)
                        .background(Color.gray)
                        .foregroundColor(Color.black)
                }
                .buttonStyle(.plain)
                .padding(22)
                .frame(width: 222, height: 44)
                .background(Color.gray)
                .foregroundColor(Color.black)
                .cornerRadius(10)
                Button(action: {
                    var newCipher : Cipher
                    do {
                        newCipher = Cipher(
                            favorite: favourite,
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
                        try await appState.account.addCipher(cipher: newCipher)
                    }
                    show = false
                    
                    
                }) {
                    Text("Save")
                        .padding(22)
                        .frame(width: 222, height: 44)
                        .background(Color.blue)
                        .foregroundColor(Color.white)
                }
                .buttonStyle(.plain)
                .padding(22)
                .frame(width: 222, height: 44)
                .background(Color.blue)
                .foregroundColor(Color.white)
                .cornerRadius(10)
                //            }
            }
        }.padding()
            .frame(width: 500, height: 500).onAppear() {
                selectedFolder = appState.account.getFolders()[0]
            }
    }
}

struct PopupNew_Previews: PreviewProvider {
    @State static var show = true
    //    @EnvironmentObject var allPasswords = Passwords()
    static var previews: some View {
        PopupNew(show: $show).environmentObject(Passwords())
    }
}
