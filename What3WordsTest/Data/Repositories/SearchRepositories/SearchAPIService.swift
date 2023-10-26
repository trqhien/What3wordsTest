//
//  SearchAPIService.swift
//  What3WordsTest
//
//  Created by Hien Tran on 23/10/2023.
//

import Foundation
import CombineMoya
import Combine


struct SearchAPIService: SearchAPIServiceType {
    let client = MoyaClient<SearchAPI>()
    
    func searchMovies(queryString: String, page: Int) -> AnyPublisher<PaginationResponse<Movie>, NetworkError> {
        
        return client
            .requestPublisher(.movie(queryString: queryString, page: page))
            .mapToPagination(Movie.self)
    }
}
