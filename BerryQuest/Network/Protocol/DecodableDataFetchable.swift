//
//  DecodableDataFetchable.swift
//  BerryQuest
//
//  Created by 김수경 on 10/27/24.
//

import Foundation
import Combine

protocol DecodableDataFetchable {
    func getData<D: Decodable>(_ request: HTTPRequestable, response: D.Type) -> AnyPublisher<D, Error>
}
