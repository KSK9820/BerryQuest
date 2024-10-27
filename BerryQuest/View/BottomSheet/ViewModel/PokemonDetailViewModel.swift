//
//  PokemonDetailViewModel.swift
//  BerryQuest
//
//  Created by 김수경 on 10/14/24.
//

import Foundation
import Combine

final class PokemonDetailViewModel: ObservableObject {
    
    @Published var pokemon: PokemonInformationDomain?
    @Published var pokemonImage: Data?
    
    private let networkManager = PokemonNetworkManager(imageDataNetworkService: DataNetworkService(), decodableNetworkService: DecodableNetworkService())
    private var pokemonId: Int
    private var cancellables = Set<AnyCancellable>()
    
    struct Input {
        let viewOnTask = PassthroughSubject<Void, Never>()
        
    }
    
    var input = Input()
    
    
    init(pokemonId: Int) {
        self.pokemonId = pokemonId
        
        input.viewOnTask
            .sink { [weak self] _ in
                guard let self else { return }
                
                self.getPokemonInformation()
                self.getPokemonImage()
            }
            .store(in: &cancellables)
    }
    
    private func getPokemonInformation() {
        networkManager.fetchPokemonData(PokemonRequest.pokemon(id: String(pokemonId)), responseType: PokemonInformationResponse.self)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let failure) = completion {
                        print(failure)
                    }
                }, receiveValue: { [weak self] value in
                    guard let self else { return }
                    
                    self.pokemon = value.converToDomain()
                }
            )
            .store(in: &cancellables)
    }
    
    private func getPokemonImage() {
        networkManager.fetchImageData(PokemonRequest.pokemonImage(id: String(pokemonId)))
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let failure) = completion {
                        print(failure)
                    }
                }, receiveValue: { [weak self] value in
                    guard let self else { return }
                    
                    self.pokemonImage = value
                }
            )
            .store(in: &cancellables)
    }
    
}
