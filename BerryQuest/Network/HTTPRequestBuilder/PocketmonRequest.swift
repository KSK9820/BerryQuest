//
//  PokemonRequest.swift
//  BerryQuest
//
//  Created by 김수경 on 10/9/24.
//

import Foundation

enum PokemonRequest {
    case allPokemons
    case pokemon(id: String)
    case pokemonImage(id: String)
}

extension PokemonRequest: HTTPRequestable {
    
    var scheme: String {
        switch self {
        default:
            return "https"
        }
    }

    var baseURLString: String {
        get throws {
            switch self {
            case .allPokemons, .pokemon:
                guard let baseURL = Bundle.main.infoDictionary?["BaseURL"] as? String
                else {
                    throw NetworkError.notFoundBaseURL
                }
                return baseURL
            case .pokemonImage:
                guard let baseURL = Bundle.main.infoDictionary?["ImageBaseURL"] as? String
                else {
                    throw NetworkError.notFoundBaseURL
                }
                return baseURL
            }
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .allPokemons, .pokemon, .pokemonImage:
            return .get
        }
    }
    
    var path: [String] {
        switch self {
        case .allPokemons:
            return ["pokemons"]
        case .pokemon(let id):
            return ["pokemons", id]
        case .pokemonImage(let id):
            return ["PokeAPI", "sprites", "master", "sprites", "pokemon", "other", "official-artwork", "\(id).png"]
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
