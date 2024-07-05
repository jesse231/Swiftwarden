//
//  Header.swift
//  Swiftwarden
//
//  Created by Jesse Seeligsohn on 2024-07-03.
//

import SwiftUI

struct ViewHeader: View {
    var itemType: ItemType
    @Binding var cipher: Cipher?
    var text: String = ""
    init(itemType: ItemType, cipher: Binding<Cipher?>) {
        self.itemType = itemType
        self._cipher = cipher
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
                Text(cipher?.name ?? "")
                    .font(.system(size: 15))
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                Text(verbatim: text)
                    .font(.system(size: 10))
                    .frame(maxWidth: .infinity, alignment: .topLeading)
            }
            FavoriteButton(cipher: $cipher)
        }
        .padding(.top)
        .padding([.leading,.trailing], 25)
        Divider()
        .padding([.leading,.trailing], 25)
    }
}

//#Preview {
//    Header(itemType: .constant(.pas))
//}
