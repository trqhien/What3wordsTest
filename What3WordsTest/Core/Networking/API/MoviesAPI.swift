//
//  MoviesAPI.swift
//  What3WordsTest
//
//  Created by Hien Tran on 24/10/2023.
//

import Moya

enum MoviesAPI {
    case details(id: Int)
}

extension MoviesAPI: BaseTargetType {
    var path: String {
        switch self {
        case .details(let id):
            return "/movie/\(id)"
        }
    }
    
    var method: Method {
        switch self {
        case .details:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .details:
            return .requestPlain
        }
    }
    
    var cachePolicy: CachePolicy? {
        return .returnCacheDataElseLoad
    }
}



