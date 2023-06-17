//
//  Identity.swift
//  Swiftwarden
//
//  Created by Jesse Seeligsohn on 2023-05-03.
//

import Foundation

struct Identity: Codable & Hashable {
    var address1, address2, address3, city: String?
    var company, country, email: String?
    var firstName, lastName: String?
    var licenseNumber: String?
    var middleName: String?
    var passportNumber, phone, postalCode: String?
    var ssn: String?
    var state: String?
    var title: String?
    var username: String?
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
        address1: String?? = nil,
        address2: String?? = nil,
        address3: String?? = nil,
        city: String?? = nil,
        company: String?? = nil,
        country: String?? = nil,
        email: String?? = nil,
        firstName: String?? = nil,
        lastName: String?? = nil,
        licenseNumber: String?? = nil,
        middleName: String?? = nil,
        passportNumber: String?? = nil,
        phone: String?? = nil,
        postalCode: String?? = nil,
        ssn: String?? = nil,
        state: String?? = nil,
        title: String?? = nil,
        username: String?? = nil
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
