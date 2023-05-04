// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let uris = try? newJSONDecoder().decode(Uris.self, from: jsonData)

import Foundation

// MARK: - Uris
struct Uris: Codable & Hashable {
    var uri: String?
    var match: Int?

    enum CodingKeys: String, CodingKey {
        case uri = "uri"
        case match = "match"
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
