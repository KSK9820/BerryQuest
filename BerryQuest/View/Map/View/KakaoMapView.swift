//
//  KakaoMapView.swift
//  BerryQuest
//
//  Created by 김수경 on 10/10/24.
//

import UIKit
import SwiftUI
import CoreLocation
import KakaoMapsSDK

struct KakaoMapView: UIViewRepresentable {
    
    @Binding var currentLocation: CLLocationCoordinate2D?
    @Binding var pocketmons: [PocketmonDomain]?
    @Binding var draw: Bool
    @ObservedObject var viewModel: MapViewModel
    
    func makeUIView(context: Self.Context) -> KMViewContainer {
        let view = KMViewContainer()
        view.sizeToFit()
        
        context.coordinator.createController(view)
        
        return view
    }
    
    func updateUIView(_ uiView: KMViewContainer, context: Self.Context) {
        if draw {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                if context.coordinator.controller?.isEnginePrepared == false {
                    context.coordinator.controller?.prepareEngine()
                }
                
                if context.coordinator.controller?.isEngineActive == false {
                    context.coordinator.controller?.activateEngine()
                }
            }
        } else {
            context.coordinator.controller?.pauseEngine()
            context.coordinator.controller?.resetEngine()
        }
    }
    
    func makeCoordinator() -> KakaoMapCoordinator {
        return KakaoMapCoordinator(currentLocation: currentLocation, viewModel: viewModel)
    }
    
    static func dismantleUIView(_ uiView: KMViewContainer, coordinator: KakaoMapCoordinator) {
        coordinator.controller?.resetEngine()
    }
    
}

final class KakaoMapCoordinator: NSObject, MapControllerDelegate, GuiEventDelegate {
    
    var first: Bool
    var controller: KMController?
    var container: KMViewContainer?
    private var currentLocation: CLLocationCoordinate2D?
//    private var pocketmons: [PocketmonDomain]?
    private var viewModel: MapViewModel
    
    lazy var poiManager = MapPoiManager(controller: controller, container: container)
    lazy var polyManager = MapPolylineManager(controller: controller, container: container)
    
    init(currentLocation: CLLocationCoordinate2D?, viewModel: MapViewModel) {
        self.first = true
        self.currentLocation = currentLocation
//        self.pocketmons = pocketmons
        self.viewModel = viewModel
    }
    
    func createController(_ view: KMViewContainer) {
        container = view
        controller = KMController(viewContainer: view)
        controller?.delegate = self
    }
    
    func addViews() {
        var defaultPosition = MapPoint(longitude: 127.108678, latitude: 37.402001)
        
        if let currentLocation {
            defaultPosition = MapPoint(longitude: currentLocation.longitude, latitude: currentLocation.latitude)
        }
        
        let mapviewInfo = MapviewInfo(viewName: "mapview", viewInfoName: "map", defaultPosition: defaultPosition)
        
        controller?.addView(mapviewInfo)
    }
    
    func addViewSucceeded(_ viewName: String, viewInfoName: String) {
        let view = controller?.getView("mapview")
        
        view?.viewRect = container!.bounds
        
        poiManager.setPoi(currentLocation: currentLocation, pokemons: viewModel.pocketmon)
        createSpriteGUI()
    }
    
    func addViewFailed(_ viewName: String, viewInfoName: String) {
        print("Failed")
    }
    
    func createSpriteGUI() {
        guard let controller else { return }
        guard let mapView = controller.getView("mapview") as? KakaoMap else { return }
        
        let manager = mapView.getGuiManager()
        let spriteLayer = manager.spriteGuiLayer
        
        let button = GuiButton("button")
        button.image = UIImage(named: "route")
        
        let spriteGui = SpriteGui("buttonGui")
        spriteGui.addChild(button)
        spriteGui.origin = GuiAlignment(vAlign: .top, hAlign: .right)
        spriteGui.delegate = self
        
        spriteLayer.addSpriteGui(spriteGui)
        spriteGui.show()
    }
    
    func guiDidTapped(_ gui: GuiBase, componentName: String) {
        viewModel.input.buttonTapped.send(())
        if let shortRoute = viewModel.shortRoute {
            polyManager.setPolyline(currentLocation: currentLocation, coords: shortRoute.map { $0.convertToMapPoint() })
        }
    }
    
}



