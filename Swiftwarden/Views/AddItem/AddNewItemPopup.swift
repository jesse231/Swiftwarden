import SwiftUI

struct AddNewItemPopup: View {
    @EnvironmentObject var account: Account
    @Binding var itemType: ItemType?
    @State private var name = ""
    private var defaultName: String
    init(itemType: Binding<ItemType?>) {
        self._itemType = itemType
        switch itemType.wrappedValue {
            case .password:
                self.defaultName = "New Password"
            case .card:
                self.defaultName = "New Card"
            case .identity:
                self.defaultName = "New Identity"
            case .secureNote:
                self.defaultName = "New Note"
            case .folder:
                self.defaultName = "New Folder"
            case .none:
                self.defaultName = "Error"
        }
    
    }
    
    var body: some View {
        VStack {
            if name.count != 0{
                Text(name).font(.title).bold()
            } else {
                Text(defaultName).font(.title).bold()
            }
            Divider()
            if let itemType {
                switch itemType {
                case .password:
                    AddPassword(account: account, name: $name, itemType: self.$itemType)
                case .card:
                    AddCard(account: account, name: $name, itemType: self.$itemType)
                case .identity:
                    AddIdentity(account: account, name: $name, itemType: self.$itemType)
                case .secureNote:
                    AddSecureNote(name: $name, itemType: self.$itemType).environmentObject(account)
                case .folder:
                    Text("folder")
                }
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
                Group {
                    AddNewItemPopup(itemType: .constant(.password)).environmentObject(Account())
//                    AddNewItemPopup(show: $show, itemType: .card).environmentObject(Account())
                }
            }
        }
