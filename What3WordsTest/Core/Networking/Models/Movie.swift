//
//  Movie.swift
//  What3WordsTest
//
//  Created by Hien Tran on 21/10/2023.
//

import Codextended

struct Movie: Decodable {
    let isAdult: Bool
    let backdropPath: String
    let id: Int
    let title: String
//    "original_language": "en",
    let originalTitle: String
    let overview: String
    let posterPath: String
    let mediaType: String
    let genreIds: [Int]
//    "popularity": 579.857,
//    "release_date": "2023-08-23",
//    "video": false,
    let voteAverage: Double
    let voteCount: Int
    
    init(from decoder: Decoder) throws {
        isAdult = try decoder.decode("adult")
        backdropPath = try decoder.decode("backdrop_path")
        id = try decoder.decode("id")
        title = try decoder.decode("title")
//        try decoder.decode("original_language")
        originalTitle = try decoder.decode("original_title")
        overview = try decoder.decode("overview")
        posterPath = try decoder.decode("poster_path")
        mediaType = try decoder.decode("media_type")
        genreIds = try decoder.decode("genre_ids")
//        try decoder.decode("popularity")
//        try decoder.decode("release_date")
//        try decoder.decode("video")
        voteAverage = try decoder.decode("vote_average")
        voteCount = try decoder.decode("vote_count")
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
