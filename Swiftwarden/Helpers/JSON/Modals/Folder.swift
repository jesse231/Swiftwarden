// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let folder = try? newJSONDecoder().decode(Folder.self, from: jsonData)

import Foundation

// MARK: - Folder
struct Folder: Codable & Hashable & Identifiable {
    var id, name, object, revisionDate: String?

    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case name = "Name"
        case object = "Object"
        case revisionDate = "RevisionDate"
    }
}

// MARK: Folder convenience initializers and mutators

extension Folder {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Folder.self, from: data)
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
        id: String?? = nil,
        name: String?? = nil,
        object: String?? = nil,
        revisionDate: String?? = nil
    ) -> Folder {
        return Folder(
            id: id ?? self.id,
            name: name ?? self.name,
            object: object ?? self.object,
            revisionDate: revisionDate ?? self.revisionDate
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
