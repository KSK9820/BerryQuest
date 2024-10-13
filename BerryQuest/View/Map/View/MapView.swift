//
//  MapView.swift
//  BerryQuest
//
//  Created by 김수경 on 10/10/24.
//

import SwiftUI
import CoreLocation

struct MapView: View {
    
    @StateObject private var viewModel = MapViewModel()
    @State private var isShowingSheet = true
    
    var body: some View {
        if let _ = viewModel.currentLocation,
           let _ = viewModel.pocketmon {
            KakaoMapView(currentLocation: $viewModel.currentLocation, pocketmons: $viewModel.pocketmon, draw: $viewModel.draw)
                .onAppear {
                    viewModel.input.onAppear.send(())
                }
                .onDisappear {
                    viewModel.input.onDisappear.send(())
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .sheet(isPresented: $isShowingSheet, content: {
                    if let pokemons = $viewModel.pocketmon.wrappedValue {
                        let pokemonBinding = Binding<[PocketmonDomain]>(
                               get: {
                                   viewModel.pocketmon ?? [] 
                               },
                               set: {
                                   viewModel.pocketmon = $0
                               }
                           )
                        PokemonListView(pokemons: pokemonBinding)
                            .presentationDetents([.fraction(0.05), .medium, .large])
                            .interactiveDismissDisabled()
                            .presentationBackgroundInteraction(.enabled)
                    }
                })
        } else {
            Text("사용자의 위치 정보가 필요합니다.")
        }
    }
       
}

#Preview {
    MapView()
}
