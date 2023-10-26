//
//  ImageLoaderService.swift
//  What3WordsTest
//
//  Created by Hien Tran on 25/10/2023.
//

import Foundation
import CombineMoya
import Combine
import UIKit
import Resolver
import Kingfisher

struct ImageLoaderService: ImageLoaderServiceType {
//    private let client = MoyaClient<ImageLoaderAPI>()
//    private let cache = ImageCacheService()

    func loadImage(from path: String, size: ImageSize) -> AnyPublisher<KF.Builder?, Never> {
        let url = URL(target: ImageLoaderAPI.loadImage(imagePath: path, size: size))
        
        return .just(
            KF.url(url)
              .cacheOriginalImage()
              .fade(duration: 0.25)
        )
        
//        let url = ImageLoaderAPI.loadImage(imagePath: path, size: size).
//        if let image = cache.image(for: cacheKey) {
//            return .just(image)
//        }
//
//        return client
//            .requestPublisher(.loadImage(imagePath: path, size: size))
//            .map { UIImage(data: $0.data ) }
//            .replaceError(with: nil)
//            .handleEvents(receiveOutput: { image in
//                guard let image = image else { return }
//                self.cache.insertImage(image, for: cacheKey)
//            })
//            .eraseToAnyPublisher()
    }
}
