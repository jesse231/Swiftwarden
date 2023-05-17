//
//  SecureNote.swift
//  Swiftwarden
//
//  Created by Jesse Seeligsohn on 2023-05-03.
//

import Foundation

struct SecureNote: Codable & Hashable {
    var autofillOnPageLoad: JSONNull?
    var password: String?
    var passwordRevisionDate, totp: JSONNull?
    var uris: [Uris]?
    var username: String?

    enum CodingKeys: String, CodingKey {
        case autofillOnPageLoad = "autofillOnPageLoad"
        case password = "password"
        case passwordRevisionDate = "passwordRevisionDate"
        case totp = "totp"
        case uris = "uris"
        case username = "username"
    }
}

// MARK: SecureNote convenience initializers and mutators

extension SecureNote {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(SecureNote.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        autofillOnPageLoad: JSONNull?? = nil,
        password: String?? = nil,
        passwordRevisionDate: JSONNull?? = nil,
        totp: JSONNull?? = nil,
        uris: [Uris]?? = nil,
        username: String?? = nil
    ) -> SecureNote {
        return SecureNote(
            autofillOnPageLoad: autofillOnPageLoad ?? self.autofillOnPageLoad,
            password: password ?? self.password,
            passwordRevisionDate: passwordRevisionDate ?? self.passwordRevisionDate,
            totp: totp ?? self.totp,
            uris: uris ?? self.uris,
            username: username ?? self.username
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
