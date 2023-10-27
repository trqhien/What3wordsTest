//
//  MovieListViewModel.swift
//  What3WordsTest
//
//  Created by Hien Tran on 21/10/2023.
//
import Resolver
import Combine
import UIKit
import OrderedCollections

struct Pagination {
    let currentPage: Int
    let totalPages: Int
    
    var nextPage: Int {
        guard currentPage < totalPages else { return currentPage }
        return currentPage + 1
    }
    
    var canLoadMore: Bool {
        return currentPage < nextPage
    }
    
    static func fromResponse<M>(_ response: PaginationResponse<M>) -> Pagination? where M: Decodable {
        return response.isEmpty
            ? nil
            : Pagination(currentPage: response.page, totalPages: response.totalPages)
    }
    
    static func == (lhs: Pagination, rhs: Pagination) -> Bool {
        return lhs.currentPage == rhs.currentPage
        && lhs.totalPages == rhs.totalPages
    }
}

// TODO: Create State machine
final class MovieListViewModel {
    @LazyInjected private var trendingAPIService: TrendingAPIServiceType
    @LazyInjected private var searchAPIService: SearchAPIServiceType
    
    @Published private var pagination: Pagination?
    @Published private var trendingMovies: OrderedSet<MovieEntity> = []
    
    @Published var trendingLoadingState: LoadingState = .pristine
    @Published var isLoadingMore: Bool = false
    
    @Published private var isSearchActive: Bool = false
    @Published private var searchedMovies: OrderedSet<MovieEntity> = []
    @Published private var searchLoadingState: LoadingState = .pristine
    
    // TODO: Add coordinator
    
    @Published var displayedMovies: OrderedSet<MovieEntity> = []
    @Published var loadingState: LoadingState = .pristine
    
    private var subscriptions = Set<AnyCancellable>()
    
    init() {
        Publishers
            .CombineLatest3($trendingMovies, $searchedMovies, $isSearchActive)
            .map { _trendingMovies, _searchedMovies, _isSearchActive in
                if (_isSearchActive) {
                    return _searchedMovies
                } else {
                    return _trendingMovies
                }
            }
            .removeDuplicates()
            .assign(to: &$displayedMovies)
        
        Publishers
            .CombineLatest3($trendingLoadingState, $searchLoadingState, $isSearchActive)
            .map { _trendingLoadingState, _searchLoadingState, _isSearchActive in
                if (_isSearchActive) {
                    return _searchLoadingState
                } else {
                    return _trendingLoadingState
                }
            }
            .assign(to: &$loadingState)
            
    }
    
    func bind(searchQuery: AnyPublisher<String, Never>) {
        let startSearch = searchQuery
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.global())
            .removeDuplicates()
            .share()
        
        // Reset empty state message for every new search
        startSearch
            .sink(receiveValue: { [weak self] value in
                self?.searchLoadingState = .pristine
                self?.searchedMovies = []
            })
            .store(in: &subscriptions)
    
        
        startSearch
            .map { $0.isNotEmpty }
            .assign(to: &$isSearchActive)
        
        let searchedOutput = startSearch
            .filter { $0.isNotEmpty }
            .map{ self.searchAPIService.searchMovies(queryString: $0, page: 1).mapToResult() }
            .switchToLatest()
            .map { result -> LoadingState in
                switch result {
                case .failure(let err):
                    return .loaded(.failure(err))
                case .success(let res):
                    if res.results.isEmpty {
                        return .loaded(.failure(.custom("We didn't find any movie with this title")))
                    } else {
                        let orderSet = OrderedSet(res.results.map { MovieEntity(from: $0) })
                        return .loaded(.success(orderSet))
                    }
                }
            }
            .share()
        
        searchedOutput
            .sink { [weak self] state in
                if let movies = state.loadedResult {
                    self?.searchedMovies = movies
                }
            }
            .store(in: &subscriptions)
        
        searchedOutput
            .assign(to: &$searchLoadingState)
        
        startSearch
            .map { _ in true }
            .merge(with: searchedOutput
                .map { _ in false }
                .delay(for: .seconds(0.5), scheduler: DispatchQueue.global())
            )
            .replaceError(with: false)
            .sink(receiveValue: { [weak self] isLoading in
                if isLoading {
                    self?.loadingState = .loading
                }
            })
            .store(in: &subscriptions)
    }
    
    func bind(onAppearLoad: AnyPublisher<Void, Never>) {
        let start = onAppearLoad.share()
        
        let output = start
            .map{ self
                .trendingAPIService.getTrendingMovie(timeWindow: .day, page: 1)
                .mapToResult()
            }
            .switchToLatest()
            .share()
        
        output
            .sink(receiveValue: { [weak self] result in
                if case let .success(res) = result, !res.isEmpty {
                    self?.pagination = Pagination(currentPage: res.page, totalPages: res.totalPages)
                    self?.trendingMovies.append(contentsOf: res.results.map { MovieEntity(from: $0)})
                }
            })
            .store(in: &subscriptions)
        
        
        output
            .map { result -> LoadingState in
                switch result {
                case .failure(let err):
                    return .loaded(.failure(err))
                case .success(let res):
                    if res.results.isEmpty {
                        // Athough this is not likely to happen but just to be safe to handle empty state here
                        return .loaded(.failure(.custom("No results")))
                    } else {
                        let orderSet = OrderedSet(res.results.map { MovieEntity(from: $0) })
                        return .loaded(.success(orderSet))
                    }
                }
            }
            .assign(to: &$trendingLoadingState)
        
        start
            .map { _ in true }
            .merge(with: output
                .map { _ in false }
                .delay(for: .seconds(0.5), scheduler: DispatchQueue.global())
            )
            .replaceError(with: false)
            .sink(receiveValue: { [weak self] isLoading in
                if isLoading {
                    self?.trendingLoadingState = .loading
                }
            })
            .store(in: &subscriptions)
    }
    
    func bind(loadMoretrigger: AnyPublisher<Void, Never>) {
        loadMoretrigger
            //.dropFirst(1)
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .sink { [weak self] in
                self?.loadNextPageTrendingMovies()
            }
            .store(in: &subscriptions)
    }
    
    private func loadNextPageTrendingMovies() {
        guard let pagination = self.pagination, !isLoadingMore, !isSearchActive else { return }
        isLoadingMore = true

        trendingAPIService
            .getTrendingMovie(timeWindow: .day, page: pagination.nextPage)
            .sink { [weak self] completion in
                self?.isLoadingMore = false
            } receiveValue: { [weak self]  newPagination in
                self?.pagination = Pagination(currentPage: newPagination.page, totalPages: newPagination.totalPages)
                self?.trendingMovies = self?.trendingMovies
                    .union(OrderedSet(newPagination.results.map { MovieEntity(from: $0) }))
                    ?? []
            }
            .store(in: &subscriptions)
    }
}

extension MovieListViewModel {
    enum LoadingState {
        case pristine
        case loading
        case loaded(Result<OrderedSet<MovieEntity>, NetworkError>)
        
        var loadedResult: OrderedSet<MovieEntity>? {
            switch self {
            case .loaded(let result):
                return try? result.get()
            default:
                return nil
            }
        }
        
        var loadedError: NetworkError? {
            switch self {
            case .loaded(let result):
                if case let .failure(err) = result {
                    return err
                }
                return nil
            default:
                return nil
            }
        }
    }
}
