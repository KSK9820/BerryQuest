//
//  PokemonInformationDomain.swift
//  BerryQuest
//
//  Created by 김수경 on 10/14/24.
//

import Foundation

struct PokemonInformationDomain: Decodable {
    let id: Int
    let name: String
    let imageURL: String
    let coordinate: Coordinate
    let disease: String
    let berry: String
}
