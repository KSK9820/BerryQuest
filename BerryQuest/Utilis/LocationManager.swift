//
//  LocationManager.swift
//  BerryQuest
//
//  Created by 김수경 on 10/11/24.
//

import CoreLocation

final class LocationManager: NSObject, ObservableObject {
    
    @Published var currentLocation: CLLocationCoordinate2D?
    
    private let manager = CLLocationManager()
    
    override init() {
        super.init()
        
        configureLocationManager()
        requestAuthorization()
    }
    
    private func configureLocationManager() {
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    private func requestAuthorization() {
        manager.requestWhenInUseAuthorization()
    }
    
    // 현재 위치를 실시간으로 업데이트
    private func updateLocation() {
        manager.startUpdatingLocation()
    }
    
}

extension LocationManager: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                switch manager.authorizationStatus {
                case .authorizedWhenInUse, .authorizedAlways:
                    self.updateLocation()
                case .notDetermined:
                    self.requestAuthorization()
                case .restricted, .denied:
                    break
                default:
                    break
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        self.currentLocation = location.coordinate
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("didFailedWithError")
    }
    
}
