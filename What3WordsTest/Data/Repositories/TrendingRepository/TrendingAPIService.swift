//
//  TrendingAPIService.swift
//  What3WordsTest
//
//  Created by Hien Tran on 21/10/2023.
//

import Foundation
import CombineMoya
import Combine

struct TrendingAPIService: TrendingAPIServiceType {
    let client = MoyaClient<TrendingAPI>()

    func getTrendingMovie(timeWindow: TimeWindow, page: Int) -> AnyPublisher<PaginationResponse<Movie>, NetworkError> {
        
        return client
            .requestPublisher(.movie(timeWindow: timeWindow, page: page))
            .mapToPagination(Movie.self)
    }
}
