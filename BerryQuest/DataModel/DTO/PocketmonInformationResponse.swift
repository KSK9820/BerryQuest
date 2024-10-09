//
//  PocketmonInformationResponse.swift
//  BerryQuest
//
//  Created by 김수경 on 10/9/24.
//

import Foundation

struct PocketmonInformationResponse: Decodable {
    let id: Int
    let name: String
    let imageURL: String
    let coordinate: CoordinateResponse
    let disease: String
    let berry: String
}
