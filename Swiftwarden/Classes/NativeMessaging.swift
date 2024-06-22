//
//  NativeMessaging.swift
//  Swiftwarden
//
//  Created by Jesse Seeligsohn on 2024-06-11.
//
import Foundation
import Darwin
import CryptoSwift
import LocalAuthentication

// MARK: Chrome Part
func getInt(_ bytes: [UInt8]) -> UInt {
    let lt = (UInt(bytes[3]) << 24) & 0xff000000
    let ls = (UInt(bytes[2]) << 16) & 0x00ff0000
    let lf = (UInt(bytes[1]) << 8) & 0x0000ff00
    let lz = (UInt(bytes[0]) << 0) & 0x000000ff
    return lt | ls | lf | lz
}

class NativeMessenger {
    let context = LAContext()
    private var secret = [UInt8](repeating: 0, count: 64)
    private var sharedKey: SecKey?
    private var appId: String?
    
    func generateSecure(publicKey: String, appId: String) {
        var sec = [UInt8](repeating: 0, count: 64)
        let status = SecRandomCopyBytes(kSecRandomDefault, 64, &sec)
        if status != errSecSuccess {
            print("Error generating random bytes: \(status)")
        }
        self.appId = appId
        self.secret = sec
        let secretData = Data(secret)
        let publicKeyData = Data(base64Encoded: publicKey)!
        let keyDict: [CFString: Any] = [
            kSecAttrKeyType: kSecAttrKeyTypeRSA,
            kSecAttrKeyClass: kSecAttrKeyClassPublic,
            kSecAttrKeySizeInBits: 2048, // Adjust according to your key size
        ]
        let publicKey = SecKeyCreateWithData(publicKeyData as CFData, keyDict as CFDictionary, nil)

        let cipherText = try SecKeyCreateEncryptedData(publicKey!, .rsaEncryptionOAEPSHA1, secretData as CFData, nil) as Data?
        
        let cipherTextB64 = cipherText!.base64EncodedString()

        let message = ["appId": appId,
                       "command": "setupEncryption",
                       "sharedSecret": cipherTextB64]
        sendMessage(message)
    }
    func decryptEncryptedMessage(message: [String: Any]) -> [String: Any] {

        let encryptedString = message["encryptedString"] as! String
        do {
            let decData = try Encryption.decrypt(decKey: secret, str: encryptedString)
            let decString = String(bytes: decData, encoding: .utf8)
            fputs("\n Decrypted: \(String(describing: decString)) \n", stderr)
            let data = decString?.data(using: .utf8)
            let json = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
            return json
        } catch {
            fputs("Error decrypting: \(error)", stderr)
        }
        return [:]
    }
    
    func chromeWriteEncrypted(_ message: [String: Any]) {
        let messageJson = try! JSONSerialization.data(withJSONObject: message, options: [])
        let encString = try! Encryption.encrypt(encKey: secret, str: String(data: messageJson, encoding: .utf8)!)
        let split = encString.components(separatedBy: "|")
        let message: [String: Any] = [
            "data": split[1],
            "encryptedString": encString,
            "encryptionType": Int(split[0].prefix(1))!,
            "iv": split[0].dropFirst(2),
            "mac": split[2]
            ]
        let messagePacket = [
            "appId": appId,
            "message": message
        ] as [String : Any]
        sendMessage(messagePacket)
    }
    
    func handleBiometricUnlock() {
        if let privateKey = Encryption.getEncKey() {
            let message: [String: Any] = ["command": "biometricUnlock",
                           "response": "unlocked",
                           "userKeyB64": privateKey
            ]
            self.chromeWriteEncrypted(message)
        }
    }
    
    
    func listen() {
        print("Listening")
        let response = ["command": "connected"]
        sendMessage(response)
        while true {
            if let messagePacket = getMessage() {
                print("message gotten")
                fputs("\n Received: \(messagePacket)\n", stderr)
                if var message = messagePacket["message"] as? [String: Any] {
                    // Handle Encrypted Messages
                    if (message["encryptedString"] as? String) != nil {
                        message = self.decryptEncryptedMessage(message: message)
                    }
                    switch (message["command"] as? String) {
                        case "setupEncryption":
                            setUpEncryption(message: messagePacket)
                        case "biometricUnlock":
                            handleBiometricUnlock()
                            self.chromeWriteEncrypted(message)
                        default:
                            break
                    }
                } else {
                    fputs("\n Invalid message format\n", stderr)
                }
            }
        }
    }
    
    func setUpEncryption(message: [String: Any]) {
         guard let messageDict = message["message"] as? [String: Any] else {
            print("Invalid message format")
            return
        }
        guard let publicKey = messageDict["publicKey"] as? String,
              let appId = message["appId"] as? String else {
            print("Invalid message content")
            return
        }
        self.generateSecure(publicKey: publicKey, appId: appId)
    }
    
    func getMessage() -> [String: Any]? {
        let stdIn = FileHandle.standardInput
        var bytes = [UInt8](repeating: 0, count: 4)
        guard read(stdIn.fileDescriptor, &bytes, 4) != 0 else {
            return nil
        }
        
        let len = getInt(bytes)//Data(bytes).withUnsafeBytes { $0.load(as: UInt32.self) }
        let data = stdIn.readData(ofLength: Int(len))
        let message = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
        return message
    }
    
    func sendMessage(_ message: [String:Any]) {
        let stdOut = FileHandle.standardOutput
        
        let json: [String: Any] = message
        guard let jsonData = try? JSONSerialization.data(withJSONObject: json, options: []) else {
            return
        }
        
         let len = getIntBytes(for: jsonData.count)
        stdOut.write(Data(bytes: len, count: 4))
        stdOut.write(jsonData)
    }

    
}


 func getIntBytes(for length: Int) -> [UInt8] {
     var bytes = [UInt8](repeating: 0, count: 4)
     bytes[0] = UInt8((length & 0xFF))
     bytes[1] = UInt8(((length >> 8) & 0xFF))
     bytes[2] = UInt8(((length >> 16) & 0xFF))
     bytes[3] = UInt8(((length >> 24) & 0xFF))
     return bytes
 }
//func getIntBytes(for length: Int) -> [UInt8] {
//    let length32 = UInt32(length)
//    var data = Data()
//    withUnsafeBytes(of: length32.bigEndian) { data.append(contentsOf: $0) }
//    return [UInt8](data)
//}
