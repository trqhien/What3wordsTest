//
//  Genre.swift
//  What3WordsTest
//
//  Created by Hien Tran on 25/10/2023.
//

import Foundation
import Codextended

struct Genre: Codable {
    let id: Int
    let name: String

    init(from decoder: Decoder) throws {
        id = try decoder.decode("id")
        name = try decoder.decode("name")
    }
}

extension Genre: Hashable {
    static func == (lhs: Genre, rhs: Genre) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
