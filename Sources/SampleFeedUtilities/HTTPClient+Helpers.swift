//
//  HTTPClient+Helpers.swift
//  
//
//  Created by Danny Sung on 02/02/2020.
//

import Foundation

internal extension SampleHTTPClient {
//    func
}

internal extension URLRequest {
    /// Add headers to the URLRequest
    /// - Parameter headers: headers to be added in the order received
    mutating func addHTTPHeaders(headers: SampleHTTPClient.HttpHeaders...) {
        for header in headers {
            for (key,value) in header {
                self.addValue(value, forHTTPHeaderField: key)
            }
        }
    }
    
    
    /// Set a JSON body given SampleHTTPClient.KeyedData
    /// - Parameter keyedData: dictionary with string-based keys
    mutating func setJSONBody(keyedData: SampleHTTPClient.KeyedData) throws {
        // Pretty printing for debug.  (Should be removed in production for performance)
        let jsonData = try JSONSerialization.data(withJSONObject: keyedData,
                                              options: .prettyPrinted)
        self.httpBody = jsonData
    }
    /// Set a JSON body given a Codable
    /// - Parameter keyedData: dictionary with string-based keys
    mutating func setJSONBody(codable: Decodable) throws {
        // Pretty printing for debug.  (Should be removed in production for performance)
        let jsonData = try JSONSerialization.data(withJSONObject: codable,
                                              options: .prettyPrinted)
        self.httpBody = jsonData
    }
}

internal extension Data {
    func asKeyedData() throws -> SampleHTTPClient.KeyedData {
        let jsonData = try JSONSerialization.jsonObject(with: self,
                                                      options: [])
        guard let keyedData = jsonData as? SampleHTTPClient.KeyedData else {
            throw SampleHTTPClient.Failures.cannotDecodeData
        }
        return keyedData
    }
    
    func asCodable<T: Encodable>(type: T.Type) throws -> T {
        let jsonData = try JSONSerialization.jsonObject(with: self,
                                                      options: [])
        guard let codableData = jsonData as? T else {
            throw SampleHTTPClient.Failures.cannotDecodeData
        }
        return codableData
    }
}
