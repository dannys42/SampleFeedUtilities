//
//  HTTPClient+Methods.swift
//  
//
//  Created by Danny Sung on 02/01/2020.
//

import Foundation

// MARK: - Synchronous Methods
public extension SampleHTTPClient {
    func get(_ endPoint: String, headers: HttpHeaders=[:]) throws -> (HTTPURLResponse, [String:Any]) {
        let url = self.baseUrl.appendingPathComponent(endPoint)
        
        return try self.sync(method: .get,
                                url: url,
                            headers: headers,
                               body: nil,
                            timeout: self.defaultTimeout)
        }
    func delete(_ endPoint: String, headers: HttpHeaders=[:]) throws -> (HTTPURLResponse, [String:Any]) {
        let url = self.baseUrl.appendingPathComponent(endPoint)
        
        return try self.sync(method: .delete,
                                url: url,
                            headers: headers,
                               body: nil,
                            timeout: self.defaultTimeout)
        }
    func put(_ endPoint: String, headers: HttpHeaders=[:],
             _ dict: [String:Any]) throws -> (HTTPURLResponse, [String:Any]) {
        let url = self.baseUrl.appendingPathComponent(endPoint)
        
        return try self.sync(method: .put,
                                url: url,
                            headers: headers,
                               body: dict,
                            timeout: self.defaultTimeout)
        }
    func post(_ endPoint: String, headers: HttpHeaders=[:],
              _ dict: [String:Any]) throws -> (HTTPURLResponse, [String:Any]) {
        let url = self.baseUrl.appendingPathComponent(endPoint)
        
        return try self.sync(method: .post,
                                url: url,
                            headers: headers,
                               body: dict,
                            timeout: self.defaultTimeout)
        }
}

// MARK: - Asynchronous Raw Methods
public extension SampleHTTPClient {
    func getRaw(_ endPoint: String, headers: HttpHeaders=[:],
             completion: @escaping (AsyncRawResponse)->Void) {
        let url = self.baseUrl.appendingPathComponent(endPoint)
        
        self.asyncRaw(method: .get,
                          url: url,
                      headers: headers,
                         body: nil,
                   completion: completion)
        }
    func deleteRaw(_ endPoint: String, headers: HttpHeaders=[:],
                completion: @escaping (AsyncRawResponse)->Void) {
        let url = self.baseUrl.appendingPathComponent(endPoint)
        
        self.asyncRaw(method: .delete,
                          url: url,
                      headers: headers,
                         body: nil,
                   completion: completion)
        }
    func putRaw(_ endPoint: String, headers: HttpHeaders=[:],
             _ body: Data?, completion: @escaping (AsyncRawResponse)->Void) {
        let url = self.baseUrl.appendingPathComponent(endPoint)
        
        self.asyncRaw(method: .put,
                          url: url,
                      headers: headers,
                         body: body,
                   completion: completion)
        }
    func postRaw(_ endPoint: String, headers: HttpHeaders=[:],
              _ body: Data?, completion: @escaping (AsyncRawResponse)->Void) {
        let url = self.baseUrl.appendingPathComponent(endPoint)
        
        self.asyncRaw(method: .post,
                          url: url,
                      headers: headers,
                         body: body,
                   completion: completion)
        }
}

// MARK: - Asynchronous Keyed Methods
public extension SampleHTTPClient {
    func get(_ endPoint: String, headers: HttpHeaders=[:],
             completion: @escaping (AsyncKeyedResponse)->Void) {
        let url = self.baseUrl.appendingPathComponent(endPoint)
        
        self.async(method: .get,
                      url: url,
                  headers: headers,
                     body: nil,
               completion: completion)
        }
    func delete(_ endPoint: String, headers: HttpHeaders=[:],
                completion: @escaping (AsyncKeyedResponse)->Void) {
        let url = self.baseUrl.appendingPathComponent(endPoint)
        
        self.async(method: .delete,
                      url: url,
                  headers: headers,
                     body: nil,
               completion: completion)
        }
    func put(_ endPoint: String, headers: HttpHeaders=[:],
             _ dict: [String:Any], completion: @escaping (AsyncKeyedResponse)->Void) {
        let url = self.baseUrl.appendingPathComponent(endPoint)
        
        self.async(method: .put,
                      url: url,
                  headers: headers,
                     body: dict,
               completion: completion)
        }
    func post(_ endPoint: String, headers: HttpHeaders=[:],
              _ dict: [String:Any], completion: @escaping (AsyncKeyedResponse)->Void) {
        let url = self.baseUrl.appendingPathComponent(endPoint)
        
        self.async(method: .post,
                      url: url,
                  headers: headers,
                     body: dict,
               completion: completion)
        }
}
