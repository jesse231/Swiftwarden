import Foundation
import CryptoSwift

class Encryption {
    static private var symcKey: [UInt8] = []
    static private var key: [UInt8] = []
    static var privateKey: SecKey?
    static private var iterations: Int = 0

    init(email: String, password: String, encKey: String, iterations: Int) throws {
        Encryption.iterations = iterations
        Encryption.symcKey = Encryption.makeKey(password: password, salt: email.lowercased(), iterations: Encryption.iterations)
        Encryption.key = try Encryption.decrypt(encKey: Encryption.symcKey, str: encKey)
    }

    static func hashedPassword(password: String, salt: String, iterations: Int) throws -> String {
        let key = makeKey(password: password, salt: salt, iterations: iterations)
        return try PKCS5.PBKDF2(password: key, salt: Array(password.utf8), iterations: 1, keyLength: 32, variant: .sha2(.sha256)).calculate().toBase64()
    }

    static func makeKey(password: String, salt: String, iterations: Int) -> [UInt8] {
        do {
            let password: [UInt8] = Array(password.utf8)
            let salt: [UInt8] = Array(salt.utf8)
            let key = try PKCS5.PBKDF2(password: password, salt: salt, iterations: iterations, keyLength: 32, variant: .sha2(.sha256)).calculate()
            return key
        } catch {}
        return []
    }

    static private func cipherString(mac: [UInt8]? = [], encType: Int, iv: [UInt8], ct: [UInt8]) -> String {
        if (mac!.isEmpty) == true {
            return String(encType) + "." + iv.toBase64() + "|" +  ct.toBase64()
        }
        return String(encType) + "." + iv.toBase64() + "|" +  ct.toBase64() + "|" + mac!.toBase64()
    }

    func makeEncKey(key: [UInt8]) -> String {
        var pt = [UInt8](repeating: 0, count: 64)
        SecRandomCopyBytes(kSecRandomDefault, 64, &pt)
        var iv = [UInt8](repeating: 0, count: 16)
        SecRandomCopyBytes(kSecRandomDefault, 16, &iv)
        do {
            let aes = try AES(key: key, blockMode: CBC(iv: iv))
            let ct = try aes.encrypt(pt)
            return Encryption.cipherString(encType: 0, iv: iv, ct: ct)
        } catch {
            print("Error creating encryption key: \(error).")
            return ""
        }
    }

    private static func macsEqual(macKey: [UInt8], mac1: [UInt8], mac2: [UInt8]) -> Bool {
        do {
            let hmac1 = try HMAC(key: macKey, variant: .sha2(.sha256)).authenticate(mac1)
            let hmac2 = try HMAC(key: macKey, variant: .sha2(.sha256)).authenticate(mac2)
            return hmac1 == hmac2
        } catch {return false}

    }

    static func decrypt(decKey: [UInt8]? = nil, encKey: [UInt8]? = nil, str: String) throws -> [UInt8] {
        // Break the encKey into the private key and mac digest
        var key: [UInt8]
        var macKey: [UInt8] = []

        if let encKey {
            key = Array(encKey.prefix(32))
            macKey = Array(encKey.suffix(32))
        } else if let decKey {
            key = decKey
        } else {
            key = Encryption.key
        }

        // Break the encrypted string into it's iv and data components
        let split = str.components(separatedBy: "|")
        if split.count == 1 {
            return []
        }

        let iv = (Data(base64Encoded: String(split[0].dropFirst(2)))?.bytes)
        let ct = (Data(base64Encoded: split[1])?.bytes)
        let mac2 = (Data(base64Encoded: split[2])?.bytes)
        if split[0].prefix(1) == "2"{
            if key.count == 32 {
                macKey = hkdfStretch(prk: key, info: "mac", size: 32)
                key = hkdfStretch(prk: key, info: "enc", size: 32)
            } else if key.count == 64 {
                macKey = Array(key.suffix(32))
                key = Array(key.prefix(32))
            }
        }
        do {
            let mac1 = try HMAC(key: macKey, variant: .sha2(.sha256)).authenticate((iv ?? []) + (ct ?? []))
            if !Encryption.macsEqual(macKey: macKey, mac1: mac1, mac2: mac2 ?? []) {
                return []
            }

            let aes = try AES(key: key, blockMode: CBC(iv: iv ?? []))
            let pt = try aes.decrypt(ct ?? [])

            return pt
        } catch {
            print("Error decrypting: \(error).")
            return []
        }
    }

    static func encrypt(encKey: [UInt8]? = nil, str: String) throws -> String {
        var key: [UInt8]
        var macKey: [UInt8] = []

        if encKey == nil {
            key = Encryption.key
        } else {
            key = encKey!
        }

        if key.count == 32 {
            macKey = hkdfStretch(prk: key, info: "mac", size: 32)
            key = hkdfStretch(prk: key, info: "enc", size: 32)
        } else if key.count == 64 {
            macKey = Array(key.suffix(32))
            key = Array(key.prefix(32))
        } else {
            print("Error with key")
        }

        let iv = AES.randomIV(16)
        let aes = try AES(key: key, blockMode: CBC(iv: iv))
        let ct = try aes.encrypt(str.bytes)

        var mac: [UInt8]

        mac = try HMAC(key: macKey, variant: .sha256).authenticate(iv + ct)

        return cipherString(mac: mac, encType: 2, iv: iv, ct: ct)
    }

