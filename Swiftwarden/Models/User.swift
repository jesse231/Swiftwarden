//
//  Account.swift
//  Swiftwarden
//
//  Created by Jesse Seeligsohn on 2023-03-02.
//

import Foundation

struct AccountData {
    var passwords: [Cipher] = []
    var folders: [Folder] = []
    var organizations: [Organization] = []
}

class User: ObservableObject {
    private var keys: [String: [UInt8]]
    private var api: Api
    private var email: String
    @Published private var data: AccountData

    init(sync: Response, api: Api, email: String) {
        self.api = api
        var symKeys: [String: [UInt8]] = [:]
        if let organizations = sync.profile?.organizations {
            for org in organizations {
                do {
                    symKeys[org.id!] = try Encryption.decOrg(org: org)
                } catch {

                }
            }
        }

        self.keys = symKeys
        self.data = AccountData()
        self.email = email

        if let ciphers = sync.ciphers {
            let decCiphers = decryptPasswords(dataList: ciphers)
            self.data.passwords = decCiphers
        }

        if let folders = sync.folders {
            var decFolders = Encryption.decryptFolders(dataList: folders)
            decFolders.insert(Folder(object: "Folder", name: "No Folder"), at: 0)
            self.data.folders = decFolders
        }
        }

    init (data: AccountData) {
        self.data = data
        self.keys = [:]
        self.api = Api()
        self.email = ""
    }

    // For testing
    init () {
        self.data = AccountData()
        self.keys = [:]
        self.api = Api()
        self.email = ""
        self.data.folders = [Folder(object: "Folder", name: "No Folder")]
    }

    private func decryptPasswords(dataList: [Cipher]) -> [Cipher] {
        var decDataList = dataList
        for (i, data) in dataList.enumerated() {
            do {
                decDataList[i] = try decryptCipher(data: data)
            } catch {
                print(error)
            }
        }
        return decDataList
    }

    private func decryptCipher(data: Cipher) throws -> Cipher {
        var dec = data
        var key: [UInt8]?
        if let id = dec.organizationID {
            key = self.keys[id]
        }
        dec.name = String(bytes: try Encryption.decrypt(decKey: key, str: data.name ?? ""), encoding: .utf8)
         if data.object! == "cipherDetails"{
             if let pass = dec.login?.password {
                 dec.login?.password = String(bytes: try Encryption.decrypt(decKey: key, str: pass), encoding: .utf8)
             }
             if let user = dec.login?.username {
                 dec.login?.username = String(bytes: try Encryption.decrypt(decKey: key, str: user), encoding: .utf8)
             }

             if let uri = dec.login?.uri {
                 dec.login?.uri = String(bytes: try Encryption.decrypt(decKey: key, str: uri), encoding: .utf8)
             }

             if let uris = dec.login?.uris {
                 for (i, uri) in uris.enumerated() {
                     let uri = uri.uri
                     if let decrypt = String(bytes: try Encryption.decrypt(decKey: key, str: uri), encoding: .utf8) {
                         dec.login?.uris?[i].uri = decrypt
                     }
                 }
             }
             if let card = dec.card {
                 dec.card?.brand = String(bytes: try Encryption.decrypt(str: card.brand ??  ""), encoding: .utf8) ?? card.brand
                 dec.card?.cardHolderName = String(bytes: try Encryption.decrypt(str: card.cardHolderName ??  ""), encoding: .utf8) ?? card.cardHolderName
                 dec.card?.code = String(bytes: try Encryption.decrypt(str: card.code ??  ""), encoding: .utf8) ?? card.code
                 dec.card?.expMonth = String(bytes: try Encryption.decrypt(str: card.expMonth ??  ""), encoding: .utf8) ?? card.expMonth
                 dec.card?.expYear = String(bytes: try Encryption.decrypt(str: card.expYear ?? ""), encoding: .utf8) ?? card.expYear
                 dec.card?.number = String(bytes: try Encryption.decrypt(str: card.number ?? ""), encoding: .utf8) ?? card.number
             }
         }

        return dec
    }
    
    func getEmail () -> String {
        return self.email
    }

    func getCiphers(deleted: Bool = false) -> [Cipher] {
        if deleted {
            return self.data.passwords
        } else {
            return self.data.passwords.filter({$0.deletedDate == nil})
        }
    }

    func getCiphersInFolder(folderID: String?) -> [Cipher] {
        return self.data.passwords.filter({$0.deletedDate == nil && $0.folderID == folderID})
    }

    func getCards() -> [Cipher] {
        return self.data.passwords.filter({$0.deletedDate == nil && $0.card != nil})
    }

    func getTrash() -> [Cipher] {
        return self.data.passwords.filter({$0.deletedDate != nil})
    }

    func getFavorites() -> [Cipher] {
        return self.data.passwords.filter({$0.deletedDate == nil && $0.favorite != false})
    }

    func getFolders() -> [Folder] {
        return self.data.folders
    }

    func deleteCipher(cipher: Cipher) async throws {
        if let index = self.data.passwords.firstIndex(of: cipher) {
            if let id = cipher.id {
                try await api.deletePassword(id: id)
                let dateFormatter = ISO8601DateFormatter()
                let dateString = dateFormatter.string(from: Date())
                self.data.passwords[index].deletedDate = dateString
            }
        }
    }

    func deleteCipherPermanently(cipher: Cipher) async throws {
        if let index = self.data.passwords.firstIndex(of: cipher) {
            if let id = cipher.id {
                try await api.deletePasswordPermanently(id: id)
                self.data.passwords.remove(at: index)
            }
        }
    }

    func addCipher(cipher: Cipher) async throws -> Cipher {
        var modCipher = cipher
        let retCipher = try await api.createPassword(cipher: cipher)
        modCipher.id = retCipher.id
        self.objectWillChange.send()
        self.data.passwords.append(modCipher)
        return modCipher
    }

    func updateCipher(cipher: Cipher, index: Array<Cipher>.Index? = nil) async throws {
            try await api.updatePassword(cipher: cipher)
        if let index {
            data.passwords[index] = cipher
        }
    }
    
    func addFolder(name: String) async throws {
        let encName = try Encryption.encrypt(str: name)
        let folder = try await api.createFolder(name: encName)
        data.folders.append(folder)
    }
    
    func deleteFolder(id: String) async throws {
        try await api.deleteFolder(id: id)
        if let index = self.data.folders.firstIndex(where: {$0.id == id}) {
            self.data.folders.remove(at: index)
        }
    }
}
