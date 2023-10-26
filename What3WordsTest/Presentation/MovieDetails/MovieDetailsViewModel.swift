//
//  MovieDetailsViewModel.swift
//  What3WordsTest
//
//  Created by Hien Tran on 24/10/2023.
//

import Resolver
import Combine
import CombineExt
import UIKit

final class MovieDetailsViewModel {
    @LazyInjected private var moviesAPIService: MoviesAPIServiceType
    
    @Published var loadingState: LoadingState = .pristine
    
    private var subscriptions = Set<AnyCancellable>()
    
    func bind(loadOnAppear: AnyPublisher<Int, Never>) {
        let startLoading = loadOnAppear.share()
        
        let loaded = startLoading
            .map { self.moviesAPIService.getMovieDetails(id: $0) }
            .switchToLatest()
            .mapToResult()
            .share()
        
        startLoading
            .map { _ in LoadingState.loading }
            .merge(with: loaded
                .map { details in LoadingState.loaded(details) }
                .delay(for: .seconds(0.5), scheduler: DispatchQueue.global())
            )
            .receive(on: DispatchQueue.main)
            .assign(to: &$loadingState)
    }
}

extension MovieDetailsViewModel {
    enum LoadingState {
        case pristine
        case loading
        case loaded(Result<MovieDetailsEntity, NetworkError>)
    }
}
