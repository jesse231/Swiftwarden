import Foundation
import SwiftUI

struct FavoriteButton: View {
    @Binding var cipher: Cipher?
    @ObservedObject var account: Account
    
    var body: some View {
        if let favorite = cipher?.favorite {
            Button {
                cipher?.favorite?.toggle()
                let index = account.user.getCiphers(deleted: true).firstIndex(of: account.selectedCipher)
                account.selectedCipher.favorite = cipher?.favorite
                Task {
                    do {
                        try await account.user.updateCipher(cipher: account.selectedCipher, index: index)
                    } catch {
                        print(error)
                    }
                }
            } label: {
                HoverSquare {
                    Image(systemName: favorite ? "star.fill" : "star")
                        .resizable()
                        .foregroundColor(favorite ? .yellow : .primary)
                        .frame(width: 20, height: 20)
                }
            }
            .buttonStyle(.borderless)
        }
    }
}

struct HoverSquare <Content: View>: View{
    @ViewBuilder var element: Content
    @State private var hovering = false
    var body: some View {
        RoundedRectangle(cornerRadius: 5)
            .frame(width: 30, height: 30)
            .foregroundColor(hovering ? .gray.opacity(0.5) : .clear)
            .overlay {
                element
                    .onHover { hovering in
                        withAnimation(.easeIn(duration: 0.2)) {
                            self.hovering = hovering
                        }
                    }
            }
    }
}

struct Copy: View {
    var content: String
    let pasteboard = NSPasteboard.general
    @State private var hovering = false
    var body: some View {
        Button {
            pasteboard.declareTypes([.string], owner: nil)
            pasteboard.setString(content, forType: .string)
        } label: {
            HoverSquare {
                Image(systemName: "square.on.square")
            }
        }
        .buttonStyle(.plain)
    }
}

struct RepromptPopup: View {
    @Binding var showReprompt: Bool
    @Binding var showPassword: Bool
    @Binding var reprompt: RepromptState
    @StateObject var account: Account
    
    @State private var masterPassword: String = ""
    
    var body: some View {
        Group {
            Text("Master Password Reprompt")
                .font(.title)
                .padding(.bottom, 10)
                EditingField(title: "", text: $masterPassword, secure: true, buttons: {})
                .padding([.leading, .trailing, .bottom])
                .onSubmit {
                    if (masterPassword == KeyChain.getUser(account: account.user.getEmail())) {
                        reprompt = .unlocked
                        showPassword = true
                    }
                    showReprompt = false
                }
        }
        .padding()
    }
}


struct TogglePassword: View {
    @Binding var showPassword: Bool
    @Binding var reprompt: RepromptState
    @Binding var showReprompt: Bool
    
    init(showPassword: Binding<Bool>, reprompt: Binding<RepromptState>? = nil, showReprompt: Binding<Bool>? = nil) {
        _showPassword = showPassword
        _reprompt = reprompt ?? .constant(.none)
        _showReprompt = showReprompt ?? .constant(false)
    }
    
    var body: some View {
        Button {
            if reprompt == .require {
                showReprompt = true
            } else {
                reprompt = .unlocked
                showPassword.toggle()
            }
        } label: {
            HoverSquare {
                Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
            }
        }
        .buttonStyle(.plain)
    }
}

struct Open: View {
    var link: String
    var body: some View {
        if let url = URL(string: link) {
            Link(destination: url) {
                HoverSquare {
                    Image(systemName: "link").foregroundColor(.primary)
                }
            }
        } else {
            EmptyView()
        }
    }
}
