import SwiftUI

struct LoginView: View {
    @Binding var loginSuccess : Bool
    @Binding var email: String
    @Binding var password: String
    @Binding var server: String
    var body: some View {
        VStack{
            Text("Log in").font(.title)
            TextField("Email Address", text: $email)
            SecureField("Password", text: $password)
            TextField("Server url", text: $server)
            Button("Login") {
                loginSuccess = true
            }
        }.padding().frame(maxWidth: 200)
        Spacer()
    }
}

//struct LoginView_Previews: PreviewProvider {
//    static var previews: some View {
//        LoginView()
//    }
//}
