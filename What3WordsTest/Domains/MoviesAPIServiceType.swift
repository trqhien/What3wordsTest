//
//  MoviesAPIServiceType.swift
//  What3WordsTest
//
//  Created by Hien Tran on 24/10/2023.
//

import Foundation
import Combine

protocol MoviesAPIServiceType {
    func getMovieDetails(id: Int) -> AnyPublisher<MovieDetails, NetworkError>
}
