// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let passwordHistory = try? newJSONDecoder().decode(PasswordHistory.self, from: jsonData)

import Foundation

// MARK: - PasswordHistory
struct PasswordHistory: Codable & Hashable {
    var lastUsedDate, password: String?

    enum CodingKeys: String, CodingKey {
        case lastUsedDate = "lastUsedDate"
        case password = "password"
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
