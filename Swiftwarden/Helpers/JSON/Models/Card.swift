//
//  Card.swift
//  Swiftwarden
//
//  Created by Jesse Seeligsohn on 2023-05-03.
//

import Foundation

struct Card: Codable & Hashable {
    var brand, cardHolderName, code, expMonth: String?
    var expYear, number: String?

    enum CodingKeys: String, CodingKey {
        case brand = "brand"
        case cardHolderName = "cardholderName"
        case code = "code"
        case expMonth = "expMonth"
        case expYear = "expYear"
        case number = "number"
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
        cardHolderName: String?? = nil,
        code: String?? = nil,
        expMonth: String?? = nil,
        expYear: String?? = nil,
        number: String?? = nil
    ) -> Card {
        return Card(
            brand: brand ?? self.brand,
            cardHolderName: cardHolderName ?? self.cardHolderName,
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
