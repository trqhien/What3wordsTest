//
//  ServerError.swift
//  What3WordsTest
//
//  Created by Hien Tran on 21/10/2023.
//

import Codextended
import Moya
import Foundation

struct ServerError: Decodable {
    let statucCode: Int
    let statusMessage: String
    
    init(from decoder: Decoder) throws {
        statucCode = try decoder.decode("status_code")
        statusMessage = try decoder.decode("status_message")
    }
}

enum NetworkError: LocalizedError {
    case serverError(ServerError)
    case moyaError(MoyaError)
    case custom(String)
    case unknown(Error)
    
    /// Localized message for debuggin purposes. Don't show this to user
    var errorDescription: String? {
        switch self {
        case .serverError(let serverError):
            return serverError.statusMessage
        case .moyaError(let moyaError):
            return moyaError.errorDescription
        case .unknown(let error):
            return "Unexpected error: \(error.localizedDescription)"
        case .custom(let message):
            return message
        }
    }

    /// A localized message describing the reason for the failure. Use this to customize error message that is showed to user
    var failureReason: String? {
        switch self {
        case .serverError(let serverError):
            return serverError.statusMessage
        case .custom(let message):
            return message
        default:
            return "An error has occured"
        }
    }
}
