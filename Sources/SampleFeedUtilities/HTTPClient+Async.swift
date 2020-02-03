//
//  HTTPClient+Async.swift
//  
//
//  Created by Danny Sung on 02/01/2020.
//

import Foundation

public extension SampleHTTPClient {
    typealias AsyncRawResponse = Result<(HTTPURLResponse,Data), Error>
    typealias AsyncKeyedResponse = Result<(HTTPURLResponse, KeyedData), Error>
    
    /// Make an asynchronous HTTP call with Data input/output types
    /// - Parameters:
    ///   - request: URLRequest
    ///   - timeout: timeout to use
    @discardableResult
    func async(request: URLRequest, completion: @escaping (AsyncRawResponse)->Void ) -> URLSessionDataTask {
        let task = s.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let response = response as? HTTPURLResponse else {
                completion(.failure(Failures.noHTTPResponse))
                return
            }
            guard let data = data else {
                completion(.failure(Failures.noData))
                return
            }
            
            completion(.success((response, data)))
        }
        task.resume()
        return task
    }

    /// Make an asynchronous HTTP call with input/output dictionaries
    /// - Parameters:
    ///   - url: URL to connect to
    ///   - headers: Optional header fields to include
    ///   - body: data to send
    ///   - timeout: Optional timeout
    @discardableResult
    func asyncRaw(method: HTTPMethod,
                     url: URL,
                     headers: HttpHeaders=[:],
                     body: Data? = nil,
                     completion: @escaping (AsyncRawResponse)->Void) -> URLSessionDataTask? {
        
        var req = URLRequest(url: url)
        req.httpMethod = method.description
        
        // Setup HTTP Headers
        req.addHTTPHeaders(headers: self.defaultHeaders, headers)

        // Setup body of HTTP message
        req.httpBody = body

        // Perform the HTTP request
        let task = self.async(request: req) { (response) in
            switch response {
            case .failure(let error):
                completion(.failure(error))
            case .success(let httpResponse, let data):
                completion(.success((httpResponse, data)))
            }
        }
        return task
    }
    
    /// Make an asynchronous HTTP call with input/output dictionaries
    /// - Parameters:
    ///   - url: URL to connect to
    ///   - headers: Optional header fields to include
    ///   - body: JSON data to send
    ///   - timeout: Optional timeout
    @discardableResult
    func async(method: HTTPMethod,
                     url: URL,
                     headers: HttpHeaders=[:],
                     body: KeyedData? = nil,
                     completion: @escaping (AsyncKeyedResponse)->Void) -> URLSessionDataTask? {
        
        var bodyData: Data?
        do {
            // Pretty printing for debug.  (Should be removed in production for performance)
            let jsonData = try JSONSerialization.data(withJSONObject: body as Any,
                                                  options: .prettyPrinted)
            bodyData = jsonData
        } catch {
            completion(.failure(error))
            return nil
        }

        let task = asyncRaw(method: method,
                         url: url,
                         headers: headers,
                         body: bodyData) { rawResponse in
                            switch rawResponse {
                            case .failure(let error):
                                completion( .failure(error) )
                            case .success(let httpResponse, let data):
                                // Convert the data to an object
                                do {
                                    let returnDict = try data.asKeyedData()
                                    completion(.success((httpResponse, returnDict)))
                                } catch {
                                    completion(.failure(error))
                                    return
                                }
                            }
        }

        return task
    }

}
