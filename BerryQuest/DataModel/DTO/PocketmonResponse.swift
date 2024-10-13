//
//  PocketmonResponse.swift
//  BerryQuest
//
//  Created by 김수경 on 10/9/24.
//

import Foundation
import Combine

struct PocketmonResponse: Decodable {
    let id: Int
    let name: String
    let imageURL: String
    let coordinate: CoordinateResponse
    
    func convertToDomain() -> AnyPublisher<PocketmonDomain, Error> {
        return NetworkManager.shared.getData(PocketmonRequest.pocketmonImage(id: "\(self.id)"))
            .map { imageData in
                PocketmonDomain(
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
    
    func convertToDomain() -> Coordinate {
        Coordinate(latitude: self.latitude, longitude: self.longitude)
    }
    
}


