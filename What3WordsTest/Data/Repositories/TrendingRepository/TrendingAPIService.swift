//
//  TrendingAPIService.swift
//  What3WordsTest
//
//  Created by Hien Tran on 21/10/2023.
//

import Foundation
import CombineMoya
import Combine

class TrendingAPIService: TrendingAPIServiceType {
    let client = MoyaClient<TrendingAPI>()
    
    private var subscriptions = Set<AnyCancellable>()

    func getTrendingMovie(timeWindow: TimeWindow, page: Int) -> AnyPublisher<PaginationResponse<Movie>, NetworkError> {
        
        return client
            .requestPublisher(.movie(timeWindow: timeWindow, page: page))
            .mapToPagination(Movie.self)
    }
}
