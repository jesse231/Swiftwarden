// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let login = try? newJSONDecoder().decode(Login.self, from: jsonData)

import Foundation

// MARK: - Login
struct Login: Codable & Hashable {
    var password: String?
    var uri: String?
    var uris: [Uris]?
    var username, passwordRevisionDate, totp: String?
    var autofillOnPageLoad: JSONNull?
    
    // Custom addition:
    var domain: String?
    enum CodingKeys: String, CodingKey {
        case password = "password"
        case uri = "uri"
        case uris = "uris"
        case username = "username"
        case passwordRevisionDate = "passwordRevisionDate"
        case totp = "totp"
        case autofillOnPageLoad = "autofillOnPageLoad"
    }
}

// MARK: Login convenience initializers and mutators

extension Login {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Login.self, from: data)
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
        password: String?? = nil,
        uri: String?? = nil,
        uris: [Uris]?? = nil,
        username: String?? = nil,
        passwordRevisionDate: String?? = nil,
        totp: String?? = nil,
        autofillOnPageLoad: JSONNull?? = nil
    ) -> Login {
        return Login(
            password: password ?? self.password,
            uri: uri ?? self.uri,
            uris: uris ?? self.uris,
            username: username ?? self.username,
            passwordRevisionDate: passwordRevisionDate ?? self.passwordRevisionDate,
            totp: totp ?? self.totp,
            autofillOnPageLoad: autofillOnPageLoad ?? self.autofillOnPageLoad
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
