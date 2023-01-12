import SwiftUI

struct PopupNew: View {
    @EnvironmentObject var allPasswords : Passwords
    @Binding var show: Bool
    @State private var name = ""
    @State private var username = ""
    @State private var password = ""
    @State private var url = ""
    //    @State private var selectedFolder = 0;
    
    var body: some View {
        Form {
            Section {
                TextField("Name", text: $name)
                TextField("Username", text: $username)
                SecureField("Password", text: $password)
                TextField("URL", text: $url)
            }
            
            // Create button with function
            Button(action: {
                let cipher = Cipher(
                    OrganizationId: nil,
                    FolderId: nil,
                    Name: name,
                    Notes: nil,
                    Type: 1,
                    Favorite: false,
                    Login: Login(
                        Uris: [Uris(Uri: url)],
                        Username: username,
                        Password: password)
                )
                Task {
                    try await Api.createPassword(cipher: cipher)
                    allPasswords.passwords.append(cipher)
                    allPasswords.searchResults?.append(cipher)
                }
                show = false
                
            }) {
                Text("Save")
            }
        }.padding()
            .frame(width: 500, height: 500)
    }
}
