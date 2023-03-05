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
            Button(action:{toggle = !toggle}) {
                Image(systemName: toggle ? "eye.slash" : "eye")
            }
            .buttonStyle(.plain)
    }
}

struct Open : View {
    var link: String
    var body : some View {
        Link(destination: URL(string: link)!) {
            Image(systemName: "link").foregroundColor(.primary)
        }
    }
}
