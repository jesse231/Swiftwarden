//
//  ListElement.swift
//  Swiftwarden
//
//  Created by Jesse Seeligsohn on 2024-06-25.
//

import SwiftUI

struct ListElement: View {
    @EnvironmentObject var account: Account
    var cipher: Cipher
    @Binding var globCipher: Cipher
    var body: some View {
        HStack {
            Icon(itemType: ItemType.intToItemType(cipher.type ?? 1), hostname: cipher.login?.domain)
            Spacer().frame(width: 20)
            VStack {
                if let name = cipher.name {
                    Text(name)
//                        .id(UUID())
                        .font(.system(size: 15)).fontWeight(.semibold)
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                }
                Spacer().frame(height: 5)
                if let username = cipher.login?.username {
                    Text(verbatim: username)
                        .font(.system(size: 10))
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                }
                if let number = cipher.card?.number {
                    let lastFour = number.count != 0 ? "*" + String(number.suffix(4)) : ""
                    Text(verbatim: lastFour)
                        .font(.system(size: 10))
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                }
                if let identity = cipher.identity {
                    let firstName = identity.firstName != nil ? identity.firstName! + " " : ""
                    Text(verbatim: firstName + (identity.lastName ?? ""))
                        .font(.system(size: 10))
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                }
                if cipher.secureNote != nil, let notes = cipher.notes {
                    let previewLength = 30
                    let previewNotes = notes.count > previewLength ? String(notes.prefix(previewLength)) + "..." : String(notes.prefix(previewLength))
                    Text(verbatim: previewNotes)
                        .font(.system(size: 10))
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                }
            }
            if globCipher.favorite ?? false {
                Spacer()
                Image(systemName: "star.fill")
                    .foregroundColor(Color.yellow)
                    .animation(.default, value: globCipher.favorite)
                    .transition(.opacity)
            }
        }
        
    

    }
}

//#Preview {
//    ListElement(cipher: Cipher())
//}
