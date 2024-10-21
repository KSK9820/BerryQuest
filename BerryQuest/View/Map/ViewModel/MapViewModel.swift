//
//  MapViewModel.swift
//  BerryQuest
//
//  Created by 김수경 on 10/11/24.
//

import Combine
import CoreLocation
import SwiftUI

final class MapViewModel: ObservableObject {
    
    private var locationManager = LocationManager()
    
    struct Input {
        let onAppear = PassthroughSubject<Void, Never>()
        let onDisappear = PassthroughSubject<Void, Never>()
        let buttonTapped = PassthroughSubject<Void, Never>()
    }
    
    var input = Input()
    
    @Published private (set) var currentLocation: CLLocationCoordinate2D?
    @Published var pokemon: [PokemonDomain]?
    @Published private (set) var draw: Bool = false
    @Published private (set) var shortRoute: [Coordinate]?
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        locationManager.$currentLocation
            .receive(on: DispatchQueue.main)
            .assign(to: \.currentLocation, on: self)
            .store(in: &cancellables)
        
        input.onAppear
            .sink { [weak self] _ in
                guard let self else { return }
                
                self.draw = true
            }
            .store(in: &cancellables)
        
        NetworkManager.shared
            .getData(PokemonRequest.allPokemons, response: [PokemonResponse].self)
            .catch { error -> Just<[PokemonResponse]> in
                print(error)
                return Just([])
            }
            .flatMap { pokemonResponses -> AnyPublisher<[PokemonDomain], Error> in
                let publishers = pokemonResponses.map { response in
                    response.convertToDomain()
                }
                
                return Publishers.MergeMany(publishers)
                    .collect()
                    .eraseToAnyPublisher()
            }
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let failure) = completion {
                        print(failure)
                    }
                }, receiveValue: { [weak self] pokemonDomains in
                    guard let self else { return }
                    
                    self.pokemon = pokemonDomains
                }
            )
            .store(in: &cancellables)
        
        input.onDisappear
            .sink { [weak self] _ in
                guard let self else { return }
                
                self.draw = false
            }
            .store(in: &cancellables)
        
        input.buttonTapped
            .sink { [weak self] _ in
                guard let self else { return }
                
                if let pokemon = self.pokemon {
                    self.getShortRoute(pokemon.map { $0.coordinate })
                }
            }
            .store(in: &cancellables)
    }
    
    private func getShortRoute(_ coordinate: [Coordinate]) {
        guard let currentLocation,
              let pokemon else { return }
        
        let locations = [currentLocation.convertToCoordinate()] + pokemon.map { $0.coordinate }
        let sortedIndex = RouteSearchManager(coordinates: locations).getShortestPathWithTSP()
        
        let sortedCoords = sortedIndex.map { locations[$0] }
        var sortedPokemon = [PokemonDomain]()
        
        for i in 1..<sortedIndex.count {
            sortedPokemon.append(pokemon[sortedIndex[i]-1])
        }
        
        self.shortRoute = sortedCoords
        self.pokemon = sortedPokemon
    }
    
}
