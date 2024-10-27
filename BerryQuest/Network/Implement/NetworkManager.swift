//
//  NetworkManager.swift
//  BerryQuest
//
//  Created by 김수경 on 10/9/24.
//

import Foundation
import Combine

final class PokemonNetworkManager {
    
    // 구체적인 구현 클래스(DataNetworkService, DecodableNetworkService)에 의존하지 않고,
    // 추상화된 프로토콜(RawDataFetchable, DecodableNetworkService)에 의존하도록 설계
    // 고수준 모듈은 저수준 모듈에 의존해서는 안된다 DIP의 원칙을 따름
    private let imageDataNetworkService: RawDataFetchable
    private let decodableNetworkService: DecodableDataFetchable
    
    init(imageDataNetworkService: RawDataFetchable, decodableNetworkService: DecodableDataFetchable) {
        self.imageDataNetworkService = imageDataNetworkService
        self.decodableNetworkService = decodableNetworkService
    }
    
    func fetchPokemonData<D: Decodable>(_ request: HTTPRequestable, responseType: D.Type) -> AnyPublisher<D, Error> {
        return decodableNetworkService.getData(request, response: responseType)
    }
    
    func fetchImageData(_ request: HTTPRequestable) -> AnyPublisher<Data, Error> {
        return imageDataNetworkService.getData(request)
    }
    
}
