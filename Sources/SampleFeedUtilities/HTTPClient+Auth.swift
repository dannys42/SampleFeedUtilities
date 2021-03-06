//
//  HTTPClient+Auth.swift
//  Some convenience functions for authenticating to SampleFeed
//
//  Created by Danny Sung on 02/01/2020.
//

import Foundation

// Login Auth Extensions
public extension SampleHTTPClient {
    static let kAuthorizationKey = "Authorization"

    enum LoginFailures: LocalizedError {
        case invalidCredentials
        case unknownLoginFailure
        case noBearerToken
        case userAlreadyExists
        case cannotCreateUser
        
        public var errorDescription: String? {
            switch self {
            case .invalidCredentials: return "Invalid login credentials"
            case .unknownLoginFailure: return "Unknown login failure"
            case .noBearerToken: return "No Bearer token, not logged in"
            case .userAlreadyExists: return "User already exists"
            case .cannotCreateUser: return "Cannot create user"
            }
        }
    }
    
    // MARK: - Sync functions
    func createUser(username: String, password: String, displayName: String) throws {
        let userInfo = [
            "name" : displayName,
            "email" : username,
            "password" : password
        ]
        let (resp,_) = try self.post("/users", userInfo)
        
        if resp.statusCode == 409 {
            throw LoginFailures.userAlreadyExists
        }
        if resp.statusCode != 200 {
            throw LoginFailures.cannotCreateUser
        }
    }
    
    func login(username: String, password: String) throws {
        let reqTokenPlain = "\(username):\(password)"
        let reqTokenBase64 = reqTokenPlain.data(using: .utf8)?.base64EncodedString() ?? ""
        let headers = [
            "Authorization" : "Basic \(reqTokenBase64)"
        ]
        print("auth req header: \(headers)")
        
        let (resp2,body) = try self.post("/login", headers: headers, [:])
        print("auth rsp body: \(body)")

        guard resp2.statusCode != 401 else {
            throw LoginFailures.invalidCredentials
        }
        guard resp2.statusCode == 200 else {
            throw LoginFailures.unknownLoginFailure
        }
        
        guard let authToken = body["string"] as? String else {
            throw LoginFailures.noBearerToken
        }
        guard authToken != "" else {
            throw LoginFailures.noBearerToken
        }

        self.defaultHeaders["Authorization"] = "Bearer \(authToken)"
    }
    
    func logout() throws {
        // TODO: should call server so userToken can be revoked.
        
        self.defaultHeaders.removeValue(forKey: "Authorization")
    }
    
    
    // MARK: - Async functions
    
    /// Asynchronously create a user
    /// - Parameters:
    ///   - username: username to create with
    ///   - password: password of user
    ///   - displayName: Public display name of user
    ///   - completion: completion handler when operation is complete.  Returns user info from server upon success.
    func createUser(username: String, password: String, displayName: String, completion: @escaping (Result<KeyedData,Error>)->Void) {
        
        let userInfo = [
            "name" : displayName,
            "email" : username,
            "password" : password
        ]
        self.post("/users", userInfo) { response in
            switch response {
            case .success(let httpResponse, let keyedData):
                switch httpResponse.statusCode {
                case 409:
                    completion(.failure(LoginFailures.userAlreadyExists))
                case 200: // success
                    completion(.success(keyedData))
                default:
                    completion(.failure(LoginFailures.cannotCreateUser))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    

    func login(username: String, password: String, completion: @escaping (Error?)->Void) {
        let reqTokenPlain = "\(username):\(password)"
        let reqTokenBase64 = reqTokenPlain.data(using: .utf8)?.base64EncodedString() ?? ""
        let headers = [
            "Authorization" : "Basic \(reqTokenBase64)"
        ]
        
        self.post("/login", headers: headers, [:]) { response in
            switch response {
            case .failure(let error):
                completion(error)
            case .success(let httpResponse, let keyedData):
                guard httpResponse.statusCode != 401 else {
                    completion(LoginFailures.invalidCredentials)
                    return
                }
                guard httpResponse.statusCode == 200 else {
                    completion(LoginFailures.unknownLoginFailure)
                    return
                }
                
                guard let authToken = keyedData["string"] as? String else {
                    completion(LoginFailures.noBearerToken)
                    return
                }
                guard authToken != "" else {
                    completion(LoginFailures.noBearerToken)
                    return
                }

                self.defaultHeaders[SampleHTTPClient.kAuthorizationKey] = "Bearer \(authToken)"
                completion(nil)
            }
        }
    }
    
    func logout( completion: ()->Void = { }) {
        // TODO: should call server so userToken can be revoked.
        
        self.defaultHeaders.removeValue(forKey: SampleHTTPClient.kAuthorizationKey)
    }

    var isLoggedIn: Bool {
        if self.defaultHeaders[SampleHTTPClient.kAuthorizationKey] != nil {
            return true
        }
        return false
    }
}
