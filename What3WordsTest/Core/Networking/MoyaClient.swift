//
//  MoyaClient.swift
//  What3WordsTest
//
//  Created by Hien Tran on 21/10/2023.
//

import Moya

final class MoyaClient<T: BaseTargetType>: MoyaProvider<T> {
    init() {
        super.init(
            plugins: [
                CommonHeadersPlugin(),
                CachePolicyPlugin()
//                NetworkLoggerPlugin()
            ]
        )
    }
}
