import Foundation

struct AnyKey: CodingKey {
    var stringValue: String

    init?(stringValue: String) {
        self.stringValue = stringValue
    }

    var intValue: Int? {
        return nil
    }

    init?(intValue: Int) {
        return nil
    }
}

struct DecodingStrategy {
    static var lowercase: ([CodingKey]) -> AnyKey {
        return { keys -> AnyKey in
            let lastKey = keys.last!.stringValue.prefix(1).lowercased() + keys.last!.stringValue.dropFirst()
            return AnyKey(stringValue: lastKey)!
        }
    }
}
