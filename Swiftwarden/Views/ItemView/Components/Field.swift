import Foundation
import SwiftUI

import SwiftUI

struct Field<Content: View>: View {
    var title: String
    var content: String
    @ViewBuilder var buttons: Content
    var monospaced: Bool = false

    @State private var isHovered = false

    var body: some View {
        HStack {
            VStack {
                Text(title)
                    .font(.system(size: 10))
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                    .foregroundColor(.gray)
                Text(content)
                    .font(monospaced ? .system(size: 15, design: .monospaced) : .system(size: 15))
                    .frame(maxWidth: .infinity, alignment: .topLeading)
            }
            .padding()
            
            if isHovered {
                HStack {
                    buttons
                        .buttonStyle(.plain)
                }
                .padding(.trailing)
            }
        }
        .transition(.scale)
        .background(isHovered ? Color.gray.opacity(0.2) : Color.clear)
        .cornerRadius(5)
        .onHover { hovered in
            withAnimation {
                isHovered = hovered
            }
        }
    }
}

struct FieldPreview: PreviewProvider {
    static var previews: some View {
        List {
            Field(title: "Username",
                  content: "test",
                  buttons: {
                Button {
                }
                label: {
                    Image(systemName: "square.and.pencil")
                }
                Button {
                }
                label: {
                    Image(systemName: "square.and.pencil")
                }
                // .padding(.trailing)

            })
        }
    }
}
