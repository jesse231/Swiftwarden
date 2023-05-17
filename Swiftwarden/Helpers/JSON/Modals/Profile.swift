// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let profile = try? newJSONDecoder().decode(Profile.self, from: jsonData)

import Foundation

// MARK: - Profile
struct Profile: Codable & Hashable {
    var culture, email: String?
    var emailVerified, forcePasswordReset: Bool?
    var id, key: String?
    var masterPasswordHint: JSONNull?
    var name, object: String?
    var organizations: [Organization]?
    var premium: Bool?
    var privateKey: String?
//    var providerOrganizations, providers: [JSONAny]?
    var securityStamp: String?
    var twoFactorEnabled: Bool?
    var status: Int?

    enum CodingKeys: String, CodingKey {
        case culture = "culture"
        case email = "email"
        case emailVerified = "emailVerified"
        case forcePasswordReset = "forcePasswordReset"
        case id = "id"
        case key = "key"
        case masterPasswordHint = "masterPasswordHint"
        case name = "name"
        case object = "object"
        case organizations = "organizations"
        case premium = "premium"
        case privateKey = "privateKey"
        case securityStamp = "securityStamp"
        case twoFactorEnabled = "twoFactorEnabled"
        case status = "_status"
    }
}

// MARK: Profile convenience initializers and mutators

extension Profile {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Profile.self, from: data)
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
        culture: String?? = nil,
        email: String?? = nil,
        emailVerified: Bool?? = nil,
        forcePasswordReset: Bool?? = nil,
        id: String?? = nil,
        key: String?? = nil,
        masterPasswordHint: JSONNull?? = nil,
        name: String?? = nil,
        object: String?? = nil,
        organizations: [Organization]?? = nil,
        premium: Bool?? = nil,
        privateKey: String?? = nil,
//        providerOrganizations: [JSONAny]?? = nil,
//        providers: [JSONAny]?? = nil,
        securityStamp: String?? = nil,
        twoFactorEnabled: Bool?? = nil,
        status: Int?? = nil
    ) -> Profile {
        return Profile(
            culture: culture ?? self.culture,
            email: email ?? self.email,
            emailVerified: emailVerified ?? self.emailVerified,
            forcePasswordReset: forcePasswordReset ?? self.forcePasswordReset,
            id: id ?? self.id,
            key: key ?? self.key,
            masterPasswordHint: masterPasswordHint ?? self.masterPasswordHint,
            name: name ?? self.name,
            object: object ?? self.object,
            organizations: organizations ?? self.organizations,
            premium: premium ?? self.premium,
            privateKey: privateKey ?? self.privateKey,
//            providerOrganizations: providerOrganizations ?? self.providerOrganizations,
//            providers: providers ?? self.providers,
            securityStamp: securityStamp ?? self.securityStamp,
            twoFactorEnabled: twoFactorEnabled ?? self.twoFactorEnabled,
            status: status ?? self.status
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
