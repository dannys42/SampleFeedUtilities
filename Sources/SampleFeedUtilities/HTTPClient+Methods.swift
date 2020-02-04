//
//  HTTPClient+Methods.swift
//  
//
//  Created by Danny Sung on 02/01/2020.
//

import Foundation

// MARK: - Synchronous Methods
public extension SampleHTTPClient {
    func get(_ endPoint: String, headers: HttpHeaders=[:]) throws -> (HTTPURLResponse, KeyedData) {
        let url = self.baseUrl.appendingPathComponent(endPoint)
        
        return try self.sync(method: .get,
                                url: url,
                            headers: headers,
                               body: nil,
                            timeout: self.defaultTimeout)
        }
    func delete(_ endPoint: String, headers: HttpHeaders=[:]) throws -> (HTTPURLResponse, KeyedData) {
        let url = self.baseUrl.appendingPathComponent(endPoint)
        
        return try self.sync(method: .delete,
                                url: url,
                            headers: headers,
                               body: nil,
                            timeout: self.defaultTimeout)
        }
    func put(_ endPoint: String, headers: HttpHeaders=[:],
             _ dict: KeyedData) throws -> (HTTPURLResponse, KeyedData) {
        let url = self.baseUrl.appendingPathComponent(endPoint)
        
        return try self.sync(method: .put,
                                url: url,
                            headers: headers,
                               body: dict,
                            timeout: self.defaultTimeout)
        }
    func post(_ endPoint: String, headers: HttpHeaders=[:],
              _ dict: KeyedData) throws -> (HTTPURLResponse, KeyedData) {
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
    /// Perform an asynchronous HTTP GET.
    /// - Parameters:
    ///   - endPoint: Endpoint to GET
    ///   - headers: Optional headers to use
    ///   - completion: completion handler
    func getRaw(_ endPoint: String, headers: HttpHeaders=[:],
             completion: @escaping (AsyncRawResponse)->Void) {
        let url = self.baseUrl.appendingPathComponent(endPoint)
        
        self.asyncRaw(method: .get,
                          url: url,
                      headers: headers,
                         body: nil,
                   completion: completion)
    }
    /// Perform an asynchronous HTTP DELETE.
    /// - Parameters:
    ///   - endPoint: Endpoint to DELETE
    ///   - headers: Optional headers to use
    ///   - completion: completion handler
    func deleteRaw(_ endPoint: String, headers: HttpHeaders=[:],
                completion: @escaping (AsyncRawResponse)->Void) {
        let url = self.baseUrl.appendingPathComponent(endPoint)
        
        self.asyncRaw(method: .delete,
                          url: url,
                      headers: headers,
                         body: nil,
                   completion: completion)
    }
    /// Perform an asynchronous HTTP PUT.
    /// - Parameters:
    ///   - endPoint: Endpoint to PUT
    ///   - headers: Optional headers to use
    ///   - body: Body content as Data (will be sent as-is)
    ///   - completion: completion handler
    func putRaw(_ endPoint: String, headers: HttpHeaders=[:],
             _ body: Data?, completion: @escaping (AsyncRawResponse)->Void) {
        let url = self.baseUrl.appendingPathComponent(endPoint)
        
        self.asyncRaw(method: .put,
                          url: url,
                      headers: headers,
                         body: body,
                   completion: completion)
    }
    /// Perform an asynchronous HTTP POST.
    /// - Parameters:
    ///   - endPoint: Endpoint to POST
    ///   - headers: Optional headers to use
    ///   - body: Body content as Data (will be sent as-is)
    ///   - completion: completion handler
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
    /// Perform an asynchronous HTTP GET.
    /// - Parameters:
    ///   - endPoint: Endpoint to GET
    ///   - headers: Optional headers to use
    ///   - completion: completion handler
    func get(_ endPoint: String, headers: HttpHeaders=[:],
             completion: @escaping (AsyncKeyedResponse)->Void) {
        let url = self.baseUrl.appendingPathComponent(endPoint)
        
        self.async(method: .get,
                      url: url,
                  headers: headers,
                     body: nil,
               completion: completion)
    }
    /// Perform an asynchronous HTTP DELETE.
    /// - Parameters:
    ///   - endPoint: Endpoint to DELETE
    ///   - headers: Optional headers to use
    ///   - completion: completion handler
    func delete(_ endPoint: String, headers: HttpHeaders=[:],
                completion: @escaping (AsyncKeyedResponse)->Void) {
        let url = self.baseUrl.appendingPathComponent(endPoint)
        
        self.async(method: .delete,
                      url: url,
                  headers: headers,
                     body: nil,
               completion: completion)
    }
    /// Perform an asynchronous HTTP PUT.
    /// - Parameters:
    ///   - endPoint: Endpoint to PUT
    ///   - headers: Optional headers to use
    ///   - dict: body content as a dictionary (will be converted to JSON)
    ///   - completion: completion handler
    func put(_ endPoint: String, headers: HttpHeaders=[:],
             _ dict: [String:Any], completion: @escaping (AsyncKeyedResponse)->Void) {
        let url = self.baseUrl.appendingPathComponent(endPoint)
        
        self.async(method: .put,
                      url: url,
                  headers: headers,
                     body: dict,
               completion: completion)
    }
    /// Perform an asynchronous HTTP POST.
    /// - Parameters:
    ///   - endPoint: Endpoint to POST
    ///   - headers: Optional headers to use
    ///   - dict: body content as a dictionary (will be converted to JSON)
    ///   - completion: completion handler
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
