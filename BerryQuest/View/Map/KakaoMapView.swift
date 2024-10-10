//
//  KakaoMapView.swift
//  BerryQuest
//
//  Created by 김수경 on 10/10/24.
//

import SwiftUI
import KakaoMapsSDK

struct KakaoMapView: UIViewRepresentable {
    
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
        return KakaoMapCoordinator()
    }
    
    /// Cleans up the presented `UIView` (and coordinator) in
    /// anticipation of their removal.
    static func dismantleUIView(_ uiView: KMViewContainer, coordinator: KakaoMapCoordinator) {
        coordinator.controller?.resetEngine()
    }
    
    
    /// Coordinator 구현. KMControllerDelegate를 adopt한다.
    final class KakaoMapCoordinator: NSObject, MapControllerDelegate {
        
        var controller: KMController?
        var container: KMViewContainer?
        var first: Bool
        var auth: Bool
        
        override init() {
            first = true
            auth = false
            super.init()
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
            let defaultPosition = MapPoint(longitude: 126.9751461, latitude: 37.5658049)
            let mapviewInfo = MapviewInfo(viewName: "mapview", viewInfoName: "map", defaultPosition: defaultPosition)
            
            controller?.addView(mapviewInfo)
        }
        
        func addViewSucceeded(_ viewName: String, viewInfoName: String) {
            print("OK") //추가 성공. 성공시 추가적으로 수행할 작업을 진행한다.
            
            let view = controller?.getView("mapview")
            
            view?.viewRect = container!.bounds
        }
        
        //addView 실패 이벤트 delegate. 실패에 대한 오류 처리를 진행한다.
        func addViewFailed(_ viewName: String, viewInfoName: String) {
            print("Failed")
        }
        
        func authenticationSucceeded() {
            auth = true
        }
        
        /// KMViewContainer 리사이징 될 때 호출.
        func containerDidResized(_ size: CGSize) {
            guard let controller else { return }
            guard let mapView = controller.getView("mapview") as? KakaoMap else { return }
            
            mapView.viewRect = CGRect(origin: CGPoint(x: 0.0, y: 0.0), size: size)
            
            if first {
                let cameraUpdate = CameraUpdate.make(
                    target: MapPoint(longitude: 127.108678, latitude: 37.402001),
                    zoomLevel: 10,
                    mapView: mapView
                )
                
                mapView.moveCamera(cameraUpdate)
                first = false
            }
        }
        
    }
    
}


