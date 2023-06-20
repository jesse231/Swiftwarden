import Foundation
import NukeUI
import SwiftUI

enum RepromptState {
    case none
    case require
    case unlocked
    
    func reprompt() -> Bool {
        return self != .none
    }
    
    func toInt() -> Int {
        if self == .none {
            return 0
        } else {
            return 1
        }
    }
    
    static func fromInt(_ value: Int) -> RepromptState {
        if value == 0 {
            return .none
        } else {
            return .require
        }
    }
    
}



struct ItemView: View {
    @State var cipher: Cipher?
    @EnvironmentObject var account: Account

    @State var favorite: Bool

    @State var showPassword = false

    @State var editing: Bool = false
    @State var reprompt: RepromptState = .none

    init (cipher: Cipher?){
        _cipher = State(initialValue: cipher)
        if let repromptInt = cipher?.reprompt {
            reprompt = RepromptState.fromInt(repromptInt)
        }
        _favorite = State(initialValue:cipher?.favorite ?? false)
        
        editing = false
        showPassword = false
    }
    var body: some View {
        VStack {
            if let cipher {
                if cipher.type == 1 {
                    if !editing {
                        PasswordView(cipher: self.$cipher, editing: $editing, reprompt: $reprompt, account: account)
                            .padding(20)
                            .frame(maxWidth: 800)
                    } else {
                        PasswordEditing(cipher: $cipher, editing: $editing, account: account)
                            .padding(20)
                            .frame(maxWidth: 800)
                    }
                } else if cipher.type == 2{
                    if !editing {
                        SecureNoteView(cipher: self.$cipher, editing: $editing, reprompt: $reprompt, account: account)
                            .padding(20)
                            .frame(maxWidth: 800)
                    } else {
                        SecureNoteEditing(cipher: $cipher, editing: $editing, account: account)
                            .padding(20)
                            .frame(maxWidth: 800)
                    EmptyView()
                    }
                
            } else if cipher.type == 3 {
                if !editing {
                    CardView(cipher: self.$cipher, editing: $editing, reprompt: $reprompt, account: account)
                        .padding(20)
                        .frame(maxWidth: 800)
                } else {
                    CardEditing(cipher: $cipher, editing: $editing, account: account)
                        .padding(20)
                        .frame(maxWidth: 800)
                }
            } else if cipher.type == 4 {
                if !editing {
                    IdentityView(cipher: self.$cipher, editing: $editing, reprompt: $reprompt, account: account)
                        .padding(20)
                        .frame(maxWidth: 800)
                } else {
                    IdentityEditing(cipher: $cipher, editing: $editing, account: account)
                        .padding(20)
                        .frame(maxWidth: 800)
                }
            }
        }
        }
            .frame(maxWidth: .infinity, alignment: .topLeading)
        .toolbar {
            ToolbarItem {
                Spacer()
            }
        }
    }

    struct Preview: PreviewProvider {
        static var previews: some View {
            let cipher = Cipher(login: Login(password: "test", username: "test"), name: "Test", type: 1)
            let account = Account()
            Group {
                ItemView(cipher: cipher)
                    .environmentObject(account)
                    .padding()
            }
        }
    }
}
