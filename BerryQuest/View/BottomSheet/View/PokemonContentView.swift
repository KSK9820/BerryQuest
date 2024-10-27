//
//  PokemonListContentView.swift
//  BerryQuest
//
//  Created by 김수경 on 10/14/24.
//

import SwiftUI

struct PokemonListContentView: View {
    
    @ObservedObject var viewModel: PokemonListViewModel
    
    var body: some View {
        HStack {
            if let image = viewModel.pokemon.image,
                let pokemonImage = UIImage(data: image) {
                Image(uiImage: pokemonImage)
                    .resizable()
                    .frame(width: ContentSize.thumbImage.size.width, height: ContentSize.thumbImage.size.height)
                    .padding()
            } else {
                ProgressView()
                    .frame(width: ContentSize.thumbImage.size.width, height: ContentSize.thumbImage.size.height)
                    .padding()
            }
            Text(viewModel.pokemon.name)
                .font(.title2)
        }
        .padding()
        .task {
            if viewModel.pokemon.image == nil {
                viewModel.input.viewOnTask.send(())
            }
        }
    }
    
}
