//
//  DecodableNetworkService.swift
//  BerryQuest
//
//  Created by 김수경 on 10/27/24.
//

import Foundation
import Combine

final class DecodableNetworkService: DecodableDataFetchable {
    
    static let decoder = JSONDecoder()
    private let session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    func getData<D: Decodable>(_ request: HTTPRequestable, response: D.Type) -> AnyPublisher<D, Error> {
        guard let url = request.asURL() else {
            return Fail(error: NetworkError.invalidURL)
                .eraseToAnyPublisher()
        }
        
        return session.dataTaskPublisher(for: url)
            .mapError {
                NetworkError.unknownError(description: $0.localizedDescription)
            }
            .map(\.data)
            .decode(type: D.self, decoder: DecodableNetworkService.decoder)
            .eraseToAnyPublisher()
    }
    
}
