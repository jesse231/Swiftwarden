import SwiftUI

struct PopupNew: View {
    @EnvironmentObject var allPasswords : Passwords
    @Binding var show: Bool
    @State private var name = ""
    @State private var username = ""
    @State private var password = ""
    @State private var url = ""
    @State private var folder = "Folder"
    @State private var favourite = false
    @State private var reprompt = false

    //    @State private var selectedFolder = 0;
    
    var body: some View {
        
            //            Section {
            VStack(spacing: 0){
                if name.count != 0{
                    Text(name).font(.title).bold()
                    Divider()
                        .padding(.bottom)
                }
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
                    Picker(selection: $folder, content: {
                        Text("test")
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
                            .background(Color.white)
                            .foregroundColor(Color.black)
                    }
                    .buttonStyle(.plain)
                    .padding(22)
                    .frame(width: 222, height: 44)
                    .background(Color.blue)
                    .foregroundColor(Color.white)
                    .cornerRadius(10)
                    Button(action: {
//                        let cipher = Datum(
//                            OrganizationId: nil,
//                            FolderId: nil,
//                            Name: name,
//                            Notes: nil,
//                            Type: 1,
//                            Favorite: false,
//                            Login: Login(
//                                Uris: [Uris(Uri: url)],
//                                Username: username,
//                                Password: password)
//                        )
//                        Task {
//                            try await Api.createPassword(cipher: cipher)
//                            allPasswords.passwords.append(cipher)
//                            allPasswords.searchResults?.append(cipher)
//                        }
//                        show = false

                        
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
                .frame(width: 500, height: 500)
    }
}

struct PopupNew_Previews: PreviewProvider {
    @State static var show = true
    static var previews: some View {
        PopupNew(show: $show)
    }
}
