//
//  PreLogin.swift
//  Swiftwarden
//
//  Created by Jesse Seeligsohn on 2023-05-03.
//

import Foundation

struct PreLogin: Codable & Hashable {
    let kdf, kdfIterations: Int?
    let kdfMemory, kdfParallelism: JSONNull?

    enum CodingKeys: String, CodingKey {
        case kdf = "kdf"
        case kdfIterations = "kdfIterations"
        case kdfMemory = "kdfMemory"
        case kdfParallelism = "kdfParallelism"
    }

}
extension PreLogin {
    init(data: Data) throws {
        let decoder = newJSONDecoder()
        decoder.keyDecodingStrategy = .custom(DecodingStrategy.lowercase)
        self = try decoder.decode(PreLogin.self, from: data)
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
        kdf: Int? = nil,
        kdfIterations: Int? = nil,
        kdfMemory: JSONNull?? = nil,
        kdfParallelism: JSONNull?? = nil
    ) -> PreLogin {
        return PreLogin(
            kdf: kdf ?? self.kdf,
            kdfIterations: kdfIterations ?? self.kdfIterations,
            kdfMemory: kdfMemory ?? self.kdfMemory,
            kdfParallelism: kdfParallelism ?? self.kdfParallelism
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
