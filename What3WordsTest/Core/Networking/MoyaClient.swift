//
//  MoyaClient.swift
//  What3WordsTest
//
//  Created by Hien Tran on 21/10/2023.
//

import Moya

final class MoyaClient<T: BaseTargetType>: MoyaProvider<T> {
    // TODO: COnfigure cache https://github.com/Moya/Moya/issues/976
    
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
