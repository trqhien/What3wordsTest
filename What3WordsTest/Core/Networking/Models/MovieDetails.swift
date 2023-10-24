//
//  MovieDetails.swift
//  What3WordsTest
//
//  Created by Hien Tran on 24/10/2023.
//

import Codextended
import Foundation

struct MovieDetails: Decodable {
    let id: Int
    let backdropPath: String?
    let genres: [Genre]
    let voteCount: Int
    let voteAverage: Double
    let title: String
    let posterPath: String?
    let originalTitle: String
    let isAdult: Bool
    let overview: String
    let releaseDate: Date?
    let status: String?
    let homepage: String?
    let tagline: String?


    init(from decoder: Decoder) throws {
        id = try decoder.decode("id")
        backdropPath = try? decoder.decodeIfPresent("backdrop_path")
        genres = (try? decoder.decodeIfPresent("genres")) ?? []
        homepage = try? decoder.decodeIfPresent("homepage")
        originalTitle = try decoder.decode("original_title")
        title = try decoder.decode("title")
        overview = try decoder.decode("overview")
        posterPath = try? decoder.decodeIfPresent("poster_path")
        releaseDate = try? decoder.decode("release_date", using: DateFormatter.yyyyMMdd)
        status = try decoder.decodeIfPresent("status")
        tagline = try decoder.decodeIfPresent("tagline")
        voteCount = try decoder.decode("vote_count")
        voteAverage = try decoder.decode("vote_average")
        isAdult = try decoder.decode("adult")
    }
}

extension MovieDetails: Hashable {
    static func == (lhs: MovieDetails, rhs: MovieDetails) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
