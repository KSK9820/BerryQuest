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

    var body: some View {
        if let _ = viewModel.currentLocation,
           let _ = viewModel.pokemon {
            ZStack {
                kakaoMapView()
                pokemonListView()
                    .transition(.move(edge: .bottom))
            }
        } else {
            loadingView()
        }
    }
    
    private func kakaoMapView() -> some View {
        KakaoMapView(viewModel: viewModel)
            .onAppear {
                viewModel.input.onAppear.send(())
            }
            .onDisappear {
                viewModel.input.onDisappear.send(())
            }
           
    }
    
    private func pokemonListView() -> some View {
        CustomBottomSheet() {
            let pokemonBinding = Binding<[PokemonDomain]>(
                get: {
                    viewModel.pokemon ?? []
                },
                set: {
                    viewModel.pokemon = $0
                }
            )
            
            PokemonListView(pokemons: pokemonBinding)
        }
    }
    
    private func loadingView() -> some View {
        VStack(alignment: .center) {
            Text("카카오 모빌리티")
            Text("iOS 직무 지원자")
            Text("김수경")
        }
        .font(.largeTitle)
        .foregroundStyle(.red)
        .bold()
    }
       
}

#Preview {
    MapView()
}
