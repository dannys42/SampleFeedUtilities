//
//  HTTPClient.swift
//  A simple HTTP Client library
//
//  Created by Danny Sung on 01/31/2020.
//

import Foundation

public class SampleHTTPClient: NSObject {
    public typealias HttpHeaders = [String:String]
    public typealias KeyedData = [String:Any]
    
    internal var s = URLSession()
    public static let defaultTimeout: TimeInterval = 3.0 // Should be longer in production
    
    public var baseUrl: URL
    public var defaultHeaders: HttpHeaders = [:]
    public var defaultTimeout: TimeInterval = SampleHTTPClient.defaultTimeout

    public enum Failures: Error {
        case timeout
        case noHTTPResponse
        case noData
        case cannotDecodeData
    }
    
    public enum HTTPMethod: CustomStringConvertible {
        case get
        case post
        case put
        case delete
        case custom(String)
        
        public var description: String {
            switch self {
            case .get: return "GET"
            case .put: return "PUT"
            case .post: return "POST"
            case .delete: return "DELETE"
            case .custom(let string): return string
            }
        }

    }

    public init(baseUrl: URL, configuration: URLSessionConfiguration = .default) {
        self.baseUrl = baseUrl
        super.init()
        self.s = URLSession(configuration: configuration,
                            delegate: self,
                            delegateQueue: nil)
    }
    
    /// Make a synchronous HTTP call with Data input/output types
    /// - Parameters:
    ///   - request: URLRequest
    ///   - timeout: timeout to use
    public func sync(request: URLRequest, timeout: TimeInterval) throws -> (HTTPURLResponse, Data) {
        var returnData: Data?
        var returnError: Error?
        var returnResponse: HTTPURLResponse?
        let semaphore = DispatchSemaphore(value: 0)
        
        let task = s.dataTask(with: request) { (data, response, error) in
            returnData = data
            returnError = error
            returnResponse = response as? HTTPURLResponse
            semaphore.signal()
        }
        task.resume()
        
        let waitResult = semaphore.wait(timeout: .now() + timeout)
        if waitResult == .timedOut {
            task.cancel()
            throw Failures.timeout
        }
        
        if let error = returnError {
            throw error
        }
        guard let response = returnResponse else {
            throw Failures.noHTTPResponse
        }
        guard let data = returnData else {
            throw Failures.noData
        }
        return (response, data)
    }
    
    
    /// Make a synchronous HTTP call and return the resulting data
    /// - Parameters:
    ///   - url: URL to connect to
    ///   - headers: Optional header fields to include
    ///   - body: JSON data to send
    ///   - timeout: Optional timeout
    public func syncData(method: HTTPMethod,
                     url: URL,
                     headers: HttpHeaders=[:],
                     body: KeyedData? = nil,
                     timeout: TimeInterval = SampleHTTPClient.defaultTimeout) throws -> (HTTPURLResponse, Data) {
        var req = URLRequest(url: url)
        req.httpMethod = method.description
        
        // Setup HTTP Headers
        req.addHTTPHeaders(headers: self.defaultHeaders, headers)
        
        // Setup body of HTTP message
        if let body = body {
            try req.setJSONBody(keyedData: body)
        }
        
        // Perform the HTTP request
        return try self.sync(request: req, timeout: timeout)
    }

    
    /// Make a synchronous HTTP call decoding the data as keyedData
    /// - Parameters:
    ///   - url: URL to connect to
    ///   - headers: Optional header fields to include
    ///   - body: JSON data to send
    ///   - timeout: Optional timeout
    public func sync(method: HTTPMethod,
                     url: URL,
                     headers: HttpHeaders=[:],
                     body: KeyedData? = nil,
                     timeout: TimeInterval = SampleHTTPClient.defaultTimeout) throws -> (HTTPURLResponse, KeyedData) {
        let (response, data) = try self.syncData(method: method,
                                              url: url,
                                              headers: headers,
                                              body: body,
                                              timeout: timeout
                                              )
        
        // Convert the data to an object
        let returnDict = try data.asKeyedData()
        return (response, returnDict)
    }
    
}

extension SampleHTTPClient: URLSessionTaskDelegate {
    
}
