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
    
    //Editing view
    @State var name: String = ""
    
    @State var username: String = ""
    @State var password: String = ""
    @State var hostnameEdit: String = ""
    
    @State var favorite: Bool = false
    @State var folder: Folder = Folder(id: "", name: "")
    @State var reprompt: Bool = false
    
    var body: some View {
        GroupBox{
            if let cipher {
                if !editing{
                    RegularView
                        .padding(20)
                        .frame(maxWidth: 400)
//                    Text("Test")
                } else {
                    EditingView
                        .padding(20)
                        .frame(maxWidth: 400)
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
        
        Group {
            ItemView(cipher: cipher, hostname: "test.com", favourite: true)
                .environmentObject(account)
//            ItemView(cipher: cipher, hostname: "test.com", favourite: true, editing: true)
//                .environmentObject(account)
        }
    }
}
