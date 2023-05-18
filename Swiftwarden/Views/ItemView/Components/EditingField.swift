//
//  EditingField.swift
//  Swiftwarden
//
//  Created by Jesse Seeligsohn on 2023-05-10.
//

import SwiftUI
import Foundation

struct EditingField<Content: View>: View {
    var title: String
    @Binding var text: String
    
    var secure: Bool = false
    
    @ViewBuilder var buttons: Content
    
    @State private var isHovered = false

    var body: some View {
            HStack{
                VStack{
                    Text(title)
                        .font(.system(size: 10))
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                        .foregroundColor(.gray)
                    GroupBox{
                        HStack{
                            if (!secure) {
                                TextField(title, text: $text)
                                    .textFieldStyle(.plain)
                                    .frame(maxWidth: .infinity, alignment: .topLeading)
                            } else {
                                SecureField(title, text: $text)
                                    .textFieldStyle(.plain)
                                    .frame(maxWidth: .infinity, alignment: .topLeading)
                            }
                            buttons
                                .background(isHovered ? .gray.opacity(0.2) : .clear)
                                .cornerRadius(5)
                                .buttonStyle(.plain)
                                .onHover { hovering in
                                    withAnimation{
                                        isHovered = hovering
                                    }
                                }
                                .padding(.trailing)
                        }
                    }
                }
        }
    }
}

struct EditingField_Previews: PreviewProvider {
    @State static var content: String = "Initial Value"
    
    static var previews: some View {
        EditingField(title: "Title", text: $content, buttons: {
            Button {
            }
            label: {
                Image(systemName: "square.and.pencil")
            }
        
        })
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
