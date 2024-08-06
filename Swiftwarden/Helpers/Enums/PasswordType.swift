//
//  PasswordType.swift
//  Swiftwarden
//
//  Created by Jesse Seeligsohn on 2023-07-04.
//

import Foundation


enum PasswordListType: Equatable {
    case normal
    case trash
    case favorite
    case folder(String)
    case login
    case card
    case identity
    case secureNote
}
