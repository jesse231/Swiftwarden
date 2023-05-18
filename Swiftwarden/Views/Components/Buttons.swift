import Foundation
import SwiftUI



struct Copy : View {
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
