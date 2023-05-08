import SwiftUI


struct LoginView: View {
    @Binding var loginSuccess : Bool
    @State var email: String = (ProcessInfo.processInfo.environment["Username"] ?? "")
    @State var password: String = (ProcessInfo.processInfo.environment["Password"] ?? "")
    @State var server: String = (ProcessInfo.processInfo.environment["Server"] ?? "")
    @State var storedEmail: String? = UserDefaults.standard.string(forKey: "email")
    @EnvironmentObject var account : Account
    
    
    func login (storedEmail : String? = nil, storedPassword : String? = nil) async throws -> Bool{
        let username = storedEmail ?? email
        let pass = storedPassword ?? password
        
        let api = try await Api(username: username, password: pass, base: server,    identityPath: nil, apiPath: nil, iconPath: nil)

        account.api = api
        
        let sync = try await api.sync()
        let privateKey = sync.profile?.privateKey
        var privateKeyDec = try Encryption.decrypt(str: privateKey!).toBase64()
        
        // Turn the private key into PEM formatted key
        privateKeyDec = "-----BEGIN PRIVATE KEY-----\n" + privateKeyDec + "\n-----END PRIVATE KEY-----"
        
        let pk = try SwKeyConvert.PrivateKey.pemToPKCS1DER(privateKeyDec)
        Encryption.privateKey = SecKeyCreateWithData(pk as CFData, [kSecAttrKeyType: kSecAttrKeyTypeRSA, kSecAttrKeyClass: kSecAttrKeyClassPrivate] as CFDictionary, nil)
        
        account.user = User(sync : sync)
        
        if (storedPassword == nil){
            KeyChain.saveUser(account: email, password: password)
            print(KeyChain.getUser(account: email))
        }
        
        if (storedEmail == nil) {
            let defaults = UserDefaults.standard
            defaults.set(email, forKey: "email")
        }
        
        
        return true
    }
    
    
    var body: some View {
        if let storedEmail{
            let storedPassword = KeyChain.getUser(account: storedEmail)
            VStack{
                SecureField("Password", text: $password)
                    .padding()
                    .textFieldStyle(.plain)
                    .background(
                        RoundedRectangle(cornerRadius: 4)
                            .strokeBorder(.gray, lineWidth: 1))
                    .padding(4)
                Button {
                        authenticate() {_ in
                            Task{
                                try await loginSuccess = self.login(storedEmail: storedEmail, storedPassword: storedPassword)
                                loginSuccess = true
                            }
                        }
                    } label: {
                        Image(systemName: "touchid")
                    }
                HStack{
                    Button(action: {
                        UserDefaults.standard.set(nil, forKey: "email")
                        KeyChain.deleteUser(account: storedEmail)
                        self.storedEmail = nil
                    }) {
                        Text("Log out")
                            .padding(22)
                            .frame(width: 111, height: 22)
                            .background(Color.gray)
                            .foregroundColor(Color.white)
                        
                    }
                    .buttonStyle(.plain)
                    .padding(22)
                    .frame(width: 122, height: 25)
                    .background(Color.gray)
                    .foregroundColor(Color.white)
                    .cornerRadius(5)
                    Button(action: {
                        Task {
                            do {
                                try await loginSuccess = login(storedEmail: storedEmail)
                            } catch {
                                print(error)
                            }
                        }
                    }) {
                        Text("Sign in")
                            .padding(22)
                            .frame(width: 111, height: 22)
                            .background(Color.blue)
                            .foregroundColor(Color.white)
                        
                    }
                    .buttonStyle(.plain)
                    .padding(22)
                    .frame(width: 122, height: 25)
                    .background(Color.blue)
                    .foregroundColor(Color.white)
                    .cornerRadius(5)
                }.padding().frame(maxWidth: 300)
        }.padding().frame(maxWidth: 300)
        } else {
            VStack{
                Text("Log in").font(.title).bold()
                Divider().padding(.bottom, 5)
                TextField("Email Address", text: $email)
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
                TextField("Server url", text: $server)
                    .padding()
                    .textFieldStyle(.plain)
                    .background(
                        RoundedRectangle(cornerRadius: 4)
                            .strokeBorder(.gray, lineWidth: 1))
                    .padding(4)
                Button(action: {
                    Task {
                        do {
                            try await loginSuccess = login()
                        } catch {
                            print(error)
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
}

struct LoginView_Previews: PreviewProvider {
    @State static var show = true
    static var previews: some View {
        LoginView(loginSuccess: $show)
    }
}
