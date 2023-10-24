//
//  App+Inject.swift
//  What3WordsTest
//
//  Created by Hien Tran on 21/10/2023.
//

import Foundation
import Resolver

extension Resolver: ResolverRegistering {
      public static func registerAllServices() {
          register { MovieListViewModel() }
          register { MovieDetailsViewModel() }
          register { TrendingAPIService() }.implements(TrendingAPIServiceType.self)
          register { SearchAPIService() }.implements(SearchAPIServiceType.self)
          register { MoviesAPIService() }.implements(MoviesAPIServiceType.self)
      }
}
