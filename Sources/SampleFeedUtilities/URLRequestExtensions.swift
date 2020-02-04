//
//  URLRequestExtensions.swift
//  
//
//  Created by Danny Sung on 02/02/2020.
//

import Foundation

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
