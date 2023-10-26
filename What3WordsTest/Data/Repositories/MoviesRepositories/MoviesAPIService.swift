//
//  MoviesAPIService.swift
//  What3WordsTest
//
//  Created by Hien Tran on 24/10/2023.
//

import Foundation
import CombineMoya
import Combine

struct MoviesAPIService: MoviesAPIServiceType {
    let client = MoyaClient<MoviesAPI>()
    
    func getMovieDetails(id: Int) -> AnyPublisher<MovieDetailsEntity, NetworkError> {
        return client
            .requestPublisher(.details(id: id))
            .map(MovieDetails.self)
            .map { MovieDetailsEntity(from: $0) }
            .mapError {  NetworkError.moyaError($0) }
            .eraseToAnyPublisher()
    }
}
