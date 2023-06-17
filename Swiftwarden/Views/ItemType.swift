//
//  ItemType.swift
//  Swiftwarden
//
//  Created by Jesse Seeligsohn on 2023-05-21.
//

import Foundation

enum ItemType: Identifiable {
    var id: ItemType {self}
    case password
    case card
    case identity
    case secureNote
    case folder
}
