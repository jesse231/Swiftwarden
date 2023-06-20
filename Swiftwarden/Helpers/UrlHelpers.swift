//
//  UrlHelpers.swift
//  Swiftwarden
//
//  Created by Jesse Seeligsohn on 2023-06-20.
//

import Foundation

func extractHost(cipher: Cipher?) -> String {
    if let cipher {
        if let uri = cipher.login?.uri {
            if let noScheme = uri.split(separator: "//").dropFirst().first, let host = noScheme.split(separator: "/").first {
                return String(host)
            } else {
                return uri
            }
        }
    }
    return ""
}

func extractHostURI(uri: String?) -> String {
    if let uri {
        if let noScheme = uri.split(separator: "//").dropFirst().first, let host = noScheme.split(separator: "/").first {
            return String(host)
        } else {
            return uri
        }
    }
    return ""
}

func hasScheme(_ urlString: String) -> Bool {
    if let url = URL(string: urlString), let scheme = url.scheme {
        return !scheme.isEmpty
    }
    return false
}


