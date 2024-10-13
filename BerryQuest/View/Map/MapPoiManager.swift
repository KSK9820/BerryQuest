//
//  MapPoiManager.swift
//  BerryQuest
//
//  Created by 김수경 on 10/14/24.
//

import KakaoMapsSDK
import CoreLocation

class MapPoiManager {
    
    private var controller: KMController?
    private var container: KMViewContainer?
    
    init(controller: KMController?, container: KMViewContainer?) {
        self.controller = controller
        self.container = container
    }
    
    func setPoi(currentLocation: CLLocationCoordinate2D?, pokemons: [PocketmonDomain]?) {
        createPoiLayer()
        createPoiStyle(pocketmons: pokemons)
        createPoi(currentLocation: currentLocation, pocketmons: pokemons)
    }
    
    private func createPoiLayer() {
        guard let controller else { return }
        guard let mapView = controller.getView("mapview") as? KakaoMap else { return }
        
        let manager = mapView.getLabelManager()
        let layerOption = LabelLayerOptions(layerID: "PoiLayer", competitionType: .none, competitionUnit: .poi, orderType: .rank, zOrder: 10001)
        let _ = manager.addLabelLayer(option: layerOption)
    }
    
    private func createPoiStyle(pocketmons: [PocketmonDomain]?) {
        guard let controller else { return }
        guard let mapView = controller.getView("mapview") as? KakaoMap else { return }
        
        let manager = mapView.getLabelManager()
        let myIconStyle = PoiIconStyle(symbol: UIImage(named: "pin_red.png"), anchorPoint: CGPoint(x: 0.0, y: 0.5))
        let myPerLevelStyle = PerLevelPoiStyle(iconStyle: myIconStyle, level: 0)
        let myPoiStyle = PoiStyle(styleID: "customStyle1", styles: [myPerLevelStyle])

        if let pocketmons {
            var poiStyles = [PoiStyle]()
            for pocketmon in pocketmons {
                let pocketmonBasicIconStyle = PoiIconStyle(symbol: UIImage(named: "pin_green.png"), anchorPoint: CGPoint(x: 0.0, y: 0.5))
                let pocketmonImageIconStyle = PoiIconStyle(symbol: UIImage(data: pocketmon.imageData)?.resize(to: CGSize(width: 30, height: 30)), anchorPoint: CGPoint(x: 0.0, y: 0.5))
                
                let pocketmonBasicPerLevelStyle = PerLevelPoiStyle(iconStyle: pocketmonBasicIconStyle, level: 0)
                let pocketmonImagePerLevelStyle = PerLevelPoiStyle(iconStyle: pocketmonImageIconStyle, level: 12)
                
                let pocketmonPoiStyle = PoiStyle(styleID: "pocketmon\(pocketmon.id)Style", styles: [pocketmonBasicPerLevelStyle, pocketmonImagePerLevelStyle])
                poiStyles.append(pocketmonPoiStyle)
            }
            
            poiStyles.forEach { manager.addPoiStyle($0) }
        }
        manager.addPoiStyle(myPoiStyle)
    }
    
    private func createPoi(currentLocation: CLLocationCoordinate2D?, pocketmons: [PocketmonDomain]?) {
        guard let controller else { return }
        guard let mapView = controller.getView("mapview") as? KakaoMap else { return }
        guard let currentLocation else { return }
        
        let manager = mapView.getLabelManager()
        let layer = manager.getLabelLayer(layerID: "PoiLayer")
        let myPoiOption = PoiOptions(styleID: "customStyle1")
        var pois = [Poi?]()
        
        myPoiOption.rank = 0
        let myPoi = MapPoint(longitude: currentLocation.longitude, latitude: currentLocation.latitude)
        
        pois.append(layer?.addPoi(option: myPoiOption, at: myPoi))
        
        if let pocketmons {
            for pocketmon in pocketmons {
                let pocketmonPoiOption = PoiOptions(styleID: "pocketmon\(pocketmon.id)Style")
                pocketmonPoiOption.rank = 0
                pois.append(layer?.addPoi(option: pocketmonPoiOption, at: MapPoint(longitude: pocketmon.coordinate.longitude, latitude: pocketmon.coordinate.latitude)))
            }
        }
        
        for poi in pois {
            poi?.show()
        }
        
        mapView.moveCamera(CameraUpdate.make(target: myPoi, zoomLevel: 12, mapView: mapView))
    }
    
}
