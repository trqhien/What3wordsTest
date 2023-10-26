//
//  MovieDto.swift
//  What3WordsTest
//
//  Created by Hien Tran on 25/10/2023.
//

import Foundation
import Combine
import UIKit
import Resolver
import Kingfisher

struct Movie {
    let isAdult: Bool
    let id: Int
    let title: String
    let originalTitle: String
    let overview: String
    let genreIds: [Int]
    let releaseDate: Date?
    let voteAverage: Double
    let voteCount: Int
    
    let backdrop: AnyPublisher<KF.Builder?, Never>
    let poster: AnyPublisher<KF.Builder?, Never>
    
    init(from dto: MovieDTO) {
        self.init(
            isAdult: dto.isAdult,
            backdrop: dto.backdropPath != nil
                ? ImageLoaderService().loadImage(from: dto.backdropPath!, size: .original)
                : .just(nil),
            id: dto.id,
            title: dto.title,
            originalTitle: dto.originalTitle,
            overview: dto.overview,
            genreIds: dto.genreIds,
            releaseDate: dto.releaseDate,
            voteAverage: dto.voteAverage,
            voteCount: dto.voteCount,
            poster: dto.posterPath != nil
                ? ImageLoaderService().loadImage(from: dto.posterPath!, size: .original)
                : .just(nil))
    }
    
    init(
        isAdult: Bool,
        backdrop: AnyPublisher<KF.Builder?, Never>,
        id: Int,
        title: String,
        originalTitle: String,
        overview: String,
        genreIds: [Int],
        releaseDate: Date?,
        voteAverage: Double,
        voteCount: Int,
        poster: AnyPublisher<KF.Builder?, Never>
    ) {
        self.isAdult = isAdult
        self.backdrop = backdrop
        self.id = id
        self.title = title
        self.originalTitle = originalTitle
        self.overview = overview
        self.genreIds = genreIds
        self.releaseDate = releaseDate
        self.voteAverage = voteAverage
        self.voteCount = voteCount
        self.poster = poster
    }
}

extension Movie: Hashable {
    static func == (lhs: Movie, rhs: Movie) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
