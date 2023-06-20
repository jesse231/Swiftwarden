//
//  Icon.swift
//  Swiftwarden
//
//  Created by Jesse Seeligsohn on 2023-05-16.
//

import SwiftUI
import NukeUI

struct Icon: View {
    let hostname: String?
    let itemType: ItemType
    let account: Account
    init(itemType: ItemType, hostname: String? = nil, account: Account) {
        self.itemType = itemType
        self.hostname = hostname
        self.account = account
    }
    var body: some View {
        if itemType == .password {
            if let hostname, hostname != "" {
                LazyImage(url: account.api.getIcons(host: hostname)) { state in
                    if let image = state.image {
                        image.resizable()
                    }
                }
                .background(.white)
                .clipShape(Rectangle())
                .cornerRadius(5)
                .frame(width: 35, height: 35)
            } else {
                Circle()
                    .foregroundColor(.black)
                    .frame(width: 35, height: 35)
                    .overlay(
                        Image(systemName: "lock.square.fill")
                            .resizable()
                            .foregroundColor(.white)
                            .frame(width: 35, height: 35)
                    )
            }
            } else if itemType == .card  {
            Rectangle()
                .foregroundColor(.white)
                .frame(width: 35, height: 35)
                .cornerRadius(5)
                .overlay(
                    Image(systemName: "creditcard.fill")
                        .resizable()
                        .foregroundColor(.black)
                        .background(.white)
                        .frame(width: 30, height: 25)
                )
            } else if itemType == .identity {
                Rectangle()
                    .foregroundColor(.white)
                    .frame(width: 35, height: 35)
                    .cornerRadius(5)
                    .overlay(
                        Image(systemName: "person.fill")
                            .resizable()
                            .foregroundColor(.black)
                            .background(.white)
                            .frame(width: 30, height: 30)
                    )
            } else if itemType == .secureNote {
                Rectangle()
                    .foregroundColor(.white)
                    .frame(width: 35, height: 35)
                    .cornerRadius(5)
                    .overlay(
                        Image(systemName: "lock.doc")
                            .resizable()
                            .foregroundColor(.black)
                            .background(.white)
                            .frame(width: 25, height: 30)
                    )
        }
    }
}

struct Icon_Previews: PreviewProvider {
    static var previews: some View {
        let account = Account()
        VStack {
            Icon(itemType: ItemType.password, hostname: "", account: account)
            Icon(itemType: ItemType.password, hostname: "test.com", account: account)
            Icon(itemType: ItemType.card, account: account)
            Icon(itemType: ItemType.identity, account: account)
            Icon(itemType: ItemType.secureNote, account: account)
            
        }
        // All Previews
    }
}
