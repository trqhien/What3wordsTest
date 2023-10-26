//
//  Movie.swift
//  What3WordsTest
//
//  Created by Hien Tran on 21/10/2023.
//

import Codextended
import Foundation

struct MovieDTO: Decodable {
    let isAdult: Bool
    let backdropPath: String?
    let id: Int
    let title: String
    let originalTitle: String
    let overview: String
    let posterPath: String?
    let genreIds: [Int]
    let releaseDate: Date?
    let voteAverage: Double
    let voteCount: Int

    init(from decoder: Decoder) throws {
        isAdult = try decoder.decode("adult")
        backdropPath = try decoder.decodeIfPresent("backdrop_path")
        id = try decoder.decode("id")
        title = try decoder.decode("title")
        originalTitle = try decoder.decode("original_title")
        overview = try decoder.decode("overview")
        posterPath = try decoder.decodeIfPresent("poster_path")
        genreIds = try decoder.decode("genre_ids")
        releaseDate = try? decoder.decode("release_date", using: DateFormatter.yyyyMMdd)
        voteAverage = try decoder.decode("vote_average")
        voteCount = try decoder.decode("vote_count")
    }
}
