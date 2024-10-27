//
//  RawDataFetchable.swift
//  BerryQuest
//
//  Created by 김수경 on 10/27/24.
//

import Foundation
import Combine

protocol RawDataFetchable {
    func getData(_ request: HTTPRequestable) -> AnyPublisher<Data, Error>
}
