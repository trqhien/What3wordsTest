//
//  SearchAPI.swift
//  What3WordsTest
//
//  Created by Hien Tran on 21/10/2023.
//

import Moya

enum SearchAPI {
    case movie(queryString: String, page: Int)
}

extension SearchAPI: BaseTargetType {
    var path: String {
        switch self {
        case .movie:
            return "/search/movie"
        }
    }
    
    var method: Method {
        switch self {
        case .movie:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .movie(let queryString, let page):
            return .requestParameters(
                parameters: [
                    "query": queryString,
                    "include_adult": false,
                    "page": "\(page)"
                ],
                encoding: URLEncoding.queryString
            )
        }
    }
    
    var cachePolicy: CachePolicy? {
        return .reloadIgnoringLocalCacheData
    }
}
