//
//  TrendingAPI.swift
//  What3WordsTest
//
//  Created by Hien Tran on 21/10/2023.
//

import Moya

enum TrendingAPI {
    case movie(timeWindow: TimeWindow, page: Int)
}

enum TimeWindow: String {
    case day
    case week
}

extension TrendingAPI: BaseTargetType {
    var path: String {
        switch self {
        case .movie(let timeWindow, _):
            return "/trending/movie/\(timeWindow)"
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
        case .movie(_, let page):
            return .requestParameters(
                parameters: [
                    "language": "en-US",
                    "page": page
                ],
                encoding: URLEncoding.queryString
            )
        }
    }
}
