//
//  PokemonListContentView.swift
//  BerryQuest
//
//  Created by 김수경 on 10/13/24.
//

import SwiftUI

struct PokemonListContentView: View {
    
    @Binding var pokemon: PocketmonDomain
    
    var body: some View {
        HStack {
            Image(uiImage: UIImage(data: pokemon.imageData) ?? UIImage(systemName: "star")!)
                .resizable()
                .frame(width: 100, height: 100)
                .padding()
            Text(pokemon.name)
                .font(.title2)
        }
        .padding()
    }
}

#Preview {
    PokemonListContentView(pokemon: .constant(PocketmonDomain(id: 1, name: "ss", imageData: Data(), coordinate: Coordinate(latitude: 1.0, longitude: 1.0))))
}
