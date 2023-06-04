//
//  Generator.swift
//  Swiftwarden
//
//  Created by Jesse Seeligsohn on 2023-05-18.
//

import Foundation
import CryptoKit
import Darwin

enum GenError: Error {
    case message(String)
}

class Generator {
    static private func secureRandomInteger() throws -> UInt16 {
        var randomNumber: UInt16 = 0
        let result = SecRandomCopyBytes(kSecRandomDefault, MemoryLayout<UInt16>.size, &randomNumber)
        if result == errSecSuccess {
            return randomNumber
        } else {
            print("Failed to generate cryptographic number. Error: \(result)")
            throw GenError.message("Failed to generate cryptographic number. Error: \(result)")
        }
    }
    private func shuffle () {
    }

    static func makePassword (size: Int, upper: Bool = true, lower: Bool = true, num: Bool = true, special: Bool = true) throws -> String {
        let lowerCaseSet = "abcdefghijkmnopqrstuvwxyz"
        let upperCaseSet =  "ABCDEFGHJKLMNPQRSTUVWXYZ"
        let numberSet = "0123456789"
        let specialSet = "!@#$%^&*"
        var allCharSet = ""
        if upper {
            allCharSet += upperCaseSet
        }
        
        if lower {
            allCharSet += lowerCaseSet
        }
        
        if num {
            allCharSet += numberSet
        }
        
        if special {
            allCharSet += specialSet
        }
        var password = ""
        for _ in 0..<size {
            let random = try Int(secureRandomInteger())
                //print((random % allCharSet.count))
                let randomIndex = allCharSet.index(allCharSet.startIndex, offsetBy: random % (allCharSet.count))
                password.append(allCharSet[randomIndex])
        }
        return password
        }
}
