//
//  PokemonInformationResponse.swift
//  BerryQuest
//
//  Created by 김수경 on 10/9/24.
//

import Foundation

struct PokemonInformationResponse: Decodable {
    let id: Int
    let name: String
    let imageURL: String
    let coordinate: CoordinateResponse
    let disease: String
    let berry: String
}

extension PokemonInformationResponse {
    
    func converToDomain() -> PokemonInformationDomain {
        return PokemonInformationDomain(id: self.id,
                                        name: self.name,
                                        imageURL: self.imageURL,
                                        coordinate: self.coordinate.convertToDomain(),
                                        disease: self.disease,
                                        berry: self.berry
        )
    }
    
}
