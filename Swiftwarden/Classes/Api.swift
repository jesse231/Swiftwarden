import Foundation

extension String {
    func removePercentEncoding() -> String {
        return (self)
            .replacingOccurrences(of: "%2B", with: "+")
            .replacingOccurrences(of: "%40", with: "@")
            .replacingOccurrences(of: "%3D", with: "=")
    }

}

struct AuthError: Error {
    let message: String
}

struct ErrorResponse: Decodable {
    let error: String?
    let errorDescription: String?
    let message: String?
}

struct Token: Codable & Hashable {
    var kdf: Int
    var kdfIterations: Int
    var key: String
    var privateKey: String
    var resetMasterPassword: Bool
    var accessToken: String
    var expiresIn: Int
    var tokenType: String
    var unofficialServer: Bool?
    enum CodingKeys: String, CodingKey {
        case kdf = "Kdf"
        case kdfIterations = "KdfIterations"
        case key = "Key"
        case privateKey = "PrivateKey"
        case resetMasterPassword = "ResetMasterPassword"
        case accessToken = "access_token"
        case expiresIn = "expires_in"
        case tokenType = "token_type"
        case unofficialServer
    }
}

class Api {
    private var bearer: String = ""
    private var email = ""

    private var base = URL(string: "https://bitwarden.com/")!
    private var apiPath = URL(string: "https://api.bitwarden.com/")!
    private var identityPath =  URL(string: "https://identity.bitwarden.com/")!
    private var iconPath = URL(string: "https://icons.bitwarden.net/")!

init (username: String, password: String, base: URL?, identityPath: URL?, apiPath: URL?, iconPath: URL?) async throws {

        if let identityPath {
            self.identityPath = identityPath
        } else if let base {
            self.identityPath = base.appendingPathComponent("identity/")
        }

        if let apiPath {
            self.apiPath = apiPath
        } else if let base {
            self.apiPath = base.appendingPathComponent("api/")
        }

        if let iconPath {
            self.iconPath = iconPath
        } else if let base {
            self.iconPath = base.appendingPathComponent("icons/")
        }

        let token: Token = try await self.login(email: username, password: password)
        self.email = username
        self.bearer = token.accessToken

        try Encryption(email: username, password: password, encKey: token.key, iterations: token.kdfIterations)
        
    
    }

    init () {

    }

//    private func getBearer() async throws -> (String, String) {
//        let url = URL(string: self.identityPath + "connect/token")!
//        //    let url = URL(string: "https://google.com")!
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
//
//        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)!
//
//        components.queryItems = [
//            URLQueryItem(name: "grant_type", value: "client_credentials"),
//            URLQueryItem(name: "scope", value: "api"),
//            URLQueryItem(name: "client_id", value: "user.e4105a82-b785-4641-96a9-ae925c333e16"),
//            URLQueryItem(name: "client_secret", value: "HUgPPosgrUuwZgS0Qxevjpj8Y819vu"),
//            URLQueryItem(name: "device_identifier", value: "test"),
//            URLQueryItem(name: "device_name", value: "Jesse"),
//        ]
//
//        let query = components.url!.query
//        request.httpBody = Data(query!.utf8)
//
//        let (data, response) = try await URLSession.shared.data(for: request)
//        let token = try JSONDecoder().decode(Token.self, from: data)
//
//        return (token.access_token, token.Key)
//    }
//
    func updatePassword(cipher: Cipher) async throws {
        let url = self.apiPath.appendingPathComponent("ciphers/" + cipher.id!)
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("Bearer " + self.bearer, forHTTPHeaderField: "Authorization")
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue(String(Data(email.utf8).base64EncodedString().dropLast(2)), forHTTPHeaderField: "Auth-Email")

        let encCipher = try Encryption.encryptCipher(cipher: cipher)
        request.httpBody = try JSONEncoder().encode(encCipher)
        let (data, response) = try await URLSession.shared.data(for: request)
        print(response)
        print(String(data: data, encoding: .utf8)!)
    }

    private func login (email: String, password: String) async throws -> Token {
        var url = self.identityPath.appendingPathComponent("accounts/prelogin/")
        var request = URLRequest(url: url)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"

        let parameters: [String: Any] = [
            "email": email
        ]

        request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)

        var (data, response) = try await URLSession.shared.data(for: request)

//        print(String(data: data, encoding: .utf8))
        if let httpResponse = response as? HTTPURLResponse {
            if httpResponse.statusCode != 200 {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let error = try decoder.decode(ErrorResponse.self, from: data)
                if let message = error.message {
                    throw AuthError(message: message)
                }
            }
        }
        let preLogin = try PreLogin(data: data)

        let iterations = preLogin.kdfIterations

        let masterPasswordHash = try Encryption.hashedPassword(password: password, salt: email, iterations: iterations!)

        url = self.identityPath.appendingPathComponent("connect/token")
        request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
//        request.setValue("7", forHTTPHeaderField: "Device-Type")
//        request.setValue("application/json", forHTTPHeaderField: "Accept")
//        request.setValue("Bitwarden_CLI/2023.1.0 (MACOS)", forHTTPHeaderField: "User-Agent")
        request.setValue(String(Data(email.utf8).base64EncodedString().dropLast(2)), forHTTPHeaderField: "Auth-Email")
//        print(String(Data(email.utf8).base64EncodedString().dropLast(2)))
//        request.setValue("utf-8", forHTTPHeaderField: "charset")
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "scope", value: "api offline_access"),
            URLQueryItem(name: "client_id", value: "cli"),
            URLQueryItem(name: "deviceType", value: "7"),
            URLQueryItem(name: "deviceIdentifier", value: "b3e4aa90-7020-4c50-8b65-5730e9f3ff3e"),
            URLQueryItem(name: "deviceName", value: "macos"),
            URLQueryItem(name: "grant_type", value: "password"),
            URLQueryItem(name: "username", value: email),
            URLQueryItem(name: "password", value: masterPasswordHash)
        ].percentEncoded()
        components.scheme = "https"
