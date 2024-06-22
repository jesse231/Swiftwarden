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
    @EnvironmentObject var account: Account
    @EnvironmentObject var routeManager: RouteManager
    @State var favorite: Bool = false
    
    
    @State var editing: Bool = false
    @State var reprompt: RepromptState = .none
    
    var body: some View {
        CustomScrollView {
            if routeManager.lastSelected != nil {
                if routeManager.lastSelected?.type == 1 {
                    if !editing {
                        PasswordView(cipher: self.$routeManager.lastSelected, editing: $editing, reprompt: $reprompt)
                            .padding(20)
                            .frame(maxWidth: 800)
                    } else {
                        PasswordEditing(cipher: $routeManager.lastSelected, editing: $editing, account: account)
                            .padding(20)
                            .frame(maxWidth: 800)
                    }
                } else if routeManager.lastSelected?.type == 2{
                    if !editing {
                        SecureNoteView(cipher: self.$routeManager.lastSelected, editing: $editing, reprompt: $reprompt, account: account)
                            .padding(20)
                            .frame(maxWidth: 800)
                    } else {
                        SecureNoteEditing(cipher: $routeManager.lastSelected, editing: $editing, account: account)
                            .padding(20)
                            .frame(maxWidth: 800)
                    }

                } else if routeManager.lastSelected?.type == 3 {
                    if !editing {
                        CardView(cipher: self.$routeManager.lastSelected, editing: $editing, reprompt: $reprompt, account: account)
                            .padding(20)
                            .frame(maxWidth: 800)
                    } else {
                        CardEditing(cipher: $routeManager.lastSelected, editing: $editing, account: account)
                            .padding(20)
                            .frame(maxWidth: 800)
                    }
                } else if routeManager.lastSelected?.type == 4 {
                    if !editing {
                        IdentityView(cipher: self.$routeManager.lastSelected, editing: $editing, reprompt: $reprompt, account: account)
                            .padding(20)
                            .frame(maxWidth: 800)
                    } else {
                        IdentityEditing(cipher: $routeManager.lastSelected, editing: $editing, account: account)
                            .padding(20)
                            .frame(maxWidth: 800)
                    }
                }
            } else {
                Text("No Password Selected")
                    .font(.title)
            }
        }
        .onAppear {
            if let repromptInt = routeManager.lastSelected?.reprompt {
                reprompt = RepromptState.fromInt(repromptInt)
            }
            favorite = routeManager.lastSelected?.favorite ?? false
        }
        .onChange(of: routeManager.lastSelected) { _ in
                editing = false
        }
        .ignoresSafeArea()
        .frame(minWidth: 400, idealWidth: 600, alignment: .topLeading)
        .toolbar {
            if routeManager.lastSelected == nil {
                ToolbarItem {
                    Spacer()
                }
            }
        }
    }
}

struct Preview: PreviewProvider {
    static var previews: some View {
        let cipher = Cipher(login: Login(password: "test", username: "test"), name: "Test", type: 1)
        let account = Account()
        Group {
            ItemView()
                .environmentObject(account)
                .padding()
        }
    }
}
