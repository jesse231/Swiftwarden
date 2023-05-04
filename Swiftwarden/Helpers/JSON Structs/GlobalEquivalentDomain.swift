// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let globalEquivalentDomain = try? newJSONDecoder().decode(GlobalEquivalentDomain.self, from: jsonData)

import Foundation

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
