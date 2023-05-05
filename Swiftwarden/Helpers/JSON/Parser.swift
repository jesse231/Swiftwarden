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
            let lastKey = keys.last!.stringValue.lowercased()
            return AnyKey(stringValue: lastKey)!
        }
    }
}
