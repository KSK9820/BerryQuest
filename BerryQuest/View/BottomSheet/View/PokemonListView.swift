//
//  PokemonListView.swift
//  BerryQuest
//
//  Created by 김수경 on 10/14/24.
//

import SwiftUI

struct PokemonListView: View {
    
    @Binding var pokemons: [PokemonDomain]
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(pokemons.indices, id: \.self) { index in
                    NavigationLink {
                        NavigationLazyView(PokemonDetailView(id: pokemons[index].id))
                    } label : {
                        PokemonListContentView(pokemon: $pokemons[index])
                    }
                }                
            }
            .listStyle(PlainListStyle())
        }
    }
}
