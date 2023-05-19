import SwiftUI

struct PopupEdit: View {
    @State var name: String
    @State var username: String
    @State var password: String
    @Binding var show: Bool
    var body: some View {
        VStack {
            List {
                HStack {
                    Text("Name:")
                    TextField("", text: $name).textFieldStyle(.roundedBorder)
                }
                HStack {
                    Text("Username:")
                    TextField("", text: $username).textFieldStyle(.roundedBorder)
                }
                HStack {
                    Text("Password:")
                    TextField("", text: $password)
                        .textFieldStyle(.roundedBorder)
                        .background()
                }
                Spacer()
                HStack {
                    Button("Cancel") {
                        show = false
                    }
                    Button("Submit") {
//                        Task {
//                            allPasswords.currentPassword?.name = name
//                            allPasswords.currentPassword?.login?.username = username
//                            allPasswords.currentPassword?.login?.password = password
//                            
//                            try await Api.updatePassword(cipher: allPasswords.currentPassword!)
//                            
//                            let index = allPasswords.passwords.firstIndex(of: allPasswords.currentPassword!)
//                            if let i = index{
//                                allPasswords.passwords[i] = allPasswords.currentPassword
//                            }
//                        }
//                        show = false
                    }
                }
            }.padding()
        }        .padding()
            .frame(width: 500, height: 500)
    }
}
