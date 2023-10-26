//
//  SearchAPIServiceType.swift
//  What3WordsTest
//
//  Created by Hien Tran on 23/10/2023.
//

import Foundation
import Combine

protocol SearchAPIServiceType {
    func searchMovies(queryString: String, page: Int) -> AnyPublisher<PaginationResponse<MovieDTO>, NetworkError>
}
