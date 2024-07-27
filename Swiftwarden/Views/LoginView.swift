import SwiftUI
import LocalAuthentication

enum FocusField: Hashable {
    case unlock
    case password
  }


struct LoginView: View {
    @Binding var loginSuccess: Bool
    @State var email: String = (ProcessInfo.processInfo.environment["Username"] ?? "")
    @State var password: String = (ProcessInfo.processInfo.environment["Password"] ?? "")
    @State var server: String = (ProcessInfo.processInfo.environment["Server"] ?? "")

    @State var attempt = false
    @State var errorMessage = "Your username or password is incorrect or your account does not exist."
    @State var isLoading = false
    @State var isUnlocking = false
    
    @FocusState var focusedField: FocusField?
    
    @EnvironmentObject var appState: AppState
    let context = LAContext()

    @EnvironmentObject var account: Account
    
    func unlock() {
        Task {
            do {
                withAnimation {
                    focusedField = nil
                    isLoading = true
                }
                try await loginSuccess = login(storedEmail: appState.email, storedServer: appState.server)
                context.invalidate()
            } catch let error as AuthError {
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
    }
    
    func validateAndLogin(storedEmail: String? = nil, storedPassword: String? = nil, storedServer: String? = nil) {
        Task {
            attempt = false
            
            withAnimation {
                focusedField = nil
                isLoading = true
            }
            
            do {
                let checkEmail = try Regex("[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}")
                guard email != "" && password != "" else {
                    errorMessage = "Please enter a valid email address and password."
                    attempt = true
                    isLoading = false
                    return
                }
                
                guard email.contains(checkEmail) else {
                    errorMessage = "Please enter a valid email address."
                    isLoading = false
                    attempt = true
                    return
                }
                
                try await loginSuccess = login()
                print(loginSuccess)
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
    }
    
    
    func login (storedEmail: String? = nil, storedPassword: String? = nil, storedServer: String? = nil) async throws -> Bool {

        let username = storedEmail ?? email
        let pass = storedPassword ?? password
        var serv = storedServer ?? server

        let base = URL(string: serv)
        if let base, base.host == nil {
            serv = "https://" + serv
        }

        let api = try await Api(username: username, password: pass, base: URL(string: serv), identityPath: nil, apiPath: nil, iconPath: nil)

        let sync = try await api.sync()
        let privateKey = sync.profile?.privateKey
        var privateKeyDec = try Encryption.decrypt(str: privateKey!).toBase64()

        // Turn the private key into PEM formatted key
        let pk = try SwKeyConvert.PrivateKey.pemToPKCS1DER(privateKeyDec)
        Encryption.privateKey = SecKeyCreateWithData(pk as CFData, [kSecAttrKeyType: kSecAttrKeyTypeRSA, kSecAttrKeyClass: kSecAttrKeyClassPrivate] as CFDictionary, nil)

        account.user = User(sync: sync, api: api, email: username)

        if storedPassword == nil {
            KeyChain.saveUser(account: email, password: password)
        }

        if storedEmail == nil {
            appState.email = email
        }
        if storedServer == nil {
            appState.server = server
        }

        return true
    }

    var body: some View {
        if let storedEmail = appState.email, let storedServer = appState.server {
            VStack {
                HStack {
                    if !isUnlocking {
                    GroupBox {
                            SecureField("Master Password", text: $password)
                                .disabled(isLoading)
                                .focused($focusedField, equals: .password)
                                .textFieldStyle(.plain)
                                .textContentType(nil)
                                .onAppear {
                                    focusedField = .password
                                }
                                .onSubmit {
                                    unlock()
                                }
                    }
                    .transition(.scale)
                    .accessibilityIdentifier("Master Password")
                    .padding()
                    }
                    if !isLoading {
                        Button {
                            authenticate(context: context) { _ in
                                Task {
                                    let storedPassword = KeyChain.getUser(account: storedEmail)
                                    do {
                                        withAnimation {
                                            focusedField = .password
                                            isUnlocking = true
                                            isLoading = true
                                        }
                                        try await loginSuccess = self.login(storedEmail: storedEmail, storedPassword: storedPassword, storedServer: storedServer)
                                    } catch let error as AuthError {
                                        attempt = true
                                        errorMessage = error.message
                                        isLoading = false
                                        isUnlocking = false
                                    } catch {
                                        attempt = true
                                        errorMessage = error.localizedDescription
                                        isLoading = false
                                        isUnlocking = false
                                    }
                                }
                            }
                        } label: {
                            Image(systemName: "touchid")
                        }
                        .transition(.opacity.animation(.easeInOut))
                        .controlSize(.large)
                    }
                }
                if attempt == true {
                    Text(errorMessage)
                        .fixedSize(horizontal: false, vertical: false)
                        .containerShape(Rectangle())
                        .padding(20)
                        .foregroundColor(.primary)
                        .background(.pink.opacity(0.4))
                        .cornerRadius(5)
                }
                VStack {
                    if !isLoading {
                        Button {
                            unlock()
                        } label: {
                            Text("Unlock")
                                .focused($focusedField, equals: .unlock)
                                .foregroundColor(.white)
                                .font(.headline)
                                .frame(width: 200, height: 30)
                                .background(.blue)
                                .cornerRadius(5)
                                .padding()
                            
                        }
                        .buttonStyle(.plain)
                        
                        Button(action: {
                            UserDefaults.standard.set(nil, forKey: "email")
                            UserDefaults.standard.set(nil, forKey: "server")
                            KeyChain.deleteUser(account: storedEmail)
                            self.appState.email = nil
                            self.appState.server = nil
                            self.attempt = false
                            self.password = ""
                        }) {
                            Text("Log out")
                                .foregroundColor(.white)
                                .font(.headline)
                                .frame(width: 200, height: 30)
                                .background(.red)
                                .cornerRadius(5)
                                .padding()
                        }
                        .buttonStyle(.plain)
                    } else {
                        ProgressView()
                    }
                }.padding().frame(maxWidth: 300)
            }.padding().frame(maxWidth: 300)
        } else {
            VStack {
                Text("Log in")
                    .font(.title)
                    .bold()
                Divider().padding(.bottom, 5)
                GroupBox {
                    TextField("Email Address", text: $email)
                        .textFieldStyle(.plain)
                        // prevent macos password popup
                        .textContentType(.username)
                        .onSubmit {
                            validateAndLogin()
                        }
                        .textFieldStyle(.plain)
                        .padding(4)
                }.padding(4)
                GroupBox {
                    SecureField("Password", text: $password)
                        .textFieldStyle(.plain)
                        // prevent macos password popup
                        .textContentType(.none)
                        .autocorrectionDisabled()
                        .onSubmit {
                            validateAndLogin()
                        }
                        .padding(4)
                }.padding(4)
                Section(header: Text("Server URL")) {
                    GroupBox {
                        TextField("https://bitwarden.com/", text: $server)
                            .textFieldStyle(.plain)
                            .padding(4)
                            .onSubmit {
                                validateAndLogin()
                            }
                    }.padding(4)
                }
                if attempt == true {
                    Text(errorMessage)
                        .fixedSize(horizontal: false, vertical: false)
                        .containerShape(Rectangle())
                        .padding(20)
                        .foregroundColor(.primary)
                        .background(.pink.opacity(0.4))
                        .cornerRadius(5)
                }
                
                if !isLoading {
                    Button {
                        validateAndLogin()
                    } label: {
                        Text("Log In")
                            .foregroundColor(.white)
                            .font(.headline)
                            .frame(width: 200, height: 30)
                            .background(.blue)
                            .cornerRadius(5)
                            .padding()
                    }
                    .buttonStyle(.plain)
                } else {
                    ProgressView()
                }
            }.padding()
                .frame(maxWidth: 300)
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(loginSuccess: .constant(false))
            .environmentObject(Account())
    }

}
