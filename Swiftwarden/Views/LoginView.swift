import SwiftUI

struct LoginView: View {
    @Binding var loginSuccess : Bool
    @State var email: String = (ProcessInfo.processInfo.environment["Username"] ?? "")
    @State var password: String = (ProcessInfo.processInfo.environment["Password"] ?? "")
    @State var server: String = (ProcessInfo.processInfo.environment["Server"] ?? "")
    @State var attempt = false
    @State var errorMessage = "Your username or password is incorrect or your account does not exist."
    @EnvironmentObject var account : Account
    
    

    var body: some View {
        VStack{
            Text("Log in").font(.title).bold()
            Divider().padding(.bottom, 5)
            GroupBox{
                TextField("Email Address", text: $email)
                    .textFieldStyle(.plain)
                    .padding(4)
            }.padding(4)
            GroupBox{
                SecureField("Password", text: $password)
                    .textFieldStyle(.plain)
                    .padding(4)
            }.padding(4)
            GroupBox{
                TextField("Server url", text: $server)
                    .textFieldStyle(.plain)
                    .padding(4)
            }.padding(4)
            if (attempt == true){
                Text(errorMessage)
                    .fixedSize(horizontal: false, vertical: false)
                    .containerShape(Rectangle())
                    .padding(20)
                    .foregroundColor(.primary)
                    .background(.pink.opacity(0.4))
                    .cornerRadius(5)
            }
            

            Button(action: {
                attempt = false
                Task {
                    do {
                        let checkEmail = try Regex("[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}")
                        guard(email != "" && password != "") else {
                            errorMessage = "Please enter a valid email address and password."
                            attempt = true
                            return
                        }
                        
                        guard (email.contains(checkEmail)) else {
                            errorMessage = "Please enter a valid email address."
                            attempt = true
                            return
                        }
                        

                        let api = try await Api(username: email, password: password, base: server, identityPath: nil, apiPath: nil, iconPath: nil)
                        
                        account.api = api
                        
                        
                        let sync = try await api.sync()

                        let privateKey = sync.profile?.privateKey
                        var privateKeyDec = try Encryption.decrypt(str: privateKey!).toBase64()
                        // Turn the private key into PEM formatted key
                        privateKeyDec = "-----BEGIN PRIVATE KEY-----\n" + privateKeyDec + "\n-----END PRIVATE KEY-----"

                        let pk = try SwKeyConvert.PrivateKey.pemToPKCS1DER(privateKeyDec)
                        Encryption.privateKey = try SecKeyCreateWithData(pk as CFData, [kSecAttrKeyType: kSecAttrKeyTypeRSA, kSecAttrKeyClass: kSecAttrKeyClassPrivate] as CFDictionary, nil)
                        
                        
                        account.user = User(sync: sync)
                        
                        loginSuccess = true
                        attempt = true
                        
                    } catch let error as AuthError {
                        print(error)
                        attempt = true
                        errorMessage = error.message

                    } catch {
                        print("Unexpected error: \(error)")
                    }
                }
            }) {
                Text("Sign In")
                    .padding(22)
                    .frame(width: 111, height: 44)
                    .background(Color.blue)
                    .foregroundColor(Color.white)
            }
            .buttonStyle(.plain)
            .padding(22)
            .frame(width: 222, height: 44)
            .background(Color.blue)
            .foregroundColor(Color.white)
            .cornerRadius(10)
        }.padding().frame(maxWidth: 300)
        Spacer()
    }
}

struct LoginView_Previews: PreviewProvider {
    @State static var show = true
    static var previews: some View {
        LoginView(loginSuccess: $show)
    }
}
