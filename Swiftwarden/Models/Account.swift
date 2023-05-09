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


class User : ObservableObject{
    private var keys : [String:[UInt8]]
    @Published private var data : AccountData
    
    init(sync : Response){
        var symKeys : [String : [UInt8]] = [:]
        if let organizations = sync.profile?.organizations{
            for org in organizations {
                do {
                    symKeys[org.id!] = try Encryption.decOrg(org: org)
                } catch {
                    
                }
            }
            
        }
        
        self.keys = symKeys
        self.data = AccountData()
        if let ciphers = sync.ciphers {
            let decCiphers = decryptPasswords(dataList: ciphers)
            self.data.passwords = decCiphers
        }
        if let folders = sync.folders {
            var decFolders = Encryption.decryptFolders(dataList: folders)
            decFolders.append(Folder(name: "No Folder", object: "Folder"))
            self.data.folders = decFolders
        }
        }
    
    init (data: AccountData) {
        self.data = data
        self.keys = [:]
    }
    
    private func decryptPasswords(dataList: [Cipher]) -> [Cipher]{
        var decDataList = dataList
        for (i,data) in dataList.enumerated(){
            do {
                decDataList[i] = try decryptCipher(data: data)
            } catch {}
        }
        return decDataList
    }
    
    private func decryptCipher(data: Cipher) throws  -> Cipher {
        var dec = data
        var key : [UInt8]?
        if let id = dec.organizationID {
            key = self.keys[id]
        }
        dec.name = String(bytes: try Encryption.decrypt(decKey: key, str: data.name ?? ""), encoding: .utf8)
         if data.object! == "cipherDetails"{
             if let pass = dec.login?.password {
                 dec.login?.password = String(bytes: try Encryption.decrypt(decKey: key, str: pass), encoding: .utf8)
             }
             if let user = dec.login?.username{
                 dec.login?.username = String(bytes: try Encryption.decrypt(decKey: key, str: user), encoding: .utf8)
             }
             
             if let uris = dec.login?.uris {
                 for (i,uri) in uris.enumerated() {
                     dec.login?.uris?[i].uri = String(bytes: try Encryption.decrypt(decKey: key, str: uri.uri!), encoding: .utf8) ?? uri.uri
                 }
             }
             if let card = dec.card {
                 dec.card?.brand = String(bytes: try Encryption.decrypt(str: card.brand ??  ""), encoding: .utf8) ?? card.brand
                 dec.card?.cardholderName = String(bytes: try Encryption.decrypt(str: card.cardholderName ??  ""), encoding: .utf8) ?? card.cardholderName
                 dec.card?.code = String(bytes: try Encryption.decrypt(str: card.code ??  ""), encoding: .utf8) ?? card.code
                 dec.card?.expMonth = String(bytes: try Encryption.decrypt(str: card.expMonth ??  ""), encoding: .utf8) ?? card.expMonth
                 dec.card?.expYear = String(bytes: try Encryption.decrypt(str: card.expYear ?? ""), encoding: .utf8) ?? card.expYear
                 dec.card?.number = String(bytes: try Encryption.decrypt(str: card.number ?? ""), encoding: .utf8) ?? card.number
                 
             }
         }
         
        return dec
    }
    
    func getCiphers(deleted : Bool = false) -> [Cipher] {
        if deleted{
            return self.data.passwords
        } else {
            return self.data.passwords.filter({$0.deletedDate == nil})
        }
    }
    
    func getCards() -> [Cipher] {
        return self.data.passwords.filter({$0.card != nil})
    }
    
    func getTrash() -> [Cipher] {
        return self.data.passwords.filter({$0.deletedDate != nil})
    }
    
    func getFavorites() -> [Cipher] {
        return self.data.passwords.filter({$0.favorite != false})
    }
    
    func getFolders() -> [Folder] {
        return self.data.folders
    }
    
    func deleteCipher(cipher: Cipher, api: Api) async throws {
        if let index = self.data.passwords.firstIndex(of: cipher) {
            self.data.passwords.remove(at: index)
            
            // Call the Api.deletePassword() method on a different thread asynchronously
            try await Task.detached {
                do {
                    try await api.deletePassword(id: cipher.id!)
                    // Update the passwords field on the main thread
                    DispatchQueue.main.async {
                        self.objectWillChange.send()
                    }
                } catch {
                    print(error)
                }
            }
        }
    }
    
    func addCipher(cipher: Cipher, api: Api) async throws {
        
        self.data.passwords.append(cipher)
        
        try await Task.detached { {
            do {
                try await api.createPassword(cipher: cipher)
                
                DispatchQueue.main.async {
                    self.objectWillChange.send()
                }
            } catch {
                print(error)
            }
        }
            
        }
    }
    
    
    
    
}
