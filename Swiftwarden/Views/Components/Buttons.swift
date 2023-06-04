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

struct Hide: View {
    @Binding var toggle: Bool
    var body: some View {
        Button {
            toggle = !toggle
        } label: {
            HoverSquare {
                Image(systemName: toggle ? "eye.slash.fill" : "eye.fill")
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
