//
//  CachePolicyPlugin.swift
//  What3WordsTest
//
//  Created by Hien Tran on 25/10/2023.
//

import Moya
import Foundation

typealias CachePolicy = URLRequest.CachePolicy

protocol CacheableTargetType: TargetType {
    /// URLRequest cache policy
    /// - `useProtocolCachePolicy`: Use the caching logic defined in the protocol implementation, if any, for a particular URL load request.
    /// -`reloadIgnoringLocalCacheData`: The URL load should be loaded only from the originating source.
    /// - `reloadIgnoringLocalAndRemoteCacheData`: Ignore local cache data, and instruct proxies and other intermediates to disregard their caches so far as the protocol allows.
    /// - `reloadIgnoringLocalCacheData`: The URL load should be loaded only from the originating source.
    /// - `returnCacheDataElseLoad`: Use existing cache data, regardless or age or expiration date, loading from originating source only if there is no cached data.
    /// - `returnCacheDataDontLoad`: Use existing cache data, regardless or age or expiration date, and fail if no cached data is available.
    /// `reloadRevalidatingCacheData`: Use cache data if it can be validated by the origin source; otherwise, load from the origin.
    var cachePolicy: CachePolicy? { get }
}

struct CachePolicyPlugin: PluginType {
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        guard
            let cacheableTarget = target as? CacheableTargetType,
            let policy = cacheableTarget.cachePolicy
        else {
            return request
        }

        var mutableRequest = request
        mutableRequest.cachePolicy = policy

        return mutableRequest
    }
}

