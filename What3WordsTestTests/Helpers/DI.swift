//
//  DI.swift
//  What3WordsTestTests
//
//  Created by Hien Tran on 26/10/2023.
//

import Resolver
@testable import What3WordsTest

extension Resolver {
    static var mock = Resolver(child: .main)
    
    static func registerMockServices() {
        root = Resolver.mock
        defaultScope = .application
        
        mock.register { trendingMockService }.implements(TrendingAPIServiceType.self)
    }
}
