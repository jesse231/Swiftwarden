import SwiftUI

struct LoginView: View {
    @Binding var loginSuccess : Bool
    @State var email: String = (ProcessInfo.processInfo.environment["Username"] ?? "")
    @State var password: String = (ProcessInfo.processInfo.environment["Password"] ?? "")
    @State var server: String = (ProcessInfo.processInfo.environment["Server"] ?? "")
    @Binding var account : Account
    var body: some View {
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

                        try await Api(username: email, password: password, base: server)
                        
                        let sync = try await Api.sync()
                        let privateKey = sync.profile?.privateKey
                        var privateKeyDec = try Encryption.decrypt(str: privateKey!).toBase64()
                        
                        // Turn the private key into PEM formatted key
                        privateKeyDec = "-----BEGIN PRIVATE KEY-----\n" + privateKeyDec + "\n-----END PRIVATE KEY-----"

                        let pk = try SwKeyConvert.PrivateKey.pemToPKCS1DER(privateKeyDec)
                        Encryption.privateKey = try SecKeyCreateWithData(pk as CFData, [kSecAttrKeyType: kSecAttrKeyTypeRSA, kSecAttrKeyClass: kSecAttrKeyClassPrivate] as CFDictionary, nil)
                        
                        
                        account = Account(sync: sync)
                        
                        loginSuccess = true
                        
                        
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

struct LoginView_Previews: PreviewProvider {
    @State static var show = true
    static var previews: some View {
        Text("test")
        //LoginView(loginSuccess: $show, account: Account())
    }
}
