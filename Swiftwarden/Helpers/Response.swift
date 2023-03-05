// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let response = try Response(json)

import Foundation

// MARK: - Response
struct Response: Codable & Hashable {
    var ciphers: [Cipher]?
    var collections: [CollectionStructs.Collection]?
    var domains: Domains?
    var folders: [Folder]?
    var object: String?
//    var policies: [JSONAny]?
    var profile: Profile?
//    var sends: [JSONAny]?
    var unofficialServer: Bool?

    enum CodingKeys: String, CodingKey {
        case ciphers = "Ciphers"
        case collections = "Collections"
        case domains = "Domains"
        case folders = "Folders"
        case object = "Object"
//        case policies = "Policies"
        case profile = "Profile"
//        case sends = "Sends"
        case unofficialServer
    }
}

// MARK: Response convenience initializers and mutators

extension Response {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Response.self, from: data)
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
        ciphers: [Cipher]?? = nil,
        collections: [CollectionStructs.Collection]?? = nil,
        domains: Domains?? = nil,
        folders: [Folder]?? = nil,
        object: String?? = nil,
//        policies: [JSONAny]?? = nil,
        profile: Profile?? = nil,
//        sends: [JSONAny]?? = nil,
        unofficialServer: Bool?? = nil
    ) -> Response {
        return Response(
            ciphers: ciphers ?? self.ciphers,
            collections: collections ?? self.collections,
            domains: domains ?? self.domains,
            folders: folders ?? self.folders,
            object: object ?? self.object,
//            policies: policies ?? self.policies,
            profile: profile ?? self.profile,
//            sends: sends ?? self.sends,
            unofficialServer: unofficialServer ?? self.unofficialServer
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Cipher
struct Cipher: Codable & Hashable {
    var attachments: JSONNull?
    var card: Card?
    var collectionIDS: [String]?
    var creationDate: String?
    var data: DataClass?
    var deletedDate: String?
    var edit, favorite: Bool?
    var fields: JSONNull?
    var folderID: String?
    var id: String?
    var identity: Identity?
    var login: Login?
    var name: String?
    var notes: JSONNull?
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
        case attachments = "Attachments"
        case card = "Card"
        case collectionIDS = "CollectionIds"
        case creationDate = "CreationDate"
        case data = "Data"
        case deletedDate = "DeletedDate"
        case edit = "Edit"
        case favorite = "Favorite"
        case fields = "Fields"
        case folderID = "FolderId"
        case id = "Id"
        case identity = "Identity"
        case login = "Login"
        case name = "Name"
        case notes = "Notes"
        case object = "Object"
        case organizationID = "OrganizationId"
        case organizationUseTotp = "OrganizationUseTotp"
        case passwordHistory = "PasswordHistory"
        case reprompt = "Reprompt"
        case revisionDate = "RevisionDate"
        case secureNote = "SecureNote"
        case type = "Type"
        case viewPassword = "ViewPassword"
    }
}

// MARK: Cipher convenience initializers and mutators

extension Cipher {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Cipher.self, from: data)
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
        fields: JSONNull?? = nil,
        folderID: String?? = nil,
        id: String?? = nil,
        identity: Identity?? = nil,
        login: Login?? = nil,
        name: String?? = nil,
        notes: JSONNull?? = nil,
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

// MARK: - Card
struct Card: Codable & Hashable {
    var brand, cardholderName, code, expMonth: String?
    var expYear, number: String?

    enum CodingKeys: String, CodingKey {
        case brand = "Brand"
        case cardholderName = "CardholderName"
        case code = "Code"
        case expMonth = "ExpMonth"
        case expYear = "ExpYear"
        case number = "Number"
    }
}

// MARK: Card convenience initializers and mutators

extension Card {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Card.self, from: data)
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
        brand: String?? = nil,
        cardholderName: String?? = nil,
        code: String?? = nil,
        expMonth: String?? = nil,
        expYear: String?? = nil,
        number: String?? = nil
    ) -> Card {
        return Card(
            brand: brand ?? self.brand,
            cardholderName: cardholderName ?? self.cardholderName,
            code: code ?? self.code,
            expMonth: expMonth ?? self.expMonth,
            expYear: expYear ?? self.expYear,
            number: number ?? self.number
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - DataClass
struct DataClass: Codable & Hashable {
    var fields: JSONNull?
    var name: String?
    var notes: JSONNull?
    var password: String?
    var passwordHistory: [PasswordHistory]?
    var uri: String?
    var uris: [Uris]?
    var username, passwordRevisionDate, totp: String?
    var autofillOnPageLoad: JSONNull?
    var brand, cardholderName, code, expMonth: String?
    var expYear, number: String?
    var address1, address2, address3, city: JSONNull?
    var company, country, email: JSONNull?
    var firstName, lastName: String?
    var licenseNumber: JSONNull?
    var middleName: String?
    var passportNumber, phone, postalCode: JSONNull?
    var ssn: String?
    var state: JSONNull?
    var title: String?

    enum CodingKeys: String, CodingKey {
        case fields = "Fields"
        case name = "Name"
        case notes = "Notes"
        case password = "Password"
        case passwordHistory = "PasswordHistory"
        case uri = "Uri"
        case uris = "Uris"
        case username = "Username"
        case passwordRevisionDate = "PasswordRevisionDate"
        case totp = "Totp"
        case autofillOnPageLoad = "AutofillOnPageLoad"
        case brand = "Brand"
        case cardholderName = "CardholderName"
        case code = "Code"
        case expMonth = "ExpMonth"
        case expYear = "ExpYear"
        case number = "Number"
        case address1 = "Address1"
        case address2 = "Address2"
        case address3 = "Address3"
        case city = "City"
        case company = "Company"
        case country = "Country"
        case email = "Email"
        case firstName = "FirstName"
        case lastName = "LastName"
        case licenseNumber = "LicenseNumber"
        case middleName = "MiddleName"
        case passportNumber = "PassportNumber"
        case phone = "Phone"
        case postalCode = "PostalCode"
        case ssn = "SSN"
        case state = "State"
        case title = "Title"
    }
}

// MARK: DataClass convenience initializers and mutators

extension DataClass {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(DataClass.self, from: data)
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
        fields: JSONNull?? = nil,
        name: String?? = nil,
        notes: JSONNull?? = nil,
        password: String?? = nil,
        passwordHistory: [PasswordHistory]?? = nil,
        uri: String?? = nil,
        uris: [Uris]?? = nil,
        username: String?? = nil,
        passwordRevisionDate: String?? = nil,
        totp: String?? = nil,
        autofillOnPageLoad: JSONNull?? = nil,
        brand: String?? = nil,
        cardholderName: String?? = nil,
        code: String?? = nil,
        expMonth: String?? = nil,
        expYear: String?? = nil,
        number: String?? = nil,
        address1: JSONNull?? = nil,
        address2: JSONNull?? = nil,
        address3: JSONNull?? = nil,
        city: JSONNull?? = nil,
        company: JSONNull?? = nil,
        country: JSONNull?? = nil,
        email: JSONNull?? = nil,
        firstName: String?? = nil,
        lastName: String?? = nil,
        licenseNumber: JSONNull?? = nil,
        middleName: String?? = nil,
        passportNumber: JSONNull?? = nil,
        phone: JSONNull?? = nil,
        postalCode: JSONNull?? = nil,
        ssn: String?? = nil,
        state: JSONNull?? = nil,
        title: String?? = nil
    ) -> DataClass {
        return DataClass(
            fields: fields ?? self.fields,
            name: name ?? self.name,
            notes: notes ?? self.notes,
            password: password ?? self.password,
            passwordHistory: passwordHistory ?? self.passwordHistory,
            uri: uri ?? self.uri,
            uris: uris ?? self.uris,
            username: username ?? self.username,
            passwordRevisionDate: passwordRevisionDate ?? self.passwordRevisionDate,
            totp: totp ?? self.totp,
            autofillOnPageLoad: autofillOnPageLoad ?? self.autofillOnPageLoad,
            brand: brand ?? self.brand,
            cardholderName: cardholderName ?? self.cardholderName,
            code: code ?? self.code,
            expMonth: expMonth ?? self.expMonth,
            expYear: expYear ?? self.expYear,
            number: number ?? self.number,
            address1: address1 ?? self.address1,
            address2: address2 ?? self.address2,
            address3: address3 ?? self.address3,
            city: city ?? self.city,
            company: company ?? self.company,
            country: country ?? self.country,
            email: email ?? self.email,
            firstName: firstName ?? self.firstName,
            lastName: lastName ?? self.lastName,
            licenseNumber: licenseNumber ?? self.licenseNumber,
            middleName: middleName ?? self.middleName,
            passportNumber: passportNumber ?? self.passportNumber,
            phone: phone ?? self.phone,
            postalCode: postalCode ?? self.postalCode,
            ssn: ssn ?? self.ssn,
            state: state ?? self.state,
            title: title ?? self.title
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - PasswordHistory
struct PasswordHistory: Codable & Hashable {
    var lastUsedDate, password: String?

    enum CodingKeys: String, CodingKey {
        case lastUsedDate = "LastUsedDate"
        case password = "Password"
    }
}

// MARK: PasswordHistory convenience initializers and mutators

extension PasswordHistory {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(PasswordHistory.self, from: data)
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
        lastUsedDate: String?? = nil,
        password: String?? = nil
    ) -> PasswordHistory {
        return PasswordHistory(
            lastUsedDate: lastUsedDate ?? self.lastUsedDate,
            password: password ?? self.password
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Uris
struct Uris: Codable & Hashable {
    var uri: String?
    var match: Int?

    enum CodingKeys: String, CodingKey {
        case uri = "Uri"
        case match = "Match"
    }
}

// MARK: Uris convenience initializers and mutators

extension Uris {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Uris.self, from: data)
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
        uri: String?? = nil,
        match: Int?? = nil
    ) -> Uris {
        return Uris(
            uri: uri ?? self.uri,
            match: match ?? self.match
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Identity
struct Identity: Codable & Hashable {
    var address1, address2, address3, city: JSONNull?
    var company, country, email: JSONNull?
    var firstName, lastName: String?
    var licenseNumber: JSONNull?
    var middleName: String?
    var passportNumber, phone, postalCode: JSONNull?
    var ssn: String?
    var state: JSONNull?
    var title: String?
    var username: JSONNull?

    enum CodingKeys: String, CodingKey {
        case address1 = "Address1"
        case address2 = "Address2"
        case address3 = "Address3"
        case city = "City"
        case company = "Company"
        case country = "Country"
        case email = "Email"
        case firstName = "FirstName"
        case lastName = "LastName"
        case licenseNumber = "LicenseNumber"
        case middleName = "MiddleName"
        case passportNumber = "PassportNumber"
        case phone = "Phone"
        case postalCode = "PostalCode"
        case ssn = "SSN"
        case state = "State"
        case title = "Title"
        case username = "Username"
    }
}

// MARK: Identity convenience initializers and mutators

extension Identity {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Identity.self, from: data)
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
        address1: JSONNull?? = nil,
        address2: JSONNull?? = nil,
        address3: JSONNull?? = nil,
        city: JSONNull?? = nil,
        company: JSONNull?? = nil,
        country: JSONNull?? = nil,
        email: JSONNull?? = nil,
        firstName: String?? = nil,
        lastName: String?? = nil,
        licenseNumber: JSONNull?? = nil,
        middleName: String?? = nil,
        passportNumber: JSONNull?? = nil,
        phone: JSONNull?? = nil,
        postalCode: JSONNull?? = nil,
        ssn: String?? = nil,
        state: JSONNull?? = nil,
        title: String?? = nil,
        username: JSONNull?? = nil
    ) -> Identity {
        return Identity(
            address1: address1 ?? self.address1,
            address2: address2 ?? self.address2,
            address3: address3 ?? self.address3,
            city: city ?? self.city,
            company: company ?? self.company,
            country: country ?? self.country,
            email: email ?? self.email,
            firstName: firstName ?? self.firstName,
            lastName: lastName ?? self.lastName,
            licenseNumber: licenseNumber ?? self.licenseNumber,
            middleName: middleName ?? self.middleName,
            passportNumber: passportNumber ?? self.passportNumber,
            phone: phone ?? self.phone,
            postalCode: postalCode ?? self.postalCode,
            ssn: ssn ?? self.ssn,
            state: state ?? self.state,
            title: title ?? self.title,
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

// MARK: - Login
struct Login: Codable & Hashable {
    var password: String?
    var uri: String?
    var uris: [Uris]?
    var username, passwordRevisionDate, totp: String?
    var autofillOnPageLoad: JSONNull?

    enum CodingKeys: String, CodingKey {
        case password = "Password"
        case uri = "Uri"
        case uris = "Uris"
        case username = "Username"
        case passwordRevisionDate = "PasswordRevisionDate"
        case totp = "Totp"
        case autofillOnPageLoad = "AutofillOnPageLoad"
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

// MARK: - SecureNote
struct SecureNote: Codable & Hashable {
    var autofillOnPageLoad: JSONNull?
    var password: String?
    var passwordRevisionDate, totp: JSONNull?
    var uris: [Uris]?
    var username: String?

    enum CodingKeys: String, CodingKey {
        case autofillOnPageLoad = "AutofillOnPageLoad"
        case password = "Password"
        case passwordRevisionDate = "PasswordRevisionDate"
        case totp = "Totp"
        case uris = "Uris"
        case username = "Username"
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

// MARK: - Collection
enum CollectionStructs {
    struct Collection: Codable & Hashable {
        var externalID: JSONNull?
        var hidePasswords: Bool?
        var id, name, object, organizationID: String?
        var readOnly: Bool?
        
        enum CodingKeys: String, CodingKey {
            case externalID = "ExternalId"
            case hidePasswords = "HidePasswords"
            case id = "Id"
            case name = "Name"
            case object = "Object"
            case organizationID = "OrganizationId"
            case readOnly = "ReadOnly"
        }
    }
}
    
    // MARK: Collection convenience initializers and mutators
    
extension CollectionStructs.Collection {
        init(data: Data) throws {
            self = try newJSONDecoder().decode(CollectionStructs.Collection.self, from: data)
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
            externalID: JSONNull?? = nil,
            hidePasswords: Bool?? = nil,
            id: String?? = nil,
            name: String?? = nil,
            object: String?? = nil,
            organizationID: String?? = nil,
            readOnly: Bool?? = nil
        ) -> CollectionStructs.Collection {
            return CollectionStructs.Collection(
                externalID: externalID ?? self.externalID,
                hidePasswords: hidePasswords ?? self.hidePasswords,
                id: id ?? self.id,
                name: name ?? self.name,
                object: object ?? self.object,
                organizationID: organizationID ?? self.organizationID,
                readOnly: readOnly ?? self.readOnly
            )
        }
        
        func jsonData() throws -> Data {
            return try newJSONEncoder().encode(self)
        }
        
        func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
            return String(data: try self.jsonData(), encoding: encoding)
        }
    }

// MARK: - Domains
struct Domains: Codable & Hashable {
//    var equivalentDomains: [JSONAny]?
    var globalEquivalentDomains: [GlobalEquivalentDomain]?
    var object: String?

    enum CodingKeys: String, CodingKey {
//        case equivalentDomains = "EquivalentDomains"
        case globalEquivalentDomains = "GlobalEquivalentDomains"
        case object = "Object"
    }
}

// MARK: Domains convenience initializers and mutators

extension Domains {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Domains.self, from: data)
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
//        equivalentDomains: [JSONAny]?? = nil,
        globalEquivalentDomains: [GlobalEquivalentDomain]?? = nil,
        object: String?? = nil
    ) -> Domains {
        return Domains(
//            equivalentDomains: equivalentDomains ?? self.equivalentDomains,
            globalEquivalentDomains: globalEquivalentDomains ?? self.globalEquivalentDomains,
            object: object ?? self.object
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - GlobalEquivalentDomain
struct GlobalEquivalentDomain: Codable & Hashable {
    var domains: [String]?
    var excluded: Bool?
    var type: Int?

    enum CodingKeys: String, CodingKey {
        case domains = "Domains"
        case excluded = "Excluded"
        case type = "Type"
    }
}

// MARK: GlobalEquivalentDomain convenience initializers and mutators

extension GlobalEquivalentDomain {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(GlobalEquivalentDomain.self, from: data)
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
        domains: [String]?? = nil,
        excluded: Bool?? = nil,
        type: Int?? = nil
    ) -> GlobalEquivalentDomain {
        return GlobalEquivalentDomain(
            domains: domains ?? self.domains,
            excluded: excluded ?? self.excluded,
            type: type ?? self.type
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Folder
struct Folder: Codable & Hashable & Identifiable {
    var id, name, object, revisionDate: String?

    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case name = "Name"
        case object = "Object"
        case revisionDate = "RevisionDate"
    }
}

// MARK: Folder convenience initializers and mutators

extension Folder {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Folder.self, from: data)
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
        id: String?? = nil,
        name: String?? = nil,
        object: String?? = nil,
        revisionDate: String?? = nil
    ) -> Folder {
        return Folder(
            id: id ?? self.id,
            name: name ?? self.name,
            object: object ?? self.object,
            revisionDate: revisionDate ?? self.revisionDate
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

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
        case culture = "Culture"
        case email = "Email"
        case emailVerified = "EmailVerified"
        case forcePasswordReset = "ForcePasswordReset"
        case id = "Id"
        case key = "Key"
        case masterPasswordHint = "MasterPasswordHint"
        case name = "Name"
        case object = "Object"
        case organizations = "Organizations"
        case premium = "Premium"
        case privateKey = "PrivateKey"
//        case providerOrganizations = "ProviderOrganizations"
//        case providers = "Providers"
        case securityStamp = "SecurityStamp"
        case twoFactorEnabled = "TwoFactorEnabled"
        case status = "_Status"
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

// MARK: - Organization
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
        case enabled = "Enabled"
        case hasPublicAndPrivateKeys = "HasPublicAndPrivateKeys"
        case id = "Id"
        case identifier = "Identifier"
        case key = "Key"
        case maxCollections = "MaxCollections"
        case maxStorageGB = "MaxStorageGb"
        case name = "Name"
        case object = "Object"
        case providerID = "ProviderId"
        case providerName = "ProviderName"
        case resetPasswordEnrolled = "ResetPasswordEnrolled"
        case seats = "Seats"
        case selfHost = "SelfHost"
        case ssoBound = "SsoBound"
        case status = "Status"
        case type = "Type"
        case use2Fa = "Use2fa"
        case useAPI = "UseApi"
        case useDirectory = "UseDirectory"
        case useEvents = "UseEvents"
        case useGroups = "UseGroups"
        case usePolicies = "UsePolicies"
        case useSso = "UseSso"
        case useTotp = "UseTotp"
        case userID = "UserId"
        case usersGetPremium = "UsersGetPremium"
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

// MARK: - Helper functions for creating encoders and decoders

func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        decoder.dateDecodingStrategy = .iso8601
    }
    return decoder
}

func newJSONEncoder() -> JSONEncoder {
    let encoder = JSONEncoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        encoder.dateEncodingStrategy = .iso8601
    }
    return encoder
}

// MARK: - Encode/decode helpers

class JSONNull: Codable & Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}

class JSONCodingKey: CodingKey {
    let key: String

    required init?(intValue: Int) {
        return nil
    }

    required init?(stringValue: String) {
        key = stringValue
    }

    var intValue: Int? {
        return nil
    }

    var stringValue: String {
        return key
    }
}

