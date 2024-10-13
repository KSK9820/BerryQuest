//
//  PokemonListView.swift
//  BerryQuest
//
//  Created by 김수경 on 10/13/24.
//

import SwiftUI

struct PokemonListView: View {
    
    @Binding var pokemons: [PocketmonDomain]
    
    var body: some View {
        List {
            ForEach($pokemons, id: \.id) { pokemon in
                PokemonListContentView(pokemon: pokemon)
            }
        }
        .listStyle(PlainListStyle())
    }
}

//#Preview {
//    PockemonListView()
//}
