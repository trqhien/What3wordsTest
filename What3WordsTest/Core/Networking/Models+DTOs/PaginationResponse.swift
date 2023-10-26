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
    
    private init(
        page: Int,
        totalPages: Int,
        totalResults: Int,
        results: [M]
    ) {
        self.page = page
        self.totalPages = totalPages
        self.totalResults = totalResults
        self.results = results
    }
}

extension PaginationResponse {
    var isEmpty: Bool {
        return page == 0
            && totalPages == 0
            && totalResults == 0
            && results.isEmpty
    }
    
    static var empty: PaginationResponse {
        return PaginationResponse(
            page: 0,
            totalPages: 0,
            totalResults: 0,
            results: []
        )
    }
}
