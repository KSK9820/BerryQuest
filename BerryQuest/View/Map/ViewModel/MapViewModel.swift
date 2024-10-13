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
    
    @Published var currentLocation: CLLocationCoordinate2D?
    @Published var pocketmon: [PocketmonDomain]?
    @Published var draw: Bool = false
    @Published var shortRoute: [Coordinate]?
    
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
            .getData(PocketmonRequest.allPocketmons, response: [PocketmonResponse].self)
            .receive(on: DispatchQueue.main)
            .catch { error -> Just<[PocketmonResponse]> in
                print(error)
                return Just([])
            }
            .flatMap { pocketmonResponses -> AnyPublisher<[PocketmonDomain], Error> in
                let publishers = pocketmonResponses.map { response in
                    response.convertToDomain()
                }
                
                return Publishers.MergeMany(publishers)
                    .collect()
                    .eraseToAnyPublisher()
            }
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let failure) = completion {
                        print(failure)
                    }
                }, receiveValue: { [weak self] pocketmonDomains in
                    guard let self else { return }
                    
                    self.pocketmon = pocketmonDomains
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
                
                if let pokemon = self.pocketmon {
                    self.getShortRoute(pokemon.map { $0.coordinate })
                }
            }
            .store(in: &cancellables)
    }
    
    private func getShortRoute(_ coordinate: [Coordinate]) {
        guard let currentLocation,
              let pocketmon else { return }
        
        let locations = [currentLocation.convertToCoordinate()] + pocketmon.map { $0.coordinate }
        let sortedIndex = RouteSearchManager(coordinates: locations).getShortestPathWithTSP()
        
        let sortedCoords = sortedIndex.map { locations[$0] }
        var sortedPokemon = [PocketmonDomain]()
        
        for i in 1..<sortedIndex.count {
            sortedPokemon.append(pocketmon[sortedIndex[i]-1])
        }
        
        self.shortRoute = sortedCoords
        self.pocketmon = sortedPokemon
    }
    
}
