//
//  EditingField.swift
//  Swiftwarden
//
//  Created by Jesse Seeligsohn on 2023-05-10.
//

import SwiftUI

struct EditingField: View {
    var title: String
    @Binding var content: String
    var secure: Bool = false
    var body: some View {
            HStack{
                VStack{
                    Text(title)
                        .font(.system(size: 10))
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                        .foregroundColor(.gray)
                    GroupBox{
                        if (!secure) {
                            TextField(title, text: $content)
                                .textFieldStyle(.plain)
                                .frame(maxWidth: .infinity, alignment: .topLeading)
                        } else {
                            SecureField(title, text: $content)
                                .textFieldStyle(.plain)
                                .frame(maxWidth: .infinity, alignment: .topLeading)
                        }
                    }
                }
        }
    }
}

struct EditingField_Previews: PreviewProvider {
    @State static var content: String = "Initial Value"
    
    static var previews: some View {
        EditingField(title: "Title", content: $content)
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