   private static func hkdfStretch(prk: [UInt8], info: String, size: Int) -> [UInt8] {
        let hashlen = 32
        var prev: [UInt8] = []
        var okm: [UInt8] = []
        let n: Int = Int(ceil(Double((size / hashlen))))
        let inf = Data(info.utf8)
        for i in 0..<n {
            var t: [UInt8] = []
            t += prev
            t += inf
            t += [UInt8(i+1)]
            do {
                let hmac = try HMAC(key: prk, variant: .sha256).authenticate(t)
                okm += hmac
                prev = hmac
            } catch {}

            if okm.count != size {
                print("Error")
            }
        }
        return okm
    }

    static func encryptCipher(cipher: Cipher) throws -> Cipher {
        var enc = cipher
        enc.name = try Encryption.encrypt(str: cipher.name ?? "")
        if let pass = enc.login?.password {
            enc.login?.password = try encrypt(str: pass)
        }
        if let user = enc.login?.username {
            enc.login?.username = try encrypt(str: user)
        }

        if let uri = enc.login?.uri {
            enc.login?.uri = try encrypt(str: uri)
        }

        if let uris = enc.login?.uris {
            for (i, uri) in uris.enumerated() {
                if let uri = uri.uri {
                    enc.login?.uris?[i].uri = try encrypt(str: uri)
                }
            }
        }
        if let fields = enc.fields {
            for (i, field) in fields.enumerated() {
                enc.fields?[i].name = try encrypt(str: field.name ?? "")
                if let value = enc.fields?[i].value {
                    enc.fields?[i].value = try encrypt(str: value)
                }
            }
        }
        if let notes = enc.notes {
            enc.notes = try encrypt(str: notes)
        }
        
        return enc
    }

    static func decryptCipher(data: Cipher) throws -> Cipher {
        var dec = data
         dec.name = String(bytes: try decrypt(str: data.name ?? ""), encoding: .utf8)
        if let object = data.object, object == "cipherDetails"{
             if let pass = dec.login?.password {
                 dec.login?.password = String(bytes: try decrypt(str: pass), encoding: .utf8)
             }
             if let user = dec.login?.username {
                 dec.login?.username = String(bytes: try decrypt(str: user), encoding: .utf8)
             }

             if let uris = dec.login?.uris {
                 for (i, uri) in uris.enumerated() {
                     if let uri = uri.uri {
                         dec.login?.uris?[i].uri = String(bytes: try decrypt(str: uri), encoding: .utf8) ?? uri
                     }
                 }
             }
             if let card = dec.card {
                 if let brand = dec.card?.brand {
                     dec.card?.brand = String(bytes: try decrypt(str: brand), encoding: .utf8)
                 }
                 if let cardHolderName = dec.card?.cardHolderName {
                     dec.card?.cardHolderName = String(bytes: try decrypt(str: cardHolderName), encoding: .utf8)
                 }
                 if let code = dec.card?.code {
                     dec.card?.code = String(bytes: try decrypt(str: code), encoding: .utf8) ?? code
                 }
                 if let expMonth = dec.card?.expMonth {
                     dec.card?.expMonth = String(bytes: try decrypt(str: expMonth), encoding: .utf8)
                 }
                 if let expYear = dec.card?.expYear {
                     dec.card?.expYear = String(bytes: try decrypt(str: expYear), encoding: .utf8)
                 }
                 dec.card?.number = String(bytes: try decrypt(str: card.number ?? ""), encoding: .utf8) ?? card.number

             }
         }
        return dec
    }

    static func decryptFolder(data: Folder) throws -> Folder {
       var dec = data
       dec.name = String(bytes: try decrypt(str: data.name), encoding: .utf8)!
       return dec
   }

    static func decryptPasswords(dataList: [Cipher]) -> [Cipher] {
        var decDataList = dataList
        for (i, data) in dataList.enumerated() {
            do {
                decDataList[i] = try decryptCipher(data: data)
            } catch {}
        }
        return decDataList
    }

    static func decryptFolders(dataList: [Folder]) -> [Folder] {
        var decDataList = dataList
        for (i, data) in dataList.enumerated() {
            do {
                decDataList[i] = try decryptFolder(data: data)
            } catch {}
        }
        return decDataList
    }

    static func decOrg(org: Organization) throws -> [UInt8] {
        var decOrg = org
        let key = String(org.key!.split(separator: ".")[1])
        let dk = SecKeyCreateDecryptedData(Encryption.privateKey!, .rsaEncryptionOAEPSHA1, Data(base64Encoded: key)! as CFData, nil) as? Data
        return dk!.bytes
   }

//    static func decryptOrganizations(orgs: [Organization]) -> [Organization]{
//        var decOrgs = orgs
//        for (i,data) in orgs.enumerated(){
//            do {
//                decOrgs[i] = try decOrg(org: data)
//            } catch {}
//        }
//        return decOrgs
//    }
}
