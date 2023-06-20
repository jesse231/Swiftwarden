//
//  SecureNote.swift
//  Swiftwarden
//
//  Created by Jesse Seeligsohn on 2023-05-03.
//

import Foundation

struct SecureNote: Codable & Hashable {
    var type: Int = 1

    enum CodingKeys: String, CodingKey {
        case type
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
        type: Int? = 1
    ) -> SecureNote {
        return SecureNote(
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
