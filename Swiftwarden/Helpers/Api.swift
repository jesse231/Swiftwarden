import Foundation


extension String{
    func removePercentEncoding() -> String{
        return (self)
            .replacingOccurrences(of: "%2B", with: "+")
            .replacingOccurrences(of: "%40", with: "@")
            .replacingOccurrences(of: "%3D", with: "=")
    }
    
}


struct Token: Decodable {
    var Kdf: Int
    var KdfIterations: Int
    var Key: String
    var PrivateKey: String
    var ResetMasterPassword: Bool
    var access_token: String
    var expires_in: Int
    var token_type: String
    var unofficialServer: Bool
}


class Api {
    private var base : String?
    private var bearer: String = ""
    
    
    private var apiPath = "https://api.bitwarden.com"
    private var identityPath = "https://identity.bitwarden.com"
    private var iconPath = "https://icons.bitwarden.com"
    
    init (username: String, password: String, base: String?, identityPath: String?, apiPath: String? , iconPath: String?) async throws{
        if let base {
            self.base = base + "/"
        }
        
        if let identityPath {
            self.identityPath = identityPath
        } else if let base {
            self.identityPath = base + "identity/"
        }
        
        if let apiPath {
            self.apiPath = apiPath
        } else if let base {
            self.apiPath = base + "api/"
        }
        
        if let iconPath {
            self.iconPath = iconPath
        } else if let base {
            self.iconPath = base + "icons/"
        }
        
        let token: Token = try await self.login(email: username, password: password)
        self.bearer = token.access_token

        
        
        
        try Encryption(email: username, password: password, encKey: token.Key, iterations: token.KdfIterations)
        
        
    }
    
    init () {
        
    }
    
    
    
    private func getBearer() async throws -> (String, String) {
        let url = URL(string: self.identityPath + "connect/token")!
        //    let url = URL(string: "https://google.com")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: "client_credentials"),
            URLQueryItem(name: "scope", value: "api"),
            URLQueryItem(name: "client_id", value: "user.e4105a82-b785-4641-96a9-ae925c333e16"),
            URLQueryItem(name: "client_secret", value: "HUgPPosgrUuwZgS0Qxevjpj8Y819vu"),
            URLQueryItem(name: "device_identifier", value: "test"),
            URLQueryItem(name: "device_name", value: "Jesse"),
        ]
        
        let query = components.url!.query
        request.httpBody = Data(query!.utf8)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        let token = try JSONDecoder().decode(Token.self, from: data)
        
        return (token.access_token, token.Key)
    }
    
    func updatePassword(cipher: Cipher) async throws{
        let url = URL(string: self.apiPath + "/ciphers/" + (cipher.id ?? ""))!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue(self.bearer, forHTTPHeaderField: "Authorization")
        let encCipher = try Encryption.encryptCipher(cipher: cipher)
        request.httpBody = try JSONEncoder().encode(encCipher)
        let (data, response) = try await URLSession.shared.data(for: request)
    }
    
    private func login (email: String, password: String) async throws -> Token {
        var url = URL(string: self.identityPath + "/accounts/prelogin")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        var parameters: [String: Any] = [
            "email": email,
        ]
        
        request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        
        var (data, response) = try await URLSession.shared.data(for: request)
        
        var responseDict = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Any]
        
        let iterations = responseDict["KdfIterations"]
        
        //        let symKey = Encryption.makeKey(password: password, salt: email.lowercased(), iterations: iterations as! Int)
        let masterPasswordHash = try Encryption.hashedPassword(password: password, salt: email, iterations: iterations as! Int)
        
        url = URL(string: self.identityPath + "/connect/token")!
        
        request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("utf-8", forHTTPHeaderField: "charset")
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: "password"),
            URLQueryItem(name: "username", value: email),
            URLQueryItem(name: "password", value: masterPasswordHash),
            URLQueryItem(name: "scope", value: "api offline_access"),
            URLQueryItem(name: "client_id", value: "browser"),
            URLQueryItem(name: "device_type", value: "3"),
            URLQueryItem(name: "device_identifier", value: "aac2e34a-44db-42ab-a733-5322dd582c3d"),
            URLQueryItem(name: "device_name", value: "firefox"),
        ].percentEncoded()
        
        let query = components.url!.query?.removingPercentEncoding
        request.httpBody = Data(query!.utf8)
        (data, response) = try await URLSession.shared.data(for: request)
        
        let token = try JSONDecoder().decode(Token.self, from: data)
        return token
        
        
        
    }
    
    func sync () async throws -> Response {
        let url = URL(string: self.apiPath + "sync?excludeDomains=false")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue(self.bearer, forHTTPHeaderField: "Authorization")
        let (data, response) = try await URLSession.shared.data(for: request)
        let syncData = try Response(data: data)
//        print(syncData)
        return syncData
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
    
    func deletePassword(id: String) async throws{
        let bearer = self.bearer
        let url = URL(string: self.apiPath + "ciphers/" + id + "/delete")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        request.addValue(bearer, forHTTPHeaderField: "Authorization")
        let (data, response) = try await URLSession.shared.data(for: request)
        print(String(data: data, encoding: .utf8)!)
        print("api/ciphers/" + id + "/delete")
    }
    
    
    func createPassword(cipher: Cipher) async throws{
        let bearer = self.bearer
        let url = URL(string: self.apiPath + "ciphers/")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        request.httpBody = try JSONEncoder().encode(try Encryption.encryptCipher(cipher: cipher))
        
        print(String(bytes: try encoder.encode(try Encryption.encryptCipher(cipher: cipher)), encoding: .utf8))
        request.addValue(bearer, forHTTPHeaderField: "Authorization")
        let (data, response) = try await URLSession.shared.data(for: request)
        print(String(data: data, encoding: .utf8)!)
    }
    
    func getIcons(host: String) -> URL{
        let url = URL(string: self.iconPath + "\(host)/icon.png")!
        
        return url
        //    let (data, response) = try await URLSession.shared.data(from: url)
        //    URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    

}


