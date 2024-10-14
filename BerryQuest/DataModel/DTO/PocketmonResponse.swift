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
    
    func convertToDomain() -> AnyPublisher<PokemonDomain, Error> {
        return NetworkManager.shared.getData(PokemonRequest.pokemonImage(id: "\(self.id)"))
            .map { imageData in
                PokemonDomain(
                    id: self.id,
                    name: self.name,
                    imageData: imageData,
                    coordinate: self.coordinate.convertToDomain()
                )
            }
            .eraseToAnyPublisher()
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


