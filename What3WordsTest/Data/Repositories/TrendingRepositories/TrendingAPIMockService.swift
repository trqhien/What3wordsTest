//
//  TrendingAPIMockService.swift
//  What3WordsTest
//
//  Created by Hien Tran on 25/10/2023.
//

import Foundation
import Combine
import Codextended
import Moya

struct TrendingAPIMockService: TrendingAPIServiceType {
    
//    let values = PassthroughSubject<PaginationResponse<Movie>, NetworkError>()
    
    func getTrendingMovie(timeWindow: TimeWindow, page: Int) -> AnyPublisher<PaginationResponse<Movie>, NetworkError> {
        
        
        let dictionary: [String: Any] = [
            "name": "John Doe",
            "age": 30,
            "email": "john.doe@example.com"
        ]
        
        let jsonData = try! JSONSerialization.data(withJSONObject: dictionary, options: [])
        
        do {
            let movie = try jsonData.decoded() as Movie
        } catch (let err) {
            let res = Response(statusCode: 1, data: Data())
            let errorPublisher = Result<PaginationResponse<Movie>, NetworkError>.Publisher(NetworkError.moyaError(MoyaError.encodableMapping(err)))
            return errorPublisher.eraseToAnyPublisher()
        }
        
        
        
//        let res = Response(statusCode: 1, data: Data())
        let publisher = Result<PaginationResponse<Movie>, NetworkError>.Publisher(.success(.empty))
        return publisher.eraseToAnyPublisher()
//        return Just(PaginationResponse.empty).eraseToAnyPublisher()
    }
}
