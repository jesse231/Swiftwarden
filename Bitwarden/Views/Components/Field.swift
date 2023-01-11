//
//  Field.swift
//  Bitwarden
//
//  Created by Jesse Seeligsohn on 2022-08-03.
//

import Foundation
import SwiftUI

struct Field<Content: View> : View {
    var title: String
    var content: String
    @ViewBuilder var buttons: Content
    var body: some View {
        GroupBox{
            HStack{
                VStack{
                    Text(title)
                        .font(.system(size: 10))
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                        .foregroundColor(.gray)
                    Text(content)
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                }
                buttons
            }
        }
    }
}
