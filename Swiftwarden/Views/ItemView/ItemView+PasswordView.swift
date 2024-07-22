import Foundation
import NukeUI
import SwiftUI

extension ItemView {
    struct PasswordView: View, Equatable {
        static func == (lhs: ItemView.PasswordView, rhs: ItemView.PasswordView) -> Bool {
            lhs.cipher == rhs.cipher
        }
        
        @Binding var cipher: Cipher?
        @Binding var editing: Bool
        @Binding var reprompt: RepromptState
        @State var showReprompt: Bool = false
        
        @Environment(\.api) var api: Api
        
        
        var body: some View {
            VStack {
                ViewHeader(itemType: .password, cipher: $cipher)
                ScrollView {
                    Group {
                        if let username = cipher?.login?.username {
                            Field(
                                title: "Username",
                                content: username,
                                showButton: true,
                                buttons: {
                                    Copy(content: username)
                                })
                        }
                        if let password = cipher?.login?.password {
                            Field(
                                title: "Password",
                                content: password,
                                secure: true,
                                reprompt: $reprompt,
                                showReprompt: $showReprompt,
                                showButton: true,
                                buttons: {
                                    Copy(content: password)
                                })
                        }
                        if let uris = cipher?.login?.uris {
                            ForEach(uris, id: \.self.id) { uri in
                                if let url = uri.uri {
                                    if url != "" {
                                        Field(
                                            title: "Website",
                                            content: extractHostURI(uri: url),
                                            showButton: true,
                                            buttons: {
                                                if hasScheme(url) {
                                                    Open(link: url)
                                                } else {
                                                    Open(link: "https://" + url)
                                                }
                                                Copy(content: url)
                                            })
                                    }
                                }
                            }
                        }
                        if let fields = cipher?.fields {
                            CustomFieldsView(fields)
                        }

                        if let notes = cipher?.notes {
                            Field(title: "Note", content: notes, showButton: false, buttons: {})
                        }
                    }
                    .padding()
                }
            }
            .toolbar {
                RegularCipherOptions(cipher: $cipher, editing: $editing)
        }
            
        }
    }
    
    
}


//struct ItemView_PasswordView_Previews: PreviewProvider {
//    static var previews: some View {
//        @State var cipher: Cipher? = Cipher(favorite: false, id: "1", login: Login(password: "test", uris: [Uris(uri: "https://google.com")], username: "test"), name: "Test", type: 1, bid: "")
//        ItemView.PasswordView(cipher: $cipher, editing: .constant(false), reprompt: .constant(.none))
//    }
//}
