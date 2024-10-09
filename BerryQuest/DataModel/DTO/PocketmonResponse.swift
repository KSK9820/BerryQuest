//
//  PocketmonResponse.swift
//  BerryQuest
//
//  Created by 김수경 on 10/9/24.
//

import Foundation

struct PocketmonResponse: Decodable {
    let id: Int
    let name: String
    let imageURL: String
    let coordinate: CoordinateResponse
}

struct CoordinateResponse: Decodable {
    let latitude: Double
    let longitude: Double
}
