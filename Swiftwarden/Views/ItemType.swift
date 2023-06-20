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
    
    static func intToItemType(_ type: Int) -> ItemType {
        if type == 1 {
            return .password
        } else if type == 2 {
            return .secureNote
        } else if type == 3{
            return .card
        } else {
            return .identity
        }
    }
}
