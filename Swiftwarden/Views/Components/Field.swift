import Foundation
import SwiftUI

import SwiftUI

struct Field<Content: View>: View {
    var title: String
    var content: String
    var secure: Bool = false
    var monospaced: Bool = false
    var email: String?
    @ViewBuilder var buttons: Content
    @Binding var reprompt: RepromptState
    @Binding var showReprompt: Bool
    init(title: String,
         content: String,
         secure: Bool = false,
         reprompt: Binding<RepromptState>? = nil,
         showReprompt: Binding<Bool>? = nil,
         email: String? = nil,
         monospaced: Bool = false,
         @ViewBuilder buttons: () -> Content) {
        self.title = title
        self.content = content
        self.secure = secure
        self.monospaced = monospaced
        self._reprompt = reprompt ?? .constant(.none)
        self._showReprompt = showReprompt ?? .constant(false)
        self.email = email
        self.buttons = buttons()
    }
    
    @State private var showPassword: Bool = false
    @State private var isHovered = false

    var body: some View {
        HStack {
            VStack {
                Text(title)
                    .font(.system(size: 10))
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                    .foregroundColor(.gray)
                if !secure || showPassword {
                    Text(content)
                        .font(monospaced ? .system(size: 15, design: .monospaced) : .system(size: 15))
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                } else {
                    Text(String(repeating: "•", count: content.count))
                        .font(monospaced ? .system(size: 15, design: .monospaced) : .system(size: 15))
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                
                }
            }
            .padding()
            if isHovered {
                HStack {
                    if secure {
                        TogglePassword(showPassword: $showPassword, reprompt: reprompt != .none ? $reprompt : nil, showReprompt: $showReprompt)
                    }
                    buttons
                        .buttonStyle(.plain)
                }
                .padding(.trailing)
            }
        }
        .sheet(isPresented: $showReprompt) {
            if let email {
                RepromptPopup(showReprompt: $showReprompt, showPassword: $showPassword, reprompt: $reprompt, email: email)
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
            })
            Field(title: "Password",
                  content: "test",
                  secure: true,
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
            })
        }
    }
}
