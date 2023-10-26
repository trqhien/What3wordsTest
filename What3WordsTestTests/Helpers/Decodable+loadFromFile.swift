//
//  Decodable+loadFromFile.swift
//  What3WordsTestTests
//
//  Created by Hien Tran on 26/10/2023.
//

import Foundation
import XCTest
@testable import What3WordsTest

class TestBundle {}

extension Decodable {
    static func loadFromFile(_ fileName: String) -> Self {
        guard let url = Bundle(for: TestBundle.self).url(forResource: fileName, withExtension: "json") else {
            fatalError("File not found")
        }
        
        do {
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode(Self.self, from: data)
        } catch {
            fatalError("Error: \(error)")
        }
    }
}
