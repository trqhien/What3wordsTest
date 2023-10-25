//
//  BaseTargetType.swift
//  What3WordsTest
//
//  Created by Hien Tran on 21/10/2023.
//

import Moya
import Foundation

protocol BaseTargetType: CacheableTargetType {}

extension BaseTargetType {
    var baseURL: URL {
        // TODO: Use environment flag to set up different schemes
        // TODO: Move base url to env variable
        guard let url = URL(string: "https://api.themoviedb.org/3") else {
            preconditionFailure("Missing base URL in \(String(describing: self))")
        }
        return url
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    var cachePolicy: CachePolicy? {
        return nil
    }
}
