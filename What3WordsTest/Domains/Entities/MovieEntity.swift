//
//  MovieEntity.swift
//  What3WordsTest
//
//  Created by Hien Tran on 25/10/2023.
//

import Foundation
import Combine
import UIKit
import Resolver

struct MovieEntity {
    let isAdult: Bool
    let id: Int
    let title: String
    let originalTitle: String
    let overview: String
    let genreIds: [Int]
    let releaseDate: Date?
    let voteAverage: Double
    let voteCount: Int
    let backdrop: URL?
    let poster: URL?
    
    init(from dto: Movie) {
        self.isAdult = dto.isAdult
        self.backdrop = dto.backdropPath != nil
            ? URL(target: ImageLoaderAPI.loadImage(imagePath: dto.backdropPath!, size: .w154))
            : nil
        self.id = dto.id
        self.title = dto.title
        self.originalTitle = dto.originalTitle
        self.overview = dto.overview
        self.genreIds = dto.genreIds
        self.releaseDate = dto.releaseDate
        self.voteAverage = dto.voteAverage
        self.voteCount = dto.voteCount
        self.poster = dto.posterPath != nil
            ? URL(target: ImageLoaderAPI.loadImage(imagePath: dto.posterPath!, size: .w154))
            : nil
    }
}

extension MovieEntity: Hashable {
    static func == (lhs: MovieEntity, rhs: MovieEntity) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
