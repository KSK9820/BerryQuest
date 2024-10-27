//
//  PokemonResponse.swift
//  BerryQuest
//
//  Created by 김수경 on 10/9/24.
//

import Foundation
import Combine

struct PokemonResponse: Decodable {
    let id: Int
    let name: String
    let imageURL: String
    let coordinate: CoordinateResponse
}

extension PokemonResponse {
    
    func convertToDomain() -> PokemonDomain {
        return PokemonDomain(
            id: self.id,
            name: self.name,
            imageURL: self.imageURL, 
            coordinate: self.coordinate.convertToDomain()
        )
    }
    
}

struct CoordinateResponse: Decodable {
    let latitude: Double
    let longitude: Double
}

extension CoordinateResponse {
    
    func convertToDomain() -> Coordinate {
        Coordinate(latitude: self.latitude, longitude: self.longitude)
    }
    
}


