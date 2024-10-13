//
//  MapPolylineManager.swift
//  BerryQuest
//
//  Created by 김수경 on 10/14/24.
//

import SwiftUI
import CoreLocation
import KakaoMapsSDK

class MapPolylineManager {
    
    private var controller: KMController?
    private var container: KMViewContainer?
    
    init(controller: KMController?, container: KMViewContainer?) {
        self.controller = controller
        self.container = container
    }
    
    func setPolyline(currentLocation: CLLocationCoordinate2D?, coords: [MapPoint]?) {
        guard let currentLocation,
              let coords else { return }
        
        createPolylineStyleSet()
        createPolylineShape(currentLocation: currentLocation, coords: coords)
    }
    
    private func createPolylineStyleSet() {
        guard let controller else { return }
        guard let mapView = controller.getView("mapview") as? KakaoMap else { return }
        
        let manager = mapView.getShapeManager()
        let polylineStyle = PolylineStyle(styles: [
            PerLevelPolylineStyle(bodyColor: UIColor.blue, bodyWidth: 10, strokeColor: UIColor.red, strokeWidth: 1, level: 0),
        ])
        
        manager.addPolylineStyleSet(PolylineStyleSet(styleSetID: "polylineStyleSet", styles: [polylineStyle]))
    }
    
    private func createPolylineShape(currentLocation: CLLocationCoordinate2D, coords: [MapPoint]?) {
        guard let controller else { return }
        guard let mapView = controller.getView("mapview") as? KakaoMap else { return }
        guard let coords else { return }
        
        let manager = mapView.getShapeManager()
        let layer = manager.addShapeLayer(layerID: "PolylineLayer", zOrder: 10001)
     
//        let locations = [currentLocation.convertToCoordinate()] + pocketmons.map { $0.coordinate }
//        let coords = RouteSearchManager(coordinates: locations)
//            .getShortestPathWithTSP().map { $0.convertToMapPoint() }
        
        let rect = AreaRect(points: coords)
        let lines = [MapPolyline(line: coords, styleIndex: 0)]
        
        let options = MapPolylineShapeOptions(shapeID: "mapPolylines", styleID: "polylineStyleSet", zOrder: 1)
        options.polylines = lines
        
        let polyline = layer?.addMapPolylineShape(options)
        polyline?.show()

        let cameraUpdate = CameraUpdate.make(area: rect)
        mapView.moveCamera(cameraUpdate)
    }
    
}
