// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let cipher = try? newJSONDecoder().decode(Cipher.self, from: jsonData)

import Foundation


// MARK: - Cipher
struct Cipher: Codable & Hashable & Identifiable {
    var attachments: JSONNull?
    var card: Card?
    var collectionIDS: [String]?
    var creationDate: String?
    var data: DataClass?
    var deletedDate: String?
    var edit, favorite: Bool?
    var fields: [CustomField]?
    var folderID: String?
    var id: String?
    var identity: Identity?
    var login: Login?
    var name: String?
    var notes: String?
    var object: String?
    var organizationID: String?
    var organizationUseTotp: Bool?
    var passwordHistory: [PasswordHistory]?
    var reprompt: Int?
    var revisionDate: String?
    var secureNote: SecureNote?
    var type: Int?
    var viewPassword: Bool?

    enum CodingKeys: String, CodingKey {
        case attachments = "attachments"
        case card = "card"
        case collectionIDS = "collectionIds"
        case creationDate = "creationDate"
        case data = "data"
        case deletedDate = "deletedDate"
        case edit = "edit"
        case favorite = "favorite"
        case fields = "fields"
        case folderID = "folderId"
        case id = "id"
        case identity = "identity"
        case login = "login"
        case name = "name"
        case notes = "notes"
        case object = "object"
        case organizationID = "organizationId"
        case organizationUseTotp = "organizationUseTotp"
        case passwordHistory = "passwordHistory"
        case reprompt = "reprompt"
        case revisionDate = "revisionDate"
        case secureNote = "secureNote"
        case type = "type"
        case viewPassword = "viewPassword"
    }
}

// MARK: Cipher convenience initializers and mutators

extension Cipher {
    
    init(data: Data) throws {
        let decoder = newJSONDecoder()
        decoder.keyDecodingStrategy = .custom(DecodingStrategy.lowercase)
        self = try decoder.decode(Cipher.self, from: data)
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
        attachments: JSONNull?? = nil,
        card: Card?? = nil,
        collectionIDS: [String]?? = nil,
        creationDate: String?? = nil,
        data: DataClass?? = nil,
        deletedDate: String?? = nil,
        edit: Bool?? = nil,
        favorite: Bool?? = nil,
        fields: [CustomField]?? = nil,
        folderID: String?? = nil,
        id: String?? = nil,
        identity: Identity?? = nil,
        login: Login?? = nil,
        name: String?? = nil,
        notes: String?? = nil,
        object: String?? = nil,
        organizationID: String?? = nil,
        organizationUseTotp: Bool?? = nil,
        passwordHistory: [PasswordHistory]?? = nil,
        reprompt: Int?? = nil,
        revisionDate: String?? = nil,
        secureNote: SecureNote?? = nil,
        type: Int?? = nil,
        viewPassword: Bool?? = nil
    ) -> Cipher {
        return Cipher(
            attachments: attachments ?? self.attachments,
            card: card ?? self.card,
            collectionIDS: collectionIDS ?? self.collectionIDS,
            creationDate: creationDate ?? self.creationDate,
            data: data ?? self.data,
            deletedDate: deletedDate ?? self.deletedDate,
            edit: edit ?? self.edit,
            favorite: favorite ?? self.favorite,
            fields: fields ?? self.fields,
            folderID: folderID ?? self.folderID,
            id: id ?? self.id,
            identity: identity ?? self.identity,
            login: login ?? self.login,
            name: name ?? self.name,
            notes: notes ?? self.notes,
            object: object ?? self.object,
            organizationID: organizationID ?? self.organizationID,
            organizationUseTotp: organizationUseTotp ?? self.organizationUseTotp,
            passwordHistory: passwordHistory ?? self.passwordHistory,
            reprompt: reprompt ?? self.reprompt,
            revisionDate: revisionDate ?? self.revisionDate,
            secureNote: secureNote ?? self.secureNote,
            type: type ?? self.type,
            viewPassword: viewPassword ?? self.viewPassword
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
