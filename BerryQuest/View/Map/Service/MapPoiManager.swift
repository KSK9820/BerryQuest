//
//  MapPoiManager.swift
//  BerryQuest
//
//  Created by 김수경 on 10/14/24.
//

import KakaoMapsSDK
import CoreLocation

final class MapPoiManager {
    
    private var controller: KMController?
    private var container: KMViewContainer?
    
    init(controller: KMController?, container: KMViewContainer?) {
        self.controller = controller
        self.container = container
    }
    
    func setPoi(currentLocation: CLLocationCoordinate2D?, pokemons: [PokemonDomain]?) {
        createPoiLayer()
        createPoiStyle(pokemons: pokemons)
        createPoi(currentLocation: currentLocation, pokemons: pokemons)
    }

    private func createPoiLayer() {
        guard let controller else { return }
        guard let mapView = controller.getView("mapview") as? KakaoMap else { return }
        
        let manager = mapView.getLabelManager()
        let layerOption = LabelLayerOptions(layerID: "PoiLayer", competitionType: .none, competitionUnit: .poi, orderType: .rank, zOrder: 10001)
        
        manager.removeLabelLayer(layerID: "PoiLayer")
        let _ = manager.addLabelLayer(option: layerOption)
    }
    
    private func createPoiStyle(pokemons: [PokemonDomain]?) {
        guard let controller else { return }
        guard let mapView = controller.getView("mapview") as? KakaoMap else { return }
        
        let manager = mapView.getLabelManager()
        let myIconStyle = PoiIconStyle(symbol: UIImage(named: "pin_red.png"), anchorPoint: CGPoint(x: 0.5, y: 1.0))
        let myPerLevelStyle = PerLevelPoiStyle(iconStyle: myIconStyle, level: 0)
        let myPoiStyle = PoiStyle(styleID: "myPoiStyle", styles: [myPerLevelStyle])

        if let pokemons {
            var poiStyles = [PoiStyle]()
            for pokemon in pokemons {
                let pokemonBasicIconStyle = PoiIconStyle(symbol: UIImage(named: "pin_green.png"), anchorPoint: CGPoint(x: 0.5, y: 1.0))
                let pokemonImageIconStyle = PoiIconStyle(symbol: UIImage(data: pokemon.imageData)?.resize(to: CGSize(width: 30, height: 30)), anchorPoint: CGPoint(x: 0.5, y: 1.0))
                
                let pokemonBasicPerLevelStyle = PerLevelPoiStyle(iconStyle: pokemonBasicIconStyle, level: 0)
                let pokemonImagePerLevelStyle = PerLevelPoiStyle(iconStyle: pokemonImageIconStyle, level: 12)
                
                let pokemonPoiStyle = PoiStyle(styleID: "pokemon\(pokemon.id)Style", styles: [pokemonBasicPerLevelStyle, pokemonImagePerLevelStyle])
                poiStyles.append(pokemonPoiStyle)
            }
            
            poiStyles.forEach { manager.addPoiStyle($0) }
        }
        manager.addPoiStyle(myPoiStyle)
    }
    
    private func createPoi(currentLocation: CLLocationCoordinate2D?, pokemons: [PokemonDomain]?) {
        guard let controller else { return }
        guard let mapView = controller.getView("mapview") as? KakaoMap else { return }
        guard let currentLocation else { return }
        
        let manager = mapView.getLabelManager()
        let layer = manager.getLabelLayer(layerID: "PoiLayer")
        let myPoiOption = PoiOptions(styleID: "myPoiStyle")
        var pois = [Poi?]()
        
        myPoiOption.rank = 0
        let myPoi = MapPoint(longitude: currentLocation.longitude, latitude: currentLocation.latitude)
        
        pois.append(layer?.addPoi(option: myPoiOption, at: myPoi))
        
        if let pokemons {
            for pokemon in pokemons {
                let pokemonPoiOption = PoiOptions(styleID: "pokemon\(pokemon.id)Style")
                pokemonPoiOption.rank = 0
                pois.append(layer?.addPoi(option: pokemonPoiOption, at: MapPoint(longitude: pokemon.coordinate.longitude, latitude: pokemon.coordinate.latitude)))
            }
        }
        
        for poi in pois {
            poi?.show()
        }
        
        mapView.moveCamera(CameraUpdate.make(target: myPoi, zoomLevel: 12, mapView: mapView))
    }
    
}
