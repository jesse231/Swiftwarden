//
//  EditHeader.swift
//  Swiftwarden
//
//  Created by Jesse Seeligsohn on 2024-07-03.
//

import SwiftUI

struct EditHeader: View {
    @Binding var name: String
    @Binding var favorite: Bool
    var cipher: Cipher?
    var itemType: ItemType
    var text: String = ""
    init(name: Binding<String>, favorite: Binding<Bool>, cipher: Cipher?, itemType: ItemType) {
        self._name = name
        self._favorite = favorite
        self.cipher = cipher
        self.itemType = itemType
        switch (itemType) {
        case .password:
            self.text = "Login"
            break
        case .card:
            self.text = "Credit Card"
            break
        case .identity:
            self.text = "Identity"
            break
        case .secureNote:
            self.text = "Secure Note"
            break
        default:
            break
        }
    }
    var body: some View {
        HStack {
            Icon(itemType: itemType, hostname: cipher?.login?.domain)
            VStack {
                TextField("No Name", text: $name)
                    .font(.system(size: 15))
                    .fontWeight(.semibold)
                    .textFieldStyle(.plain)
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                    .padding(.bottom, -3)
                Text(verbatim: text)
                    .font(.system(size: 10))
                    .frame(maxWidth: .infinity, alignment: .topLeading)
            }
            FavoriteEditingButton(favorite: $favorite)
        }
        .padding(.top)
        .padding([.leading,.trailing], 25)
        Divider()
        .padding([.leading,.trailing], 25)

    }
}
