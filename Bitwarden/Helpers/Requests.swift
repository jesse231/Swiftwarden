import Foundation


struct Uris : Encodable & Decodable& Hashable{
    var match: Int?
    var Uri: String
    //    func encode(to encoder: Encoder) throws {
    //        var container = encoder.container(keyedBy: CodingKeys.self)
    //        try container.encode(Uri.percentEncoding(), forKey: .Uri)
    //        }
}

struct Login : Encodable & Decodable & Hashable{
    var Uris : [Uris]?
    var Username: String?
    var Password: String?
    var Totp: String?
    var PasswordRevisionDate: String?
    //    func encode(to encoder: Encoder) throws {
    //        var container = encoder.container(keyedBy: CodingKeys.self)
    //        try container.encode(Uris, forKey: .Uris)
    //        try container.encode(Username?.percentEncoding(), forKey: .Username)
    //        try container.encode(Password?.percentEncoding(), forKey: .Password)
    //        }
}
extension String{
    func percentEncoding() -> String{
        return (self)
        //.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)?
        //.replacingOccurrences(of: "+", with: "%2B")
        //.replacingOccurrences(of: "@", with: "%40")
        //.replacingOccurrences(of: "=", with: "%3D"))
    }
    
}
struct Cipher : Encodable & Decodable & Hashable{
    var Id: String?
    var OrganizationId: String?
    var FolderId: String?
    var Name: String?
    var Notes: String?
    var `Type`: Int?
    var Favorite: Bool?
    var ViewPassword: Bool?
    var RevisionDate: String?
    var Login: Login?
    var CollectionIds: [String]?
    var DeletedDate: String?
    var Reprompt: Int?
    var Card: Card?
    
    
    
    //    func encode(to encoder: Encoder) throws {
    //            var container = encoder.container(keyedBy: CodingKeys.self)
    //
    //        try container.encode(OrganizationId?.percentEncoding(), forKey: .OrganizationId)
    //        try container.encode(`Type`, forKey: .`Type`)
    //            try container.encode(Favorite, forKey: .Favorite)
    //            try container.encode(Name, forKey: .Name)
    //            try container.encode(Login, forKey: .Login)
    //            try container.encode(Notes, forKey: .Notes)
    //            try container.encode(FolderId, forKey: .FolderId)
    //        }
}
struct Card : Encodable & Decodable & Hashable{
    var Brand, CardholderName, Code, ExpMonth: String?
    var ExpYear, Number: String?
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

struct Response : Decodable {
    var ContinuationToken: String?
    var Data: [Cipher]?
}

class Api {
    private static var base : String = "https://vaultwarden.seeligsohn.com/"
    private static var bearer: String = ""
    init (username: String, password: String, base: String) async throws{
        let token: Token = try await Api.login(email: username, password: password)
        Api.bearer = token.access_token
        try Encryption(email: username, password: password, encKey: token.Key, iterations: token.KdfIterations)
        Api.base = base + "/"
        print(Api.base)
        
    }
    
    private func getBearer() async throws -> (String, String) {
        let url = URL(string: Api.base + "identity/connect/token")!
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
    
    static func updatePassword(cipher: Cipher) async throws{
        let url = URL(string: Api.base + "/api/ciphers/" + (cipher.Id ?? ""))!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue(Api.bearer, forHTTPHeaderField: "Authorization")
        print(cipher)
        print("--------------------")
        let encCipher = try Encryption.encryptCipher(cipher: cipher)
        request.httpBody = try JSONEncoder().encode(encCipher)
        let (data, response) = try await URLSession.shared.data(for: request)
        print(String(data: data, encoding: .utf8)!)
    }
    
    static func login (email: String, password: String) async throws -> Token {
        var url = URL(string: Api.base + "identity/accounts/prelogin")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        var parameters: [String: Any] = [
            "email": "jesseseeligsohn@gmai.com",
        ]
        
        request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        
        var (data, response) = try await URLSession.shared.data(for: request)
        var responseDict = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Any]
        
        let iterations = responseDict["KdfIterations"]
        
        //        let symKey = Encryption.makeKey(password: password, salt: email.lowercased(), iterations: iterations as! Int)
        let masterPasswordHash = try Encryption.hashedPassword(password: password, salt: email, iterations: iterations as! Int)
        
        url = URL(string: Api.base + "identity/connect/token")!
        
        request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("utf-8", forHTTPHeaderField: "charset")
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: "password"),
            URLQueryItem(name: "username", value: "jesseseeligsohn@gmail.com"),
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
    
    static func sync () async throws {
        let url = URL(string: Api.base + "/api/sync?excludeDomains=true")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue(Api.bearer, forHTTPHeaderField: "Authorization")
        let (data, response) = try await URLSession.shared.data(for: request)
        print("--------------------")
        
        print(String(data: data, encoding: .utf8)!)
        print("--------------------")
    }
    
    
    
    static func getPasswords() async throws -> [Cipher]{
        
        let bearer = Api.bearer
        
        let url = URL(string: Api.base + "api/ciphers")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue(bearer, forHTTPHeaderField: "Authorization")
        
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        let cipher = try JSONDecoder().decode(Response.self, from: data)
        return cipher.Data!
        
    }
    
    static func deletePassword(id: String) async throws -> Bool{
        let bearer = Api.bearer
        let url = URL(string: Api.base + "api/ciphers/" + id + "/delete")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        request.addValue(bearer, forHTTPHeaderField: "Authorization")
        let (data, response) = try await URLSession.shared.data(for: request)
        print(String(data: data, encoding: .utf8)!)
        
        return true
    }
    static func createPassword(cipher: Cipher) async throws -> Bool{
        let bearer = Api.bearer
        let url = URL(string: Api.base + "api/ciphers/")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        request.httpBody = try JSONEncoder().encode(try Encryption.encryptCipher(cipher: cipher))
        
        print(String(bytes: try encoder.encode(try Encryption.encryptCipher(cipher: cipher)), encoding: .utf8))
        request.addValue(bearer, forHTTPHeaderField: "Authorization")
        let (data, response) = try await URLSession.shared.data(for: request)
        print(String(data: data, encoding: .utf8)!)
        
        return true
    }
}

func getIcons(website: String) async throws{
    let url = URL(string: "https://vaultwarden.seeligsohn.com/icons/\(website)/icon.png")!
    //    let (data, response) = try await URLSession.shared.data(from: url)
    //    URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
}
