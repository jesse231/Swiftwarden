import Foundation
import NukeUI
import SwiftUI

extension ItemView {
    struct SecureNoteView: View {
        @Binding var cipher: Cipher?
        @Binding var editing: Bool
        @Binding var reprompt: RepromptState
        @State var showReprompt: Bool = false
        @State var showPassword: Bool = false
        @StateObject var account: Account
        
        var body: some View {
                VStack {                    
                    HStack {
                        Icon(itemType: .secureNote, account: account)
                        VStack {
                            Text(cipher?.name ?? "")
                                .font(.system(size: 15))
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity, alignment: .topLeading)
                            Text(verbatim: "Secure Note")
                                .font(.system(size: 10))
                                .frame(maxWidth: .infinity, alignment: .topLeading)
                        }
                        FavoriteButton(cipher: $cipher, account: account)
                    }
                    .padding([.leading,.trailing], 5)
                    Divider()
                        .padding([.leading,.trailing], 5)
                    ScrollView {
                        VStack {
                            if let fields = cipher?.fields {
                                CustomFieldsView(fields)
                            }
                            
                            if let notes = cipher?.notes {
                                Field(title: "Note", content: notes, buttons: {})
                            }
                        }
                                .padding([.trailing])
                        }
                        .padding(.trailing)
                    }
                .frame(maxWidth: .infinity)
                .toolbar {
                    RegularCipherOptions(cipher: $cipher, editing: $editing, account: account)
            }
                
            }
        }
        
    }
struct SecureNoteView_Preview: PreviewProvider {
    static var previews: some View {
        Text("test")
    }
}

