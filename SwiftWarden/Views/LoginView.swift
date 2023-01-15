import SwiftUI

struct LoginView: View {
    @Binding var loginSuccess : Bool
    @State var email: String = "jesseseeligsohn@gmail.com"
    @State var password: String = "SfhboF19@"
    @State var server: String = "https://vaultwarden.seeligsohn.com"
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
        LoginView(loginSuccess: $show)
    }
}
