import SwiftUI

struct LoginView: View {
    @Binding var loginSuccess : Bool
    @State var email: String = "jesseseeligsohn@gmail.com"
    @State var password: String = "SfhboF19@"
    @State var server: String = "https://vaultwarden.seeligsohn.com"
    var body: some View {
        VStack{
            Text("Log in").font(.title).bold()
            Divider().padding(.bottom)
            TextField("Email Address", text: $email)
                .padding()
                .background(.secondary)
                .textFieldStyle(.plain)
                .cornerRadius(5)
                .padding(.bottom)
            SecureField("Password", text: $password)
                .padding()
                .background(.secondary)
                .textFieldStyle(.plain)
                .cornerRadius(5)
                .padding(.bottom)
            TextField("Server url", text: $server)
                .padding()
                .background(.secondary)
                .textFieldStyle(.plain)
                .cornerRadius(5)
                .padding(.bottom)
            Button(action: {
                Task {
                    do {
                        try await Api(username: email, password: password, base: server)
                        loginSuccess = true
                        print("-------------")
//                        print(String (bytes: try Encryption.decrypt(str: "2.UG2MLW9sdIelSUkwDpuk/w==|VVrv2CeytR7LGvrE42tqKQ==|BPG1AhBFeYjlYYkPzOrV9ULhxTpzo68McKhkQMnS8xQ="), encoding: .utf8))
                        try Encryption.decrypt(str: "2.UG2MLW9sdIelSUkwDpuk/w==|VVrv2CeytR7LGvrE42tqKQ==|BPG1AhBFeYjlYYkPzOrV9ULhxTpzo68McKhkQMnS8xQ=")
                        
                    } catch {
                        print(error)
                    }
                }
            }) {
                Text("Sign In")
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
        }.padding().frame(maxWidth: 300)
        Spacer()
    }
}

//struct LoginView_Previews: PreviewProvider {
//    static var previews: some View {
//        LoginView()
//    }
//}
