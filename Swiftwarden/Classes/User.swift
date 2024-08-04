//
//  Account.swift
//  Swiftwarden
//
//  Created by Jesse Seeligsohn on 2023-03-02.
//

import Foundation
import SwiftUI

class AccountData: ObservableObject {
    @Published var passwords: [Cipher] = []
    @Published var currentPasswords: [Cipher] = []
    var folders: [Folder] = []
    var organizations: [Organization] = []
}

class User: ObservableObject {
    private var keys: [String: [UInt8]]
    private var api: Api
    private var email: String
    @Published var data: AccountData
    
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
            self.data.currentPasswords = decCiphers
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
                let decUri = String(bytes: try Encryption.decrypt(decKey: key, str: uri), encoding: .utf8)
                dec.login?.uri = decUri
                dec.login?.domain = extractHostURI(uri: decUri)
            }
            
            if let uris = dec.login?.uris {
                for (i, uri) in uris.enumerated() {
                    if let uri = uri.uri, let decrypt = String(bytes: try Encryption.decrypt(decKey: key, str: uri), encoding: .utf8) {
                        dec.login?.uris?[i].uri = decrypt
                    }
                }
            }
            
            if let fields = dec.fields {
                for (i, field) in fields.enumerated() {
                    if let name = field.name {
                        dec.fields?[i].name = String(bytes: try Encryption.decrypt(decKey: key, str: name), encoding: .utf8)
                    }
                    if let value = field.value {
                        dec.fields?[i].value = String(bytes: try Encryption.decrypt(decKey: key, str: value), encoding: .utf8)
                    }
                }
            }
            
            if let notes = dec.notes {
                dec.notes = String(bytes: try Encryption.decrypt(decKey: key, str: notes), encoding: .utf8)
            }
            
            if let card = dec.card {
                if let brand = card.brand {
                    dec.card?.brand = String(bytes: try Encryption.decrypt(decKey: key, str: brand), encoding: .utf8)
                }
                if let code = card.code {
                    dec.card?.code = String(bytes: try Encryption.decrypt(decKey: key, str: code), encoding: .utf8)
                }
                if let expMonth = card.expMonth {
                    dec.card?.expMonth = String(bytes: try Encryption.decrypt(decKey: key, str: expMonth), encoding: .utf8)
                }
                if let expYear = card.expYear {
                    dec.card?.expYear = String(bytes: try Encryption.decrypt(decKey: key, str: expYear), encoding: .utf8)
                }
                if let number = card.number {
                    dec.card?.number = String(bytes: try Encryption.decrypt(decKey: key, str: number), encoding: .utf8)
                }
                if let cardHolderName = card.cardHolderName {
                    dec.card?.cardHolderName = String(bytes: try Encryption.decrypt(decKey: key, str: cardHolderName), encoding: .utf8)
                }
            }
            
            if let identity = dec.identity {
                if let title = identity.title {
                    dec.identity?.title = String(bytes: try Encryption.decrypt(decKey: key, str: title), encoding: .utf8)
                }
                if let firstName = identity.firstName {
                    dec.identity?.firstName = String(bytes: try Encryption.decrypt(decKey: key, str: firstName), encoding: .utf8)
                }
                if let middleName = identity.middleName {
                    dec.identity?.middleName = String(bytes: try Encryption.decrypt(decKey: key, str: middleName), encoding: .utf8)
                }
                if let lastName = identity.lastName {
                    dec.identity?.lastName = String(bytes: try Encryption.decrypt(decKey: key, str: lastName), encoding: .utf8)
                }
                if let address1 = identity.address1 {
                    dec.identity?.address1 = String(bytes: try Encryption.decrypt(decKey: key, str: address1), encoding: .utf8)
                }
                if let address2 = identity.address2 {
                    dec.identity?.address2 = String(bytes: try Encryption.decrypt(decKey: key, str: address2), encoding: .utf8)
                }
                if let address3 = identity.address3 {
                    dec.identity?.address3 = String(bytes: try Encryption.decrypt(decKey: key, str: address3), encoding: .utf8)
                }
                if let city = identity.city {
                    dec.identity?.city = String(bytes: try Encryption.decrypt(decKey: key, str: city), encoding: .utf8)
                }
                if let state = identity.state {
                    dec.identity?.state = String(bytes: try Encryption.decrypt(decKey: key, str: state), encoding: .utf8)
                }
                if let postalCode = identity.postalCode {
                    dec.identity?.postalCode = String(bytes: try Encryption.decrypt(decKey: key, str: postalCode), encoding: .utf8)
                }
                if let country = identity.country {
                    dec.identity?.country = String(bytes: try Encryption.decrypt(decKey: key, str: country), encoding: .utf8)
                }
                if let company = identity.company {
                    dec.identity?.company = String(bytes: try Encryption.decrypt(decKey: key, str: company), encoding: .utf8)
                }
                if let ssn = identity.ssn {
                    dec.identity?.ssn = String(bytes: try Encryption.decrypt(decKey: key, str: ssn), encoding: .utf8)
                }
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
    
    func getGlobalIndex(of cipher: Cipher) -> Array<Cipher>.Index? {
        return self.data.passwords.firstIndex(where: {$0.bid == cipher.bid})
    }
    
    func getFilteredIndex(of cipher: Cipher) -> Array<Cipher>.Index? {
        return self.data.currentPasswords.firstIndex(where: {$0.id == cipher.id})
    }
    
    func getCiphersInFolder(folderID: String?) -> [Cipher] {
        return self.data.passwords.filter({$0.deletedDate == nil && $0.folderID == folderID})
    }
    
    func getLogins() -> [Cipher] {
        return self.data.passwords.filter({$0.deletedDate == nil && $0.login != nil})
    }
    
    func getCards() -> [Cipher] {
        return self.data.passwords.filter({$0.deletedDate == nil && $0.card != nil})
    }
    
    func getIdentities() -> [Cipher] {
        return self.data.passwords.filter({$0.deletedDate == nil && $0.identity != nil})
    }
    
    func getSecureNotes() -> [Cipher] {
        return self.data.passwords.filter({$0.deletedDate == nil && $0.secureNote != nil})
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
    
    func deleteCipher(cipher: Cipher) {
        if let index = self.data.passwords.firstIndex(of: cipher) {
            if let bid = cipher.bid {
                Task {
                    try await api.deletePassword(id: bid)
                }
                let dateFormatter = ISO8601DateFormatter()
                let dateString = dateFormatter.string(from: Date())
                self.data.passwords[index].deletedDate = dateString
                if let index = self.data.currentPasswords.firstIndex(of: cipher) {
                    self.data.currentPasswords.remove(at: index)
                }
            }
            }
        }
    
    func deleteCipherPermanently(cipher: Cipher)  {
        if let index = self.data.passwords.firstIndex(of: cipher) {
            if let bid = cipher.bid {
                Task {
                    try await api.deletePasswordPermanently(id: bid)
                }
                self.data.passwords.remove(at: index)
                if let index = self.data.currentPasswords.firstIndex(of: cipher) {
                    self.data.currentPasswords.remove(at: index)
                }
            }
        }
    }
    func restoreCipher(cipher: Cipher) {
        if let bid = cipher.bid {
            Task {
                try await api.restoreCipher(id: bid)
            }
            if let index = self.data.passwords.firstIndex(of: cipher) {
                    self.data.passwords[index].deletedDate = nil
            }
            if let index = self.data.currentPasswords.firstIndex(of: cipher) {
                self.data.currentPasswords.remove(at: index)
            }
        }
    }
    
    func addCipher(cipher: Cipher) async throws -> Cipher {
        var modCipher = cipher
        let retCipher = try await api.createPassword(cipher: cipher)
        modCipher.id = retCipher.id
        DispatchQueue.main.async {
            self.data.passwords.append(modCipher)
        }
        return modCipher
    }
    
    func encryptCipher(cipher: Cipher) throws -> Cipher {
        var encCipher = cipher
        var encKey: [UInt8]?
        if let id = cipher.organizationID {
            encKey = self.keys[id]
        }
        if let name = cipher.name {
            encCipher.name = try Encryption.encrypt(encKey: encKey, str: name)
        }
        
        if let login = cipher.login {
            if let username = login.username {
                encCipher.login?.username = try Encryption.encrypt(encKey: encKey, str: username)
            }
            if let password = login.password {
                encCipher.login?.password = try Encryption.encrypt(encKey: encKey, str: password)
            }
            if let uri = login.uri {
                encCipher.login?.uri = try Encryption.encrypt(encKey: encKey, str: uri)
            }
            
            if let uris = login.uris {
                for (i, uri) in uris.enumerated() {
                    if let uri = uri.uri {
                        if i == 0 {
                            encCipher.login?.uri = try Encryption.encrypt(encKey: encKey, str: uri)
                        }
                        encCipher.login?.uris?[i].uri = try Encryption.encrypt(encKey: encKey, str: uri)
                    }
                }
            }
        }
        
        if let card = cipher.card {
            if let number = card.number {
                encCipher.card?.number = try Encryption.encrypt(encKey: encKey, str: number)
            }
            if let cardHolderName = card.cardHolderName {
                encCipher.card?.cardHolderName = try Encryption.encrypt(encKey: encKey, str: cardHolderName)
            }
            if let brand = card.brand {
                encCipher.card?.brand = try Encryption.encrypt(encKey: encKey, str: brand)
            }
            if let expMonth = card.expMonth {
                encCipher.card?.expMonth = try Encryption.encrypt(encKey: encKey, str: expMonth)
            }
            if let expYear = card.expYear {
                encCipher.card?.expYear = try Encryption.encrypt(encKey: encKey, str: expYear)
            }
            if let code = card.code {
                encCipher.card?.code = try Encryption.encrypt(encKey: encKey, str: code)
            }
        }
        
        if let identity = cipher.identity {
            if let title = identity.title {
                encCipher.identity?.title = try Encryption.encrypt(encKey: encKey, str: title)
            }
            if let firstName = identity.firstName {
                encCipher.identity?.firstName = try Encryption.encrypt(encKey: encKey, str: firstName)
            }
            if let middleName = identity.middleName {
                encCipher.identity?.middleName = try Encryption.encrypt(encKey: encKey, str: middleName)
            }
            if let lastName = identity.lastName {
                encCipher.identity?.lastName = try Encryption.encrypt(encKey: encKey, str: lastName)
            }
            if let address1 = identity.address1 {
                encCipher.identity?.address1 = try Encryption.encrypt(encKey: encKey, str: address1)
            }
            if let address2 = identity.address2 {
                encCipher.identity?.address2 = try Encryption.encrypt(encKey: encKey, str: address2)
            }
            if let address3 = identity.address3 {
                encCipher.identity?.address3 = try Encryption.encrypt(encKey: encKey, str: address3)
            }
            if let city = identity.city {
                encCipher.identity?.city = try Encryption.encrypt(encKey: encKey, str: city)
            }
            if let state = identity.state {
                encCipher.identity?.state = try Encryption.encrypt(encKey: encKey, str: state)
            }
            if let postalCode = identity.postalCode {
                encCipher.identity?.postalCode = try Encryption.encrypt(encKey: encKey, str: postalCode)
            }
            if let country = identity.country {
                encCipher.identity?.country = try Encryption.encrypt(encKey: encKey, str: country)
            }
            if let company = identity.company {
                encCipher.identity?.company = try Encryption.encrypt(encKey: encKey, str: company)
            }
            if let ssn = identity.ssn {
                encCipher.identity?.ssn = try Encryption.encrypt(encKey: encKey, str: ssn)
            }
        }
        
        if let fields = cipher.fields {
            for (i, field) in fields.enumerated() {
                if let name = field.name {
                    encCipher.fields?[i].name = try Encryption.encrypt(encKey: encKey, str: name)
                }
                if let value = field.value {
                    encCipher.fields?[i].value = try Encryption.encrypt(encKey: encKey, str: value)
                }
            }
        }
        
        if let secureNote = cipher.notes {
            encCipher.notes = try Encryption.encrypt(encKey: encKey, str: secureNote)
        }
        
        return encCipher
    }
    
    func updateCipher(cipher: Cipher) {
        Task {
            let encCipher = try self.encryptCipher(cipher: cipher)
            try await api.updatePassword(encCipher: encCipher)
        }
        if let index = getGlobalIndex(of: cipher) {
            self.data.passwords[index] = cipher
        }
        
        if let index = getFilteredIndex(of: cipher) {
            self.data.currentPasswords[index] = cipher
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
    
    func toggleFavorite(cipher: Cipher) {
        var modCipher = cipher
        modCipher.favorite?.toggle()
        self.updateCipher(cipher: modCipher)
    }
    
}
