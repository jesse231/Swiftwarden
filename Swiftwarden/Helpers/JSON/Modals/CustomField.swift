// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let field = try? newJSONDecoder().decode(Field.self, from: jsonData)

import Foundation
//
// MARK: - Field
struct CustomField: Codable & Hashable {
    var type: Int?
    var name, value: String?
    var linkedID: Int?

    enum CodingKeys: String, CodingKey {
        case type, name, value
        case linkedID = "linkedId"
    }
}
