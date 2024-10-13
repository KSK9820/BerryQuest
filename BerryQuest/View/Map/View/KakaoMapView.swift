//
//  KakaoMapView.swift
//  BerryQuest
//
//  Created by 김수경 on 10/10/24.
//

import SwiftUI
import CoreLocation
import KakaoMapsSDK

struct KakaoMapView: UIViewRepresentable {
    
    @Binding var currentLocation: CLLocationCoordinate2D?
    @Binding var pocketmons: [PocketmonDomain]?
    @Binding var draw: Bool
    
    /// UIView를 상속한 KMViewContainer를 생성한다.
    /// 뷰 생성과 함께 KMControllerDelegate를 구현한 Coordinator를 생성하고, 엔진을 생성 및 초기화한다.
    func makeUIView(context: Self.Context) -> KMViewContainer {
        let view = KMViewContainer()
        
        view.sizeToFit()
        
        context.coordinator.createController(view)
        
        return view
    }
    
    /// Updates the presented `UIView` (and coordinator) to the latest configuration.
    /// draw가 true로 설정되면 엔진을 시작하고 렌더링을 시작한다.
    /// draw가 false로 설정되면 렌더링을 멈추고 엔진을 stop한다.
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
        }
        else {
            context.coordinator.controller?.pauseEngine()
            context.coordinator.controller?.resetEngine()
        }
    }
    
    func makeCoordinator() -> KakaoMapCoordinator {
        return KakaoMapCoordinator(currentLocation: currentLocation, pocketmon: pocketmons)
    }
    
    /// Cleans up the presented `UIView` (and coordinator) in
    /// anticipation of their removal.
    static func dismantleUIView(_ uiView: KMViewContainer, coordinator: KakaoMapCoordinator) {
        coordinator.controller?.resetEngine()
    }
    
    
    
    /// Coordinator 구현. KMControllerDelegate를 adopt한다.
    final class KakaoMapCoordinator: NSObject, MapControllerDelegate {
        
        var first: Bool
        var controller: KMController?
        var container: KMViewContainer?
        var currentLocation: CLLocationCoordinate2D?
        var pocketmons: [PocketmonDomain]?
        
        init(currentLocation: CLLocationCoordinate2D?, pocketmon: [PocketmonDomain]?) {
            self.first = true
            self.currentLocation = currentLocation
            self.pocketmons = pocketmon
        }
        
        // KMController 객체 생성 및 event delegate 지정
        func createController(_ view: KMViewContainer) {
            container = view
            controller = KMController(viewContainer: view)
            controller?.delegate = self
        }
        
        // KMControllerDelegate Protocol method구현
        
        /// 엔진 생성 및 초기화 이후, 렌더링 준비가 완료되면 아래 addViews를 호출한다.
        /// 원하는 뷰를 생성한다.
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
            
            createPoiLayer()
            createPoiStyle()
            createPoi()
        }
        
        //addView 실패 이벤트 delegate. 실패에 대한 오류 처리를 진행한다.
        func addViewFailed(_ viewName: String, viewInfoName: String) {
            print("Failed")
        }
        
        /// KMViewContainer 리사이징 될 때 호출.
//        func containerDidResized(_ size: CGSize) {
//            guard let controller else { return }
//            guard let mapView = controller.getView("mapview") as? KakaoMap else { return }
//            
//            mapView.viewRect = CGRect(origin: CGPoint(x: 0.0, y: 0.0), size: size)
//            
//            if first {
//                if let currentLocation {
//                    let cameraUpdate = CameraUpdate.make(
//                        target: MapPoint(longitude: currentLocation.longitude, latitude: currentLocation.latitude),
//                        zoomLevel: 10,
//                        mapView: mapView
//                    )
//                    
//                    mapView.moveCamera(cameraUpdate)
//                    first = false
//                } else {
//                    let cameraUpdate = CameraUpdate.make(
//                        target: MapPoint(longitude: 127.108678, latitude: 37.402001),
//                        zoomLevel: 10,
//                        mapView: mapView
//                    )
//                    
//                    mapView.moveCamera(cameraUpdate)
//                    first = false
//                }
//            }
//        }
        
        private func createPoiLayer() {
            guard let controller else { return }
            guard let mapView = controller.getView("mapview") as? KakaoMap else { return }
            
            let manager = mapView.getLabelManager()
            let layerOption = LabelLayerOptions(layerID: "PoiLayer", competitionType: .none, competitionUnit: .poi, orderType: .rank, zOrder: 10001)
            let _ = manager.addLabelLayer(option: layerOption)
        }
        
        private func createPoiStyle() {
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
                
                poiStyles.forEach {
                    manager.addPoiStyle($0)
                }
            }
            
            manager.addPoiStyle(myPoiStyle)
        }
        
        private func createPoi() {
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
    
}
