//
//  PokemonDetailView.swift
//  BerryQuest
//
//  Created by 김수경 on 10/14/24.
//

import SwiftUI

struct PokemonDetailView: View {
    
    @ObservedObject private var viewModel: PokemonDetailViewModel
    
    init(id: Int) {
        viewModel = PokemonDetailViewModel(pokemonId: id)
    }
    
    var body: some View {
        VStack {
            if let pokemon = viewModel.pokemon {
                VStack(alignment: .leading, spacing: 10) {
                    
                    HStack(alignment: .center) {
                        Spacer()
                        if let image = viewModel.pokemonImage,
                           let pokemonImage = UIImage(data: image) {
                            Image(uiImage: pokemonImage)
                                .resizable()
                                .frame(width: ContentSize.thumbImage.size.width, height: ContentSize.thumbImage.size.height)
                        } else {
                            ProgressView()
                                .frame(width: ContentSize.thumbImage.size.width, height: ContentSize.thumbImage.size.height)
                        }
                        Spacer()
                    }
                    .padding(.vertical)
                    
                    Text(pokemon.name)
                        .font(.title3)
                        .padding(.vertical)
                    Text("위도: \(pokemon.coordinate.latitude), 경도: \(pokemon.coordinate.longitude)")
                    Text("병명: \(pokemon.disease)")
                    Text("열매: \(pokemon.berry)")
                    Spacer()
                }
                .padding(.horizontal)
                
            } else {
                ProgressView("Loading...")
            }
        }
        .navigationTitle("상세")
        .task {
            viewModel.input.viewOnTask.send(())
        }
    }
}
