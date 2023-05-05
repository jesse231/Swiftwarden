//
//  Identity.swift
//  Swiftwarden
//
//  Created by Jesse Seeligsohn on 2023-05-03.
//

import Foundation

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
