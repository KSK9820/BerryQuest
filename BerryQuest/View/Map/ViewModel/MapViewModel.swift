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
    
    @Published private (set) var currentLocation: CLLocationCoordinate2D?
    @Published var pokemon: [PokemonDomain]?
    @Published private (set) var draw: Bool = false
    @Published private (set) var shortRoute: [Coordinate]?


    private let networkManager = PokemonNetworkManager(imageDataNetworkService: DataNetworkService(), decodableNetworkService: DecodableNetworkService())
    private var locationManager = LocationManager()
    private var cancellables = Set<AnyCancellable>()

    
    struct Input {
        let onAppear = PassthroughSubject<Void, Never>()
        let onDisappear = PassthroughSubject<Void, Never>()
        let buttonTapped = PassthroughSubject<Void, Never>()
    }
    
    var input = Input()
    
    init() {
        bindLocation()
        bindInputs()
        getPokemonData()
    }
    
    private func bindInputs() {
        input.onAppear
            .sink { [weak self] _ in
                guard let self else { return }
                
                self.draw = true
            }
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
    
    private func bindLocation() {
        locationManager.$currentLocation
            .receive(on: DispatchQueue.main)
            .assign(to: \.currentLocation, on: self)
            .store(in: &cancellables)
    }
    
    private func getPokemonData() {
        networkManager.fetchPokemonData(PokemonRequest.allPokemons, responseType: [PokemonResponse].self)
            .catch { error -> Just<[PokemonResponse]> in
                print(error)
                return Just([])
            }
            .sink(receiveValue: { [weak self] pokemonDomains in
                guard let self else { return }
              
                self.pokemon = pokemonDomains.map { $0.convertToDomain() }
               
                self.getPokemonImageData()
            })
            .store(in: &cancellables)
    }
    
    private func getPokemonImageData() {
        guard let pokemon else { return }
        
        pokemon.enumerated().forEach { offset, element in
            networkManager.fetchImageData(PokemonRequest.pokemonImage(id: String(element.id)))
                .sink { completion in
                    if case .failure(let failure) = completion {
                        print(failure)
                    }
                } receiveValue: { [weak self] pokemonData in
                    guard let self else { return }
                    
                    DispatchQueue.main.async {
                        self.pokemon?[offset].image = pokemonData
                    }
                }
                .store(in: &cancellables)
        }
        
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
