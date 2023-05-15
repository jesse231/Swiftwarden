import SwiftUI


struct LoginView: View {
    @Binding var loginSuccess : Bool
    @State var email: String = (ProcessInfo.processInfo.environment["Username"] ?? "")
    @State var password: String = (ProcessInfo.processInfo.environment["Password"] ?? "")
    @State var server: String = (ProcessInfo.processInfo.environment["Server"] ?? "")
    
    @State var storedEmail: String? = UserDefaults.standard.string(forKey: "email")
    @State var storedServer: String? = UserDefaults.standard.string(forKey: "server")
    
    @State var attempt = false
    @State var errorMessage = "Your username or password is incorrect or your account does not exist."
    @State var isLoading = false
    @EnvironmentObject var account : Account
    
    func login (storedEmail : String? = nil, storedPassword : String? = nil, storedServer: String? = nil) async throws -> Bool{
        let username = storedEmail ?? email
        let pass = storedPassword ?? password
        let serv = storedServer ?? server
        
        let api = try await Api(username: username, password: pass, base: serv,    identityPath: nil, apiPath: nil, iconPath: nil)
        
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
        if (storedServer == nil) {
            let defaults = UserDefaults.standard
            defaults.set(server, forKey: "server")
        }
        
        
        return true
    }
    
    
    var body: some View {
        if let storedEmail, let storedServer{
            let storedPassword = KeyChain.getUser(account: storedEmail)
            VStack{
                HStack{
                    GroupBox{
                        SecureField("Master Password", text: $password)
                            .textFieldStyle(.plain)
                    }
                    .padding()
                    Button {
                        authenticate() {_ in
                            Task{
                                do{
                                    try await loginSuccess = self.login(storedEmail: storedEmail, storedPassword: storedPassword, storedServer: storedServer)
                                    loginSuccess = true
                                } catch let error as AuthError {
                                    attempt = true
                                    errorMessage = error.message
                                    isLoading = false
                                } catch {
                                    attempt = true
                                    errorMessage = error.localizedDescription
                                    isLoading = false
                                }
                            }
                        }
                    } label: {
                        Image(systemName: "touchid")
                            
                    }
                    
                }
                if (attempt == true){
                    Text(errorMessage)
                        .fixedSize(horizontal: false, vertical: false)
                        .containerShape(Rectangle())
                        .padding(20)
                        .foregroundColor(.primary)
                        .background(.pink.opacity(0.4))
                        .cornerRadius(5)
                }
                HStack{
                    Button(action: {
                        UserDefaults.standard.set(nil, forKey: "email")
                        UserDefaults.standard.set(nil, forKey: "server")
                        KeyChain.deleteUser(account: storedEmail)
                        self.storedEmail = nil
                        self.storedServer = nil
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
                                try await loginSuccess = login(storedEmail: storedEmail, storedServer: storedServer)
//                                print("test")
                            } catch let error as AuthError {
//                                print(error)
                                attempt = true
                                errorMessage = error.message
                                isLoading = false
                            } catch {
                                print(error)
                                attempt = true
                                errorMessage = error.localizedDescription
                                isLoading = false
                            }
                        }
                    }) {
                        Text("Unlock")
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
                Button {
                    Task {
                        attempt = false
                        isLoading = true
                        do {
                            
                            let checkEmail = try Regex("[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}")
                            guard(email != "" && password != "") else {
                                errorMessage = "Please enter a valid email address and password."
                                attempt = true
                                isLoading = false
                                return
                            }
                            
                            guard (email.contains(checkEmail)) else {
                                errorMessage = "Please enter a valid email address."
                                isLoading = false
                                attempt = true
                                return
                            }
                            
                            
                            try await loginSuccess = login()
                        } catch let error as AuthError {
                            print(error)
                            attempt = true
                            errorMessage = error.message
                            isLoading = false
                        } catch {
                            attempt = true
                            print(error)
                            errorMessage = error.localizedDescription
                            isLoading = false
                        }
                        isLoading = false
                    }
                } label: {
                    if isLoading {
                        ProgressView() // Show loading animation
                            .frame(width: 10, height: 10)
                    } else {
                        Text("Log In")
                            .padding(22)
                            .frame(width: 111, height: 22)
                            .background(Color.blue)
                            .foregroundColor(Color.white)
                        
                    }
                }
                .buttonStyle(.plain)
                .padding(22)
                .frame(width: 111, height: 22)
                .background(Color.blue)
                .foregroundColor(Color.white)
                .cornerRadius(5)
            }.padding()
                .frame(maxWidth: 300)
            Spacer()
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(loginSuccess: .constant(false))
            .environmentObject(Account())
    }
    
}
