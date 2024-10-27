//
//  PokemonListViewModel.swift
//  BerryQuest
//
//  Created by 김수경 on 10/27/24.
//

import Foundation
import SwiftUI
import Combine

final class PokemonListViewModel: ObservableObject {
    
    @Binding private(set) var pokemon: PokemonDomain
    
    private let networkManager = PokemonNetworkManager(imageDataNetworkService: DataNetworkService(), decodableNetworkService: DecodableNetworkService())
    private var cancellables = Set<AnyCancellable>()
    
    struct Input {
        let viewOnTask = PassthroughSubject<Void, Never>()
    }
    
    var input = Input()
    
    init(pokemon: Binding<PokemonDomain>) {
        self._pokemon = pokemon
        setBinding()
    }
    
    private func setBinding() {
        input.viewOnTask
            .sink { [weak self] _ in
                guard let self else { return }
                
                self.getPokemonImage()
            }
            .store(in: &cancellables)
    }
    
    private func getPokemonImage() {
        networkManager.fetchImageData(PokemonRequest.pokemonImage(id: String(pokemon.id)))
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let failure) = completion {
                        print(failure)
                    }
                }, receiveValue: { [weak self] value in
                    guard let self else { return }
                    
                    self.pokemon.image = value
                }
            )
            .store(in: &cancellables)
    }
    
}
