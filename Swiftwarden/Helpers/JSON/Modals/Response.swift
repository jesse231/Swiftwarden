// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let response = try? newJSONDecoder().decode(Response.self, from: jsonData)

import Foundation

// MARK: - Response
struct Response: Codable & Hashable {
    var ciphers: [Cipher]?
//    var collections: [CollectionStructs.Collection]?
    var domains: Domains?
    var folders: [Folder]?
    var object: String?
//    var policies: [JSONAny]?
    var profile: Profile?
//    var sends: [JSONAny]?
    var unofficialServer: Bool?

    enum CodingKeys: String, CodingKey {
        case ciphers = "ciphers"
//        case collections = "collections"
        case domains = "domains"
        case folders = "folders"
        case object = "object"
//        case policies = "Policies"
        case profile = "profile"
//        case sends = "Sends"
        case unofficialServer
    }
}

extension Response {
    init(data: Data) throws {
        let decoder = newJSONDecoder()
        decoder.keyDecodingStrategy = .custom(DecodingStrategy.lowercase)
        self = try decoder.decode(Response.self, from: data)
//        self = try newJSONDecoder().decode(Response.self, from: data)
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
        ciphers: [Cipher]?? = nil,
//        collections: [CollectionStructs.Collection]?? = nil,
        domains: Domains?? = nil,
        folders: [Folder]?? = nil,
        object: String?? = nil,
//        policies: [JSONAny]?? = nil,
        profile: Profile?? = nil,
//        sends: [JSONAny]?? = nil,
        unofficialServer: Bool?? = nil
    ) -> Response {
        return Response(
            ciphers: ciphers ?? self.ciphers,
//            collections: collections ?? self.collections,
            domains: domains ?? self.domains,
            folders: folders ?? self.folders,
            object: object ?? self.object,
//            policies: policies ?? self.policies,
            profile: profile ?? self.profile,
//            sends: sends ?? self.sends,
            unofficialServer: unofficialServer ?? self.unofficialServer
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