//        print(components.query)
//        print(components.url!.query?.removePercentEncoding())
//        print(email.removePercentEncoding())
//        print(password.percentencoding()
        let query = components.query
//        print(query)
        request.httpBody = Data(query!.utf8)
        (data, response) = try await URLSession.shared.data(for: request)
        if let httpResponse = response as? HTTPURLResponse {
            if httpResponse.statusCode != 200 {
//                let decoder = try JSONDecoder()
//                try decoder.keyDecodingStrategy = .convertFromSnakeCase
//                let error = try decoder.decode(ErrorResponse.self, from: data)
                print(response)
                print(String(data: data, encoding: .utf8)!)
                throw AuthError(message: "Invalid email or password")
            }
        }
        let token = try JSONDecoder().decode(Token.self, from: data)
        return token

    }

    func sync() async throws -> Response {

        let url = self.apiPath
            .appendingPathComponent("sync")
            .appending(queryItems: [URLQueryItem(name: "excludeDomains", value: "false")])
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer " + self.bearer, forHTTPHeaderField: "Authorization")

        let (data, response) = try await URLSession.shared.data(for: request)
        print(response)
        print(String(data: data, encoding: .utf8)!)
        let syncData = try Response(data: data)
        print(syncData)
        return syncData
    }
    
    func restoreCipher(id cipherID: String) async throws {
        let bearer = self.bearer
        let url = self.apiPath.appendingPathComponent("ciphers/" + cipherID + "/restore/")
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("Bearer " + bearer, forHTTPHeaderField: "Authorization")
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue(String(Data(email.utf8).base64EncodedString().dropLast(2)), forHTTPHeaderField: "Auth-Email")
        let (data, response) = try await URLSession.shared.data(for: request)
    }

//    static func getPasswords() async throws -> [Cipher]{
//
//        let bearer = self.bearer
//
//        let url = URL(string: self.base + "api/ciphers")!
//        var request = URLRequest(url: url)
//        request.httpMethod = "GET"
//        request.addValue(bearer, forHTTPHeaderField: "Authorization")
//
//
//        let (data, response) = try await URLSession.shared.data(for: request)
//
//        let cipher = try JSONDecoder().decode(Response.self, from: data)
//        return cipher.data!
//
//    }

    func deletePassword(id: String) async throws {
        let url = self.apiPath.appendingPathComponent("ciphers/" + id + "/delete/")

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("Bearer " + self.bearer, forHTTPHeaderField: "Authorization")
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue(String(Data(email.utf8).base64EncodedString().dropLast(2)), forHTTPHeaderField: "Auth-Email")

        let (data, response) = try await URLSession.shared.data(for: request)
        print(String(data: data, encoding: .utf8)!)
    }

    func deletePasswordPermanently(id: String) async throws {
        let bearer = self.bearer
        let url = self.apiPath.appendingPathComponent("ciphers/" + id)

        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.addValue("Bearer " + self.bearer, forHTTPHeaderField: "Authorization")
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue(String(Data(email.utf8).base64EncodedString().dropLast(2)), forHTTPHeaderField: "Auth-Email")

        let (data, response) = try await URLSession.shared.data(for: request)
        print(String(data: data, encoding: .utf8)!)
        print(response)
        return
    }

    func createPassword(cipher: Cipher) async throws -> Cipher {
        let url = self.apiPath.appendingPathComponent("ciphers/")

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        request.httpBody = try JSONEncoder().encode(try Encryption.encryptCipher(cipher: cipher))

       // print(String(bytes: try encoder.encode(try Encryption.encryptCipher(cipher: cipher)), encoding: .utf8))
        request.addValue("Bearer " + self.bearer, forHTTPHeaderField: "Authorization")
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue(String(Data(email.utf8).base64EncodedString().dropLast(2)), forHTTPHeaderField: "Auth-Email")
        let (data, response) = try await URLSession.shared.data(for: request)
        print(response)
        print(String(data: data, encoding: .utf8)!)

        if let httpResponse = response as? HTTPURLResponse {
            if httpResponse.statusCode != 200 {
                print(httpResponse.statusCode)
                print(String(data: data, encoding: .utf8)!)
            }
        }

        return try Encryption.decryptCipher(data: Cipher(data: data))
    }

    func getIcons(host: String) -> URL? {
        if host != "" {
            return self.iconPath.appendingPathComponent("\(host)/icon.png")
        } else {
            return nil
        }
    }
    
    func createFolder(name: String) async throws -> Folder {
        let url = apiPath.appendingPathComponent("folders/")
        print(url)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        request.addValue("Bearer " + self.bearer, forHTTPHeaderField: "Authorization")
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue(String(Data(email.utf8).base64EncodedString().dropLast(2)), forHTTPHeaderField: "Auth-Email")
        
        
        
        let requestBody = [
            "name": name,
        ]
        
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: requestBody)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        print(response)
        
        print(String(data: data, encoding: .utf8))
        
        let folder = try Folder(data: data)
        print(folder)
        
        return try Encryption.decryptFolder(data: folder) 
        
        
        
        
    }
    
    func deleteFolder(id: String) async throws {
        let url = apiPath.appendingPathComponent("folders/" + id)
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        request.addValue("Bearer " + self.bearer, forHTTPHeaderField: "Authorization")
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue(String(Data(email.utf8).base64EncodedString().dropLast(2)), forHTTPHeaderField: "Auth-Email")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        print(response)
        print(String(data: data, encoding: .utf8))
    }

}
