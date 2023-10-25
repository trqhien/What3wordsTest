//
//  CommonHeadersPlugin.swift
//  What3WordsTest
//
//  Created by Hien Tran on 21/10/2023.
//

import Moya
import Foundation

// TODO: Don't store this in code
private let accessToken = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJkYzI1MmY3NDQ0ZDM5ZjM5MTk3OTUyY2YzNmYzMGVlNCIsInN1YiI6IjViMDBiM2U3YzNhMzY4NmM4ZjAwMmIwYyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.NkiPVOk-43c52GWPgcH4z8EMgDRJJUqH7ZP2_mBOOx0"

struct CommonHeadersPlugin: PluginType {
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        var newRequest = request
        
        // TODO: Move headers to env variable
        newRequest.headers.add(name: "Authorization", value: "Bearer \(accessToken)")
        newRequest.headers.add(name: "Content-Type", value: "application/json")
        
        return newRequest
    }
}
