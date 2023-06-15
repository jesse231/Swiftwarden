//
//  Organization.swift
//  Swiftwarden
//
//  Created by Jesse Seeligsohn on 2023-05-03.
//

import Foundation

struct Organization: Codable & Hashable {
    var enabled, hasPublicAndPrivateKeys: Bool?
    var id: String?
    var identifier: JSONNull?
    var key: String?
    var maxCollections, maxStorageGB: Int?
    var name, object: String?
    var providerID, providerName: JSONNull?
    var resetPasswordEnrolled: Bool?
    var seats: Int?
    var selfHost, ssoBound: Bool?
    var status, type: Int?
    var use2Fa, useAPI, useDirectory, useEvents: Bool?
    var useGroups, usePolicies, useSso, useTotp: Bool?
    var userID: String?
    var usersGetPremium: Bool?

    enum CodingKeys: String, CodingKey {
        case enabled = "enabled"
        case hasPublicAndPrivateKeys = "hasPublicAndPrivateKeys"
        case id = "id"
        case identifier = "identifier"
        case key = "key"
        case maxCollections = "maxCollections"
        case maxStorageGB = "maxStorageGB"
        case name = "name"
        case object = "object"
        case providerID = "providerID"
        case providerName = "providerName"
        case resetPasswordEnrolled = "resetPasswordEnrolled"
        case seats = "seats"
        case selfHost = "selfHost"
        case ssoBound = "ssoBound"
        case status = "status"
        case type = "type"
        case use2Fa = "use2Fa"
        case useAPI = "useAPI"
        case useDirectory = "useDirectory"
        case useEvents = "useEvents"
        case useGroups = "useGroups"
        case usePolicies = "usePolicies"
        case useSso = "useSso"
        case useTotp = "useTotp"
        case userID = "userID"
        case usersGetPremium = "usersGetPremium"
    }
}

// MARK: Organization convenience initializers and mutators

extension Organization {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Organization.self, from: data)
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
        enabled: Bool?? = nil,
        hasPublicAndPrivateKeys: Bool?? = nil,
        id: String?? = nil,
        identifier: JSONNull?? = nil,
        key: String?? = nil,
        maxCollections: Int?? = nil,
        maxStorageGB: Int?? = nil,
        name: String?? = nil,
        object: String?? = nil,
        providerID: JSONNull?? = nil,
        providerName: JSONNull?? = nil,
        resetPasswordEnrolled: Bool?? = nil,
        seats: Int?? = nil,
        selfHost: Bool?? = nil,
        ssoBound: Bool?? = nil,
        status: Int?? = nil,
        type: Int?? = nil,
        use2Fa: Bool?? = nil,
        useAPI: Bool?? = nil,
        useDirectory: Bool?? = nil,
        useEvents: Bool?? = nil,
        useGroups: Bool?? = nil,
        usePolicies: Bool?? = nil,
        useSso: Bool?? = nil,
        useTotp: Bool?? = nil,
        userID: String?? = nil,
        usersGetPremium: Bool?? = nil
    ) -> Organization {
        return Organization(
            enabled: enabled ?? self.enabled,
            hasPublicAndPrivateKeys: hasPublicAndPrivateKeys ?? self.hasPublicAndPrivateKeys,
            id: id ?? self.id,
            identifier: identifier ?? self.identifier,
            key: key ?? self.key,
            maxCollections: maxCollections ?? self.maxCollections,
            maxStorageGB: maxStorageGB ?? self.maxStorageGB,
            name: name ?? self.name,
            object: object ?? self.object,
            providerID: providerID ?? self.providerID,
            providerName: providerName ?? self.providerName,
            resetPasswordEnrolled: resetPasswordEnrolled ?? self.resetPasswordEnrolled,
            seats: seats ?? self.seats,
            selfHost: selfHost ?? self.selfHost,
            ssoBound: ssoBound ?? self.ssoBound,
            status: status ?? self.status,
            type: type ?? self.type,
            use2Fa: use2Fa ?? self.use2Fa,
            useAPI: useAPI ?? self.useAPI,
            useDirectory: useDirectory ?? self.useDirectory,
            useEvents: useEvents ?? self.useEvents,
            useGroups: useGroups ?? self.useGroups,
            usePolicies: usePolicies ?? self.usePolicies,
            useSso: useSso ?? self.useSso,
            useTotp: useTotp ?? self.useTotp,
            userID: userID ?? self.userID,
            usersGetPremium: usersGetPremium ?? self.usersGetPremium
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
