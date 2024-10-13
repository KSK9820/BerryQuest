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
    }
    
    var input = Input()
    
    @Published var currentLocation: CLLocationCoordinate2D?
    @Published var pocketmon: [PocketmonDomain]?
    @Published var draw: Bool = false
    @Published var shortRoute: [Edge] = []
    
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
//                    self.getShortRoute(pocketmonDomains.map { $0.coordinate })
                }
            )
            .store(in: &cancellables)

        input.onDisappear
            .sink { [weak self] _ in
                guard let self else { return }
                
                self.draw = false
            }
            .store(in: &cancellables)
    }
    
//    private func getShortRoute(_ coordinate: [Coordinate]) {
//        guard let currentLocation = locationManager.currentLocation else { return }
//        
//        let coord = [currentLocation.convertToCoordinate()] + coordinate
//        let a = RouteSearchManager(coordinates: coord).getShortestPathWithTSP()
//    }
    
}
