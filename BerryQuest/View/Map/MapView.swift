//
//  MapView.swift
//  BerryQuest
//
//  Created by 김수경 on 10/10/24.
//

import SwiftUI
import CoreLocation

struct MapView: View {
    
    @StateObject private var locationManager = LocationManager()
    @State private var draw = false
    
    var body: some View {
        if let _ = locationManager.currentLocation {
            KakaoMapView(currentLocation: $locationManager.currentLocation, draw: $draw)
                .onAppear {
                    self.draw = true
                }
                .onDisappear {
                    self.draw = false
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else {
            Text("사용자의 위치 정보가 필요합니다.")
        }
    }
       
}

#Preview {
    MapView()
}
