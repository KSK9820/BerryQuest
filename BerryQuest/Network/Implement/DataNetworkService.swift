//
//  DataNetworkService.swift
//  BerryQuest
//
//  Created by 김수경 on 10/27/24.
//

import Foundation
import Combine

final class DataNetworkService: RawDataFetchable {
    
    private let session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
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
