// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let dataClass = try? newJSONDecoder().decode(DataClass.self, from: jsonData)

import Foundation

// MARK: - DataClass
struct DataClass: Codable & Hashable {
    var fields: [CustomField]?
    var name: String?
    var notes: String?
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
        case fields = "fields"
        case name = "name"
        case notes = "notes"
        case password = "password"
        case passwordHistory = "passwordhistory"
        case uri = "uri"
        case uris = "uris"
        case username = "username"
        case passwordRevisionDate = "passwordrevisiondate"
        case totp = "totp"
        case autofillOnPageLoad = "autofillonpageload"
        case brand = "brand"
        case cardholderName = "cardholdername"
        case code = "code"
        case expMonth = "expmonth"
        case expYear = "expyear"
        case number = "number"
        case address1 = "address1"
        case address2 = "address2"
        case address3 = "address3"
        case city = "city"
        case company = "company"
        case country = "country"
        case email = "email"
        case firstName = "firstname"
        case lastName = "lastname"
        case licenseNumber = "licensenumber"
        case middleName = "middlename"
        case passportNumber = "passportnumber"
        case phone = "phone"
        case postalCode = "postalcode"
        case ssn = "ssn"
        case state = "state"
        case title = "title"
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
        fields: [CustomField]?? = nil,
        name: String?? = nil,
        notes: String?? = nil,
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
