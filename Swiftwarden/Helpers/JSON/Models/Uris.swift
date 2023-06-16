// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let uris = try? newJSONDecoder().decode(Uris.self, from: jsonData)

import Foundation

// MARK: - Uris
struct Uris: Codable & Hashable & Identifiable {
    var uri: String?
    var match: Int?
    var id: UUID = ID()

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

    init(url: String) {
        self.uri = url
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        uri: String?? = nil,
        match: Int?? = nil
    ) -> Uris {
        return Uris(
            uri: self.uri,
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
