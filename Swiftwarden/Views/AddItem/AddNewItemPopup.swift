import SwiftUI

struct AddNewItemPopup: View {
    @EnvironmentObject var account: Account
    @Binding var show: Bool
    @State var name = ""
    @State var username = ""
    @State var password = ""
    @State var url = ""
    @State var folder = "Server"
    @State var favorite = false
    @State var reprompt = false
    @State var uris: [Uris] = [Uris(url: "")]
    
    @State var itemType: ItemType
    
    var body: some View {
        switch itemType {
        case .password:
            AddPassword(account: account)
                .padding()
                .frame(width: 500, height: 500)
        case .card:
            Text("Card")
        case .identity:
            Text("identity")
        case .folder:
            Text("folder")
        }
    }
}

struct AddNewItemPopup_Previews: PreviewProvider {
    @State static var show = true
    var account: Account = Account()
    static var previews: some View {
        AddNewItemPopup(show: $show, itemType: .password).environmentObject(Account())
    }
}
