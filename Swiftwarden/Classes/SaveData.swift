import Foundation
import Security
private let service = "Swiftwarden"

class KeyChain {

    static func saveUser(account: String, password: String) -> Bool {
            guard let passwordData = password.data(using: String.Encoding.utf8) else {
                return false
            }

            let query: [String: Any] = [
                kSecClass as String: kSecClassInternetPassword,
                kSecAttrAccount as String: account,
                kSecAttrServer as String: service,
                kSecValueData as String: passwordData
            ]

            let status = SecItemAdd(query as CFDictionary, nil)

            return status == errSecSuccess
    }

    static func getUser (account: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassInternetPassword,
            kSecAttrAccount as String: account,
            kSecAttrServer as String: service,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnAttributes as String: true,
            kSecReturnData as String: true
        ]

        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)

        guard status == errSecSuccess,
              let existingItem = item as? [String: Any],
              let passwordData = existingItem[kSecValueData as String] as? Data,
              let password = String(data: passwordData, encoding: String.Encoding.utf8)
        else {
            return nil
        }

        return password
    }

    static func deleteUser(account: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassInternetPassword,
            kSecAttrAccount as String: account,
            kSecAttrServer as String: service,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnAttributes as String: true,
            kSecReturnData as String: true
        ]

        _ = SecItemDelete(query as CFDictionary)

    }

}
