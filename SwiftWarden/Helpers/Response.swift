// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let response = try Response(json)

import Foundation

// MARK: - Response
struct Response: Codable & Hashable {
    var continuationToken: JSONNull?
    var data: [Datum]?
    var object: String?

    enum CodingKeys: String, CodingKey {
        case continuationToken = "ContinuationToken"
        case data = "Data"
        case object = "Object"
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
        continuationToken: JSONNull?? = nil,
        data: [Datum]?? = nil,
        object: String?? = nil
    ) -> Response {
        return Response(
            continuationToken: continuationToken ?? self.continuationToken,
            data: data ?? self.data,
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

// MARK: - Datum
struct Datum: Codable & Hashable {
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
    var object: Object?
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

// MARK: Datum convenience initializers and mutators

extension Datum {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Datum.self, from: data)
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
        object: Object?? = nil,
        organizationID: String?? = nil,
        organizationUseTotp: Bool?? = nil,
        passwordHistory: [PasswordHistory]?? = nil,
        reprompt: Int?? = nil,
        revisionDate: String?? = nil,
        secureNote: SecureNote?? = nil,
        type: Int?? = nil,
        viewPassword: Bool?? = nil
    ) -> Datum {
        return Datum(
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

enum Object: String, Codable & Hashable {
    case cipherDetails = "cipherDetails"
    case folder = "folder"
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
