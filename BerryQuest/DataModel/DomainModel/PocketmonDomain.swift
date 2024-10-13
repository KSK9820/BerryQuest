//
//  PocketmonDomain.swift
//  BerryQuest
//
//  Created by 김수경 on 10/11/24.
//

import Foundation
import CoreLocation
import KakaoMapsSDK

struct PocketmonDomain: Decodable {
    let id: Int
    let name: String
    let imageData: Data
    let coordinate: Coordinate
}

struct Coordinate: Decodable {
    let latitude: Double
    let longitude: Double
    
    func convertToCoreLocation() -> CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
    }
    
    func convertToMapPoint() -> MapPoint {
        return MapPoint(longitude: self.longitude, latitude: self.latitude)
    }
    
}
