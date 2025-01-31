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
    
    // Options
    var secure: Bool = false
    var showTitle: Bool = true
    @State private var isHovered = false
    @State private var showPassword = false

    @ViewBuilder var buttons: Content

    var body: some View {
        HStack {
            VStack {
                if showTitle {
                    Text(title)
                        .font(.system(size: 10))
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                        .foregroundColor(.gray)
                        .padding(.bottom, 3)
                }
                GroupBox{
                    HStack {
                        if !secure || showPassword {
                            TextField(title, text: $text)
                                .textFieldStyle(.plain)
                                .textContentType(.username)
                                .autocorrectionDisabled()
                                .frame(maxWidth: .infinity, alignment: .topLeading)
                                .font(.system(size: 15))
                                .frame(height: 30)
                        } else {
                            SecureField(title, text: $text)
                                .textFieldStyle(.plain)
                                // prevent macos password popup
                                .textContentType(nil)
                                .autocorrectionDisabled()
                            
                                .frame(maxWidth: .infinity, alignment: .topLeading)
                                .font(.system(size: 15))
                                .frame(height: 30)
                        }
                        HStack {
                            if secure {
                                TogglePassword(showPassword: $showPassword)
                            }
                            buttons
                                .buttonStyle(.plain)
                        }
                        .padding(.trailing)
                    }
                }
                .padding(.top, -10)
                .padding(.leading, -5)
            }
//            .padding()
        }
    }
}

struct EditingField_Previews: PreviewProvider {
    @State static var content: String = "Initial Value"

    static var previews: some View {
        VStack {
            EditingField(title: "Title", text: $content, buttons: {
                GeneratePasswordButton(password: $content)
                
            })
            .padding()
            .previewLayout(.sizeThatFits)
            
            EditingField(title: "Username", text: .constant("User"), buttons: {
            })
            .padding()
            .previewLayout(.sizeThatFits)
        }
    }
}
