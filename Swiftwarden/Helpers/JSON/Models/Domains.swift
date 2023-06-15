// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let domains = try? newJSONDecoder().decode(Domains.self, from: jsonData)

import Foundation

// MARK: - Domains
struct Domains: Codable & Hashable {
//    var equivalentDomains: [JSONAny]?
    var globalEquivalentDomains: [GlobalEquivalentDomain]?
    var object: String?

    enum CodingKeys: String, CodingKey {
//        case equivalentDomains = "EquivalentDomains"
        case globalEquivalentDomains = "globalEquivalentDomains"
        case object = "object"
    }
}

// MARK: Domains convenience initializers and mutators

extension Domains {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Domains.self, from: data)
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
//        equivalentDomains: [JSONAny]?? = nil,
        globalEquivalentDomains: [GlobalEquivalentDomain]?? = nil,
        object: String?? = nil
    ) -> Domains {
        return Domains(
//            equivalentDomains: equivalentDomains ?? self.equivalentDomains,
            globalEquivalentDomains: globalEquivalentDomains ?? self.globalEquivalentDomains,
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
