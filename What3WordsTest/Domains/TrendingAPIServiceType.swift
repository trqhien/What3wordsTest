//
//  TrendingAPIServiceType.swift
//  What3WordsTest
//
//  Created by Hien Tran on 21/10/2023.
//

import Combine

protocol TrendingAPIServiceType {
    func getTrendingMovie(timeWindow: TimeWindow, page: Int) -> AnyPublisher<PaginationResponse<Movie>, NetworkError>
}
