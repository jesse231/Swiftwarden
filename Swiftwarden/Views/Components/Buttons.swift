import Foundation
import SwiftUI


struct FavoriteButton: View {
    @Binding var favorite: Bool
    @Binding var cipher: Cipher?
    @ObservedObject var account: Account
    
    @State private var hovering = false
    var body: some View {
        Button (action: {
            favorite = !favorite
            
            let index = account.user.getCiphers(deleted: true).firstIndex(of: account.selectedCipher)
            
            
            account.selectedCipher.favorite = favorite
            Task {
                do{
                    try await account.user.updateCipher(cipher: account.selectedCipher, api: account.api, index: index)
                } catch {
                    print(error)
                }
            }
        } ){
            RoundedRectangle(cornerRadius: 5)
                .frame(width: 30, height: 30)
                .foregroundColor(hovering ? .gray.opacity(0.5) : .clear)
                .overlay {
                    Image(systemName: favorite ? "star.fill" : "star")
                        .resizable()
                        .onHover{ hovering in
                            withAnimation(.easeIn(duration: 0.2)) {
                                self.hovering = hovering
                            }
                        }
                        .foregroundColor(favorite ? .yellow : .primary)
                        .frame(width: 20, height: 20)
                }
        }
        .buttonStyle(.borderless)
    }
}

struct Copy: View {
    var content: String
    let pasteboard = NSPasteboard.general
    
    var body : some View {
        Button (action: {
            pasteboard.declareTypes([.string], owner: nil)
            pasteboard.setString(content, forType: .string)
        }) {
            Image(systemName: "square.on.square")
        }
        .buttonStyle(.plain)
    }
}

struct Hide : View {
    @Binding var toggle: Bool
    var body : some View {
            Button(action:{
                toggle = !toggle}
            ) {
                Image(systemName: toggle ? "eye.slash.fill" : "eye.fill")
            }
            .buttonStyle(.plain)
    }
}

struct Open : View {
    var link: String
    var body : some View {
        if let url = URL(string: link){
            Link(destination: url) {
                Image(systemName: "link").foregroundColor(.primary)
            }
        } else {
            EmptyView()
        }
    }
}
