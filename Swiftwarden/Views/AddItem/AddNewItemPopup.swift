import SwiftUI

struct AddNewItemPopup: View {
    @EnvironmentObject var account: Account
    @Binding var show: Bool
    @State var name = ""
    
    @State var itemType: ItemType
    
    var body: some View {
        VStack {
            if name.count != 0{
                Text(name).font(.title).bold()
            } else {
                Text("New Password").font(.title).bold()
            }
            Divider()
                switch itemType {
                case .password:
                    AddPassword(account: account, name: $name, show: $show)
                case .card:
                    Text("Card")
                case .identity:
                    Text("identity")
                case .folder:
                    Text("folder")
                }
            }
        .padding()
        .frame(width: 500, height: 500)
    }
}
        struct AddNewItemPopup_Previews: PreviewProvider {
            @State static var show = true
            var account: Account = Account()
            static var previews: some View {
                AddNewItemPopup(show: $show, itemType: .password).environmentObject(Account())
            }
        }
