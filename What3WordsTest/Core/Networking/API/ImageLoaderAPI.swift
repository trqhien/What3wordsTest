//
//  ImageLoaderAPI.swift
//  What3WordsTest
//
//  Created by Hien Tran on 25/10/2023.
//

import Foundation
import Moya

enum ImageSize: String {
    case w92
    case w154
    case w185
    case w342
    case w500
    case w780
    case original
}

enum ImageLoaderAPI {
    case loadImage(imagePath: String, size: ImageSize)
}

extension ImageLoaderAPI: BaseTargetType {
    var baseURL: URL {
        guard let url = URL(string: "https://image.tmdb.org/t/p") else {
            preconditionFailure("Missing base URL in \(String(describing: self))")
        }
        return url
    }
    
    var path: String {
        switch self {
        case let .loadImage(path, size):
            return "/\(size.rawValue)\(path)"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var task: Moya.Task {
        return .requestPlain
    }
}
