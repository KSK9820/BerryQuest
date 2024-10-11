//
//  MapViewModel.swift
//  BerryQuest
//
//  Created by 김수경 on 10/11/24.
//

import Combine
import CoreLocation

final class MapViewModel: ObservableObject {
    
    @Published private var locationManager = LocationManager()
    
    struct Input {
        let onAppear = PassthroughSubject<Void, Never>()
        let onDisappear = PassthroughSubject<Void, Never>()
    }
    
    var input = Input()
    
    @Published var currentLocation: CLLocationCoordinate2D?
    @Published var pocketmon: [PocketmonDomain]?
    @Published var draw: Bool = false
    
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
            .map { $0.map { $0.convertToDomain() } }
            .sink { value in
                self.pocketmon = value
            }
            .store(in: &cancellables)
        
        input.onDisappear
            .sink { [weak self] _ in
                guard let self else { return }
                
                self.draw = false
            }
            .store(in: &cancellables)
    }
    
}
