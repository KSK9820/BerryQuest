//
//  NetworkError.swift
//  BerryQuest
//
//  Created by 김수경 on 10/9/24.
//

import Foundation

enum NetworkError: Error, CustomStringConvertible {
    case notFoundBaseURL
    case invalidURL
    case unknownError(description: String)
    case responseError(statusCode: Int)
    case emptyDataError
}

extension NetworkError {
    
    var description: String {
        switch self {
        case .notFoundBaseURL:
            return "BaseURL이 존재하지 않습니다."
        case .invalidURL:
            return "유효하지 않은 URL입니다."
        case .unknownError(let description):
            return "\(description)"
        case .responseError(let statusCode):
            return "Response Error: \(statusCode)"
        case .emptyDataError:
            return "서버에 해당 데이터가 존재하지 않아 데이터를 불러오지 못했습니다."
        }
    }
    
}
