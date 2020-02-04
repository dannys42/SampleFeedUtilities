//
//  DataExtensions.swift
//  
//
//  Created by Danny Sung on 02/03/2020.
//

import Foundation

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
