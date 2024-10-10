//
//  PocketmonRequest.swift
//  BerryQuest
//
//  Created by 김수경 on 10/9/24.
//

import Foundation

enum PocketmonRequest {
    case allPocketmons
    case pocketmon(id: String)
}

extension PocketmonRequest: HTTPRequestable {
    
    var scheme: String {
        switch self {
        default:
            return "https"
        }
    }
    
    var baseURLString: String {
        get throws {
            guard let baseURL = Bundle.main.infoDictionary?["BaseURL"] as? String
            else {
                throw NetworkError.notFoundBaseURL
            }
            return baseURL
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .allPocketmons, .pocketmon:
            return .get
        }
    }
    
    var path: [String] {
        switch self {
        case .allPocketmons:
            return ["pokemons"]
        case .pocketmon(let id):
            return ["pokemons", id]
        }
    }
    
    var queries: [URLQueryItem]? {
        switch self {
        default:
            return nil
        }
    }
    
    var httpHeaders: [String : String]? {
        switch self {
        default:
            return nil
        }
    }

}
