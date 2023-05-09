import Foundation
import NukeUI
import SwiftUI


struct ItemView : View {
    var cipher: Cipher?
    var hostname: String?
    @EnvironmentObject var account : Account
//    @EnvironmentObject var allPasswords: Passwords
    @State var favourite: Bool
    @State var showPassword = false
    var body: some View {
        if let _ = cipher {
            GroupBox{
                VStack{
                    let name = cipher?.name ?? " "
                    let username = cipher?.login?.username ?? " "
                    let password = cipher?.login?.password ?? " "
                    HStack{
                        if let hostname = hostname{
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
                            account.selectedCipher.favorite = favourite
//                            allPasswords.favourites.append(allPasswords.currentPassworzd)
                            Task {
                                try await account.api.updatePassword(cipher: account.selectedCipher)
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
                    if let card = cipher?.card {
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
            }
            .toolbar {
                ToolbarItem{
                    Spacer()
                }
            }
        } else {
            GroupBox{
                Spacer()
                    .frame(maxWidth: .infinity)
            }
            .toolbar {
                ToolbarItem{
                    Spacer()
                }
            }
            
        }
    }
}


