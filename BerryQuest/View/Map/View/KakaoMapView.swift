//
//  KakaoMapView.swift
//  BerryQuest
//
//  Created by 김수경 on 10/10/24.
//

import SwiftUI
import Combine
import CoreLocation
import KakaoMapsSDK

struct KakaoMapView: UIViewRepresentable {
    
    @ObservedObject var viewModel: MapViewModel
    
    func makeUIView(context: Self.Context) -> KMViewContainer {
        let view = KMViewContainer()
        view.sizeToFit()
        
        context.coordinator.createController(view)
        
        return view
    }
    
    func updateUIView(_ uiView: KMViewContainer, context: Self.Context) {
        if viewModel.draw {
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
        return KakaoMapCoordinator(viewModel: viewModel)
    }
    
    static func dismantleUIView(_ uiView: KMViewContainer, coordinator: KakaoMapCoordinator) {
//        coordinator.controller?.resetEngine()
    }
    
}


// Coordinator 패턴으로 MapView에서 사용할 객체들을 생성
final class KakaoMapCoordinator: NSObject, MapControllerDelegate, GuiEventDelegate {
    
    var first: Bool
    var controller: KMController?
    var container: KMViewContainer?
    private var viewModel: MapViewModel
    private var cancellables = Set<AnyCancellable>()
    
    private lazy var poiManager = MapPoiManager(controller: controller, container: container)
    private lazy var polyManager = MapPolylineManager(controller: controller, container: container)
    
    init(viewModel: MapViewModel) {
        self.first = true
        self.viewModel = viewModel
    }

    func createController(_ view: KMViewContainer) {
        container = view
        controller = KMController(viewContainer: view)
        controller?.delegate = self
    }
    
    func addViews() {
        var defaultPosition = MapPoint(longitude: 127.108678, latitude: 37.402001)
        
        if let currentLocation = viewModel.currentLocation {
            defaultPosition = MapPoint(longitude: currentLocation.longitude, latitude: currentLocation.latitude)
        }
        
        let mapviewInfo = MapviewInfo(viewName: "mapview", viewInfoName: "map", defaultPosition: defaultPosition)
        
        controller?.addView(mapviewInfo)
    }
    
    func addViewSucceeded(_ viewName: String, viewInfoName: String) {
        let view = controller?.getView("mapview")
        
        view?.viewRect = container!.bounds
        
        poiManager.setPoi(currentLocation: viewModel.currentLocation, pokemons: viewModel.pokemon)
        createSpriteGUI()
        
        changeCurrentLocation()
    }
    
    func addViewFailed(_ viewName: String, viewInfoName: String) {
        print("Failed")
    }
    
    // 위치 변경에 따른 Poi와 Polyline 업데이트
    private func changeCurrentLocation() {
        viewModel.$currentLocation
            .sink { completion in
                if case .failure(let failure) = completion {
                    print(failure)
                }
            } receiveValue: { [weak self] value in
                guard let self else { return }
                
                self.poiManager.setPoi(currentLocation: value, pokemons: self.viewModel.pokemon)
                self.polyManager.removePolyline()
            }
            .store(in: &cancellables)
    }
    
    private func createSpriteGUI() {
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
            poiManager.setPoi(currentLocation: viewModel.currentLocation, pokemons: viewModel.pokemon)
            polyManager.setPolyline(currentLocation: viewModel.currentLocation, coords: shortRoute.map { $0.convertToMapPoint() })
        }
    }
    
}
