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
    @State var isHovered = false

    @ViewBuilder var buttons: Content

    var body: some View {
        HStack {
            VStack {
                Text(title)
                    .font(.system(size: 10))
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                    .foregroundColor(.gray)
                GroupBox{
                    HStack {
                        if !secure {
                            TextField(title, text: $text)
                                .textFieldStyle(.plain)
                                .frame(maxWidth: .infinity, alignment: .topLeading)
                                .font(.system(size: 15))
                        } else {
                            SecureField(title, text: $text)
                                .textFieldStyle(.plain)
                                .frame(maxWidth: .infinity, alignment: .topLeading)
                                .font(.system(size: 15))
                        }
                        HStack {
                            buttons
                                .buttonStyle(.plain)
                        }
                        .padding(.trailing)
                    }
                }
                .padding(.top, -10)
                .padding(.leading, -5)
            }
            .padding()
        }
    }
}

struct EditingField_Previews: PreviewProvider {
    @State static var content: String = "Initial Value"

    static var previews: some View {
        EditingField(title: "Title", text: $content, buttons: {
            GeneratePasswordButton(password: $content)

        })
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
