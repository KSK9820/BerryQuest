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
    }
    
    private func configureLocationManager() {
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    private func requestAuthorization() {
        manager.requestWhenInUseAuthorization()
    }
    
    private func requestLocation() {
        manager.requestLocation()
    }
    
    private func updateLocation() {
        manager.startUpdatingLocation()
    }
    
    private func stopUpdatingLocation() {
        manager.stopUpdatingLocation()
    }
    
}

extension LocationManager: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            updateLocation()
        case .notDetermined:
            requestAuthorization()
        case .restricted, .denied:
            break
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        DispatchQueue.main.async { 
            self.currentLocation = location.coordinate
            self.stopUpdatingLocation()
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("didFailedWithError")
    }
    
}
