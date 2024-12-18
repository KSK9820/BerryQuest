//
//  PokemonDomain.swift
//  BerryQuest
//
//  Created by 김수경 on 10/11/24.
//

import Foundation
import CoreLocation
import KakaoMapsSDK

struct PokemonDomain: Decodable {
    let id: Int
    let name: String
    let imageURL: String
    let coordinate: Coordinate
    var image: Data?
}

struct Coordinate: Decodable {
    let latitude: Double
    let longitude: Double
}

extension Coordinate {
    
    func convertToCoreLocation() -> CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
    }
    
    func convertToMapPoint() -> MapPoint {
        return MapPoint(longitude: self.longitude, latitude: self.latitude)
    }
    
}
