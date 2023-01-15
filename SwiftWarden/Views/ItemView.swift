import Foundation
import SwiftUI

struct ItemView : View {
    var cipher: Datum?
    var hostname: String
    @EnvironmentObject var allPasswords: Passwords
    @State var favourite: Bool
    @State var showPassword = false
    var body: some View {
        if let _ = cipher {
            List{
                VStack{
                    let name = cipher?.name ?? " "
                    let username = cipher?.login?.username ?? " "
                    let password = cipher?.login?.password ?? " "
                    HStack{
                        if let hostname = hostname{
                            AsyncImage(url: URL(string: "https://vaultwarden.seeligsohn.com/icons/\(hostname)/icon.png")) { image in
                                image.resizable()
                            } placeholder: {
                                ProgressView()
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
                            allPasswords.currentPassword?.favorite = favourite
                            Task {
                                try await Api.updatePassword(cipher: allPasswords.currentPassword!)
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
                        Field(
                            title: "Website",
                            content: hostname,
                            buttons: {
                                Open(link: hostname)
                                Copy(content: hostname)
                            })
                        
                    }
                }
                .padding(20)
                .frame(maxWidth: 400)
                Spacer()
            }
        } else {
            List{
                Spacer()
            }
            
        }
    }
}
