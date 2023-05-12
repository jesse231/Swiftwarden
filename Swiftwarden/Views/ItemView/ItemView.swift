import Foundation
import NukeUI
import SwiftUI


struct ItemView : View {
    @State var cipher: Cipher? = Cipher()
    @State var hostname: String?
    @EnvironmentObject var account : Account
    
    @State var favourite: Bool
    @State var showPassword = false
    
    @State var editing: Bool = false
    
    var body: some View {
        GroupBox{
            if let cipher {
                if !editing{
                    HStack{
                        Button {
                            Task {
                                await try account.user.deleteCipher(cipher:cipher, api: account.api)
                                account.selectedCipher = Cipher()
                            }
                            self.cipher = nil
                        } label: {
                            Text("Delete")
                        }
                        Spacer()
                        Button {
                            editing = true

                        } label: {
                                Text("Edit")
                        }
                    }
                    VStack{
                        let name = cipher.name ?? ""//cipher.name ?? " "
                        let username = cipher.login?.username ?? " "
                        let password = cipher.login?.password ?? " "
                        HStack{
                            if let hostname{
                                LazyImage(url: account.api.getIcons(host: hostname))
                                { state in
                                    if let image = state.image {
                                        image.resizable()
                                    }
                                }
                                .clipShape(Circle())
                                .frame(width: 35, height: 35)
                            } else {
                                Image(systemName: "lock.circle")
                                    .resizable()
                                    .frame(width: 35, height: 35)
                            }
                            VStack{
                                Text(name)
                                    .font(.system(size: 15))
                                    .fontWeight(.semibold)
                                    .frame(maxWidth: .infinity, alignment: .topLeading)
                                Text(verbatim: "Login")
                                    .font(.system(size: 10))
                                    .frame(maxWidth: .infinity, alignment: .topLeading)
                                
                            }
                            Button (action: {
                                favourite = !favourite
                                
                                let index = account.user.getCiphers(deleted: true).firstIndex(of: account.selectedCipher)
                                
                                
                                account.selectedCipher.favorite = favourite
                                Task {
                                    do{
                                        try await account.user.updateCipher(cipher: account.selectedCipher, api: account.api, index: index)
                                    } catch {
                                        print(error)
                                    }
                                    
                                }

                            } ){
                                if (favourite) {
                                    Image(systemName: "star.fill")
                                        .foregroundColor(.yellow)
                                } else {
                                    Image(systemName: "star")
                                    
                                }
                            }.buttonStyle(.plain)
                            
                            
                        }
                        Divider()
                        if let card = cipher.card {
                            CardView(card: card)
                        } else {
                            Field(
                                title: "Username",
                                content: username,
                                buttons: {
                                    Copy(content: username)
                                })
                            Field(
                                title: "Password",
                                content: (showPassword ? password : String(repeating: "•", count: password.count)),
                                buttons: {
                                    Hide(toggle: $showPassword)
                                    Copy(content: password)
                                })
                            if let hostname{
                                Field(
                                    title: "Website",
                                    content: hostname,
                                    buttons: {
                                        Open(link: hostname)
                                        Copy(content: hostname)
                                    })
                            }
                            
                        }
                    }
                    .padding(20)
                    .frame(maxWidth: 400)
                    Spacer()
                } else {
                    if let binding = Binding<Cipher>($cipher) {
                        ItemEditingView(editing: $editing, cipher: binding).environmentObject(account)
                    }
                }
            }
        }
        .toolbar {
            ToolbarItem{
                Spacer()
            }
        }
    }
}


struct ItemView_Previews: PreviewProvider {
    static var previews: some View {
        let cipher = Cipher(login: Login(password: "test", username: "test"), name: "Test")
        let account = Account()
        
        return ItemView(cipher: cipher, hostname: "test.com", favourite: true)
            .environmentObject(account)
    }
}
