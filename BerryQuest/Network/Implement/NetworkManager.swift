//
//  NetworkManager.swift
//  BerryQuest
//
//  Created by 김수경 on 10/9/24.
//

import Foundation
import Combine

final class NetworkManager {
    
    static let shared = NetworkManager()
    static let decoder = JSONDecoder()
    
    private let session: URLSession
    private var cancellables = Set<AnyCancellable>()
    
    private init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
}

extension NetworkManager {
     
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
            .decode(type: D.self, decoder: NetworkManager.decoder)
            .eraseToAnyPublisher()
    }
    
    func getData(_ request: HTTPRequestable) -> AnyPublisher<Data, Error> {
        guard let url = request.asURL() else {
            return Fail(error: NetworkError.invalidURL)
                .eraseToAnyPublisher()
        }
        
        return session.dataTaskPublisher(for: url)
            .mapError {
                NetworkError.unknownError(description: $0.localizedDescription)
            }
            .map(\.data)
            .eraseToAnyPublisher()
    }
}
