//
//  PaginationResponse.swift
//  What3WordsTest
//
//  Created by Hien Tran on 21/10/2023.
//

import Codextended

struct PaginationResponse<M: Decodable>: Decodable {
    let page: Int
    let totalPages: Int
    let totalResults: Int
    let results: [M]
    
    init(from decoder: Decoder) throws {
        page = try decoder.decode("page")
        totalPages = try decoder.decode("total_pages")
        totalResults = try decoder.decode("total_results")
        results = try decoder.decode("results")
    }
}
