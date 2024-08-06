// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let folder = try? newJSONDecoder().decode(Folder.self, from: jsonData)

import Foundation

// MARK: - Folder
struct Folder: Codable & Hashable & Identifiable {
    var id: String
    var object, revisionDate: String?
    var name: String

}

// MARK: Folder convenience initializers and mutators

extension Folder {
    init(data: Data) throws {
        let decoder = newJSONDecoder()
        decoder.keyDecodingStrategy = .custom(DecodingStrategy.lowercase)
        self = try decoder.decode(Folder.self, from: data)
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

//    func with(
//        id: String?? = nil,
//        name: String?? = nil,
//        object: String?? = nil,
//        revisionDate: String?? = nil
//    ) -> Folder {
//        return Folder(
//            id: id ?? self.id,
//            object: object ?? self.object,
//            revisionDate: revisionDate ?? self.revisionDate,
//            name: name ? self.name
//        )
//    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
