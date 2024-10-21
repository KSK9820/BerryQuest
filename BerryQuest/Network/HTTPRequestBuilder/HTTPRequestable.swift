//
//  HTTPRequestable.swift
//  BerryQuest
//
//  Created by 김수경 on 10/9/24.
//

import Foundation

protocol HTTPRequestable {
    var scheme: String { get }
    var baseURLString: String { get throws }
    var httpMethod: HTTPMethod { get }
    var path: [String] { get }
    var queries: [URLQueryItem]? { get }
    var httpHeaders: [String: String]? { get }
    
    func asURL() -> URL?
    func asURLRequest() -> URLRequest?
}

extension HTTPRequestable {
    
    func asURL() -> URL? {
        do {
            var components = URLComponents()
            
            components.scheme = scheme
            components.host = try baseURLString
            components.path = "/" + path.joined(separator: "/")
            
            if let queries {
                components.queryItems = queries
            }
            
            guard let url = components.url else {
                return nil
            }
            
            return url
        } catch {
            print(error, error.localizedDescription)
            
            return nil
        }
    }
    
    func asURLRequest() -> URLRequest? {
        guard let url = asURL() else {
            return nil
        }
        
        var urlRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = httpMethod.rawValue
        urlRequest.allHTTPHeaderFields = httpHeaders
        
        return urlRequest
    }
    
}
