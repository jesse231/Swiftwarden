import Foundation
import NukeUI
import SwiftUI

struct ItemView: View {
    @State var cipher: Cipher? = Cipher()
    @EnvironmentObject var account: Account

    @State var favorite: Bool

    @State var showPassword = false
    @State var hostname: String = ""

    @State var editing: Bool = false
    @State var hovering: Bool = false
    // Editing view
    @State var name: String = ""

    @State var username: String = ""
    @State var password: String = ""
    @State var url: String = ""

    @State var folder: Folder = Folder(id: "", name: "")
    @State var reprompt: Bool = false

    @State var uris: [Uris] = [Uris(url: "")]

    var body: some View {
            GroupBox {
                if let cipher {
                    if !editing {
                        RegularView
                            .padding(20)
                            .frame(maxWidth: 800)
                            .onAppear {
                                if let uri = cipher.login?.uri {
                                    if let noScheme = uri.split(separator: "//").dropFirst().first, let host = noScheme.split(separator: "/").first {
                                        hostname = String(host)
                                    } else {
                                        hostname = uri
                                    }
                                }
                            }
                    } else {
                        EditingView
                            .padding(20)
                            .frame(maxWidth: 800)
                    }

                }

        }
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .toolbar {
            ToolbarItem {
                Spacer()
            }
        }
        .onAppear {
            name = cipher?.name ?? ""
            username = cipher?.login?.username ?? ""
            password = cipher?.login?.password ?? ""
            if let uris = cipher?.login?.uris {
                self.uris = uris
            }
        }
    }

    struct ItemView_Previews: PreviewProvider {
        static var previews: some View {
            let cipher = Cipher(login: Login(password: "test", username: "test"), name: "Test")
            let account = Account()

            Group {
                ItemView(cipher: cipher, favorite: true)
                    .environmentObject(account)
            }
        }
    }
}
