//
//  MovieDetailsEntity.swift
//  What3WordsTest
//
//  Created by Hien Tran on 26/10/2023.
//

import Foundation
import Combine
import UIKit
import Resolver
import Kingfisher

struct MovieDetailsEntity {
    let id: Int
    let genres: [Genre]
    let voteCount: Int
    let voteAverage: Double
    let title: String
    let originalTitle: String
    let isAdult: Bool
    let overview: String
    let releaseDate: Date?
    let status: String?
    let homepage: String?
    let tagline: String?
    let backdrop: URL?
    let poster: URL?
    
    init(from dto: MovieDetails) {
        self.id = dto.id
        self.genres = dto.genres
        self.voteCount = dto.voteCount
        self.voteAverage = dto.voteAverage
        self.title = dto.title
        self.originalTitle = dto.originalTitle
        self.isAdult = dto.isAdult
        self.overview = dto.overview
        self.releaseDate = dto.releaseDate
        self.status = dto.status
        self.homepage = dto.homepage
        self.tagline = dto.tagline
        self.backdrop = dto.backdropPath != nil
            ? URL(target: ImageLoaderAPI.loadImage(imagePath: dto.backdropPath!, size: .original))
            : nil
        self.poster = dto.posterPath != nil
            ? URL(target: ImageLoaderAPI.loadImage(imagePath: dto.posterPath!, size: .original))
            : nil
    }
}

extension MovieDetailsEntity: Hashable {
    static func == (lhs: MovieDetailsEntity, rhs: MovieDetailsEntity) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
