//
//  CLLocationCoordinate2D+Extension.swift
//  BerryQuest
//
//  Created by 김수경 on 10/13/24.
//

import CoreLocation
import KakaoMapsSDK

extension CLLocationCoordinate2D {
    
    func convertToCoordinate() -> Coordinate {
        return Coordinate(latitude: self.latitude, longitude: self.longitude)
    }
    
    func convertToMapPoint() -> MapPoint {
        return MapPoint(longitude: self.longitude, latitude: self.latitude)
    }
    
}
