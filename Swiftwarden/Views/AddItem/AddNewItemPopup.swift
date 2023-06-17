import SwiftUI

struct AddNewItemPopup: View {
    @EnvironmentObject var account: Account
    @Binding var show: Bool
    @State private var name = ""
    private var defaultName: String
    @State var itemType: ItemType
    init(show: Binding<Bool>, itemType: ItemType) {
        self._show = show
        self.itemType = itemType
        switch itemType {
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
            switch itemType {
                case .password:
                    AddPassword(account: account, name: $name, show: $show)
                case .card:
                    AddCard(account: account, name: $name, show: $show)
                case .identity:
                    Text("identity")
                case .secureNote:
                    Text("Note")
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
                Group {
                    AddNewItemPopup(show: $show, itemType: .password).environmentObject(Account())
                    AddNewItemPopup(show: $show, itemType: .card).environmentObject(Account())
                }
            }
        }
