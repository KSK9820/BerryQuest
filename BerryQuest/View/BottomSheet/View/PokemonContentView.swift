//
//  PokemonListContentView.swift
//  BerryQuest
//
//  Created by 김수경 on 10/14/24.
//

import SwiftUI

struct PokemonListContentView: View {
    
    @Binding var pokemon: PokemonDomain
    
    var body: some View {
        HStack {
            Image(uiImage: UIImage(data: pokemon.imageData) ?? UIImage(systemName: "star")!)
                .resizable()
                .frame(width: ContentSize.thumbImage.size.width, height: ContentSize.thumbImage.size.height)
                .padding()
            Text(pokemon.name)
                .font(.title2)
        }
        .padding()
    }
}
