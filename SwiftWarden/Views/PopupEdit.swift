import SwiftUI

struct PopupEdit: View {
    @EnvironmentObject var allPasswords : Passwords
    @State var name : String
    @State var username : String
    @State var password : String
    @Binding var show: Bool
    var body: some View {
        VStack {
            List{
                HStack{
                    Text("Name:")
                    TextField("", text: $name).textFieldStyle(.roundedBorder)
                }
                HStack{
                    Text("Username:")
                    TextField("", text: $username).textFieldStyle(.roundedBorder)
                }
                HStack{
                    Text("Password:")
                    TextField("", text: $password).textFieldStyle(.roundedBorder)
                }
                Spacer()
                HStack{
                    Button("Cancel") {
                        show = false
                    }
                    Button("Submit") {
                        Task {
                            allPasswords.currentPassword.Name = name
                            allPasswords.currentPassword.Login?.Username = username
                            allPasswords.currentPassword.Login?.Password = password
                            try await Api.updatePassword(cipher: allPasswords.currentPassword)
                            
                            let i = allPasswords.passwords.firstIndex(of: allPasswords.currentPassword)
                            allPasswords.passwords[i!] = allPasswords.currentPassword
                        }
                        show = false
                    }
                }
            }.padding()
        }        .padding()
            .frame(width: 500, height: 500)
    }
}
