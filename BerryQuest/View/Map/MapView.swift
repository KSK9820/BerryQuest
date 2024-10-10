//
//  MapView.swift
//  BerryQuest
//
//  Created by 김수경 on 10/10/24.
//

import SwiftUI

struct MapView: View {
    
    @State var draw = true
    
    var body: some View {
        KakaoMapView(draw: $draw)
            .onAppear(perform: {
                self.draw = true
            })
            .onDisappear(perform: {
                self.draw = false
            })
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    MapView()
}
