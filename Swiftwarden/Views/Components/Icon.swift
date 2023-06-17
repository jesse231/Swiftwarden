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
    let account: Account
    let systemImage: String?
    init(hostname: String?, account: Account) {
        self.hostname = hostname
        self.account = account
        self.systemImage = nil
    }
    
    init(systemImage: String?, account: Account) {
        self.hostname = nil
        self.account = account
        self.systemImage = systemImage
    }
    
    var body: some View {
        if let hostname, hostname != ""{
            LazyImage(url: account.api.getIcons(host: hostname)) { state in
                if let image = state.image {
                    image.resizable()
                }
            }
            .background(.white)
            .clipShape(Rectangle())
            .cornerRadius(5)
            .frame(width: 35, height: 35)
        } else if let systemImage {
            Rectangle()
                .foregroundColor(.white)
                .frame(width: 35, height: 35)
                .cornerRadius(5)
                .overlay(
                    Image(systemName: "creditcard")
                        .resizable()
                        .foregroundColor(.black)
                        .background(.white)
                        .frame(width: 30, height: 25)
                )
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
    }
}

struct Icon_Previews: PreviewProvider {
    static var previews: some View {
        let account = Account()
        Icon(hostname: "", account: account)
        Icon(systemImage: "creditcard.fill", account: account)
        Icon(hostname: "google.com", account: account)
    }
}
