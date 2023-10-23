//
//  AnyPublisher+Response+Ext.swift
//  What3WordsTest
//
//  Created by Hien Tran on 21/10/2023.
//

import Combine
import Moya
import Foundation

extension AnyPublisher where Output == Response, Failure == MoyaError {
    func mapToPagination<D: Decodable>(_ type: D.Type) -> AnyPublisher<PaginationResponse<D>, NetworkError> {
        return self
            .map(PaginationResponse<D>.self)
            .eraseToAnyPublisher()
            .mapError {  NetworkError.moyaError($0) }
            .eraseToAnyPublisher()
    }
}

