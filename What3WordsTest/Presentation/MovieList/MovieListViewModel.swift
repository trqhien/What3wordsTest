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

struct MoviewListEvent {
    // called when a screen becomes visible
    let appear: AnyPublisher<Void, Never>
        
    // triggered when a search query is updated
    let search: AnyPublisher<String, Never>
        
    // called when a user selected an item from the list
    let selection: AnyPublisher<Int, Never>
}

protocol StateMachine {
    associatedtype State
    associatedtype Event
    
    func transform(event: Event) -> State
}

class MoviewListState {
    @Published var currentTrendingMoviePage: Int?
    @Published var trendingMovies: [Movie] = []
    @Published var currentSearchMoviePage: Int?
    @Published var searchMovies: [Movie] = []
}

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
    
    static func dto<M>(from response: PaginationResponse<M>) -> Pagination? where M: Decodable {
        return response.isEmpty
            ? nil
            : Pagination(currentPage: response.page, totalPages: response.totalPages)
    }
    
    static func == (lhs: Pagination, rhs: Pagination) -> Bool {
        return lhs.currentPage == rhs.currentPage
        && lhs.totalPages == rhs.totalPages
    }
}

enum Either<Left, Right> {
    case left(Left)
    case right(Right)
}

// TODO: Create State machine
final class MovieListViewModel {
    @LazyInjected private var trendingAPIService: TrendingAPIServiceType
    @LazyInjected private var searchAPIService: SearchAPIServiceType
    
    @Published private var pagination: Pagination?
    @Published private var trendingMovies: OrderedSet<Movie> = []
    @Published var errorMessage: String?
    @Published private var isLoadingTrendingMovies: Bool = false
    @Published var isLoadingMore: Bool = false
    
    @Published private var isSearchActive: Bool = false
    @Published private var searchPagination: Pagination?
    @Published private var searchedMovies: OrderedSet<Movie> = []
    @Published var searchErrorMessage: String?
    @Published private var isSearching: Bool = false
    @Published var isLoadingMoreSearch: Bool = false
    
//    @Published var emptyState: Either<Bool, String>
    // TODO: Add coordinator
    
    @Published var displayedMovies: OrderedSet<Movie> = []
    @Published var isLoading: Bool = false
    
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
            .assign(to: &$displayedMovies)
        
        Publishers
            .CombineLatest3($isLoadingTrendingMovies, $isSearching, $isSearchActive)
            .map { _isLoadingTrendingMovies, _isSearching, _isSearchActive in
                if (_isSearchActive) {
                    return _isSearching
                } else {
                    return _isLoadingTrendingMovies
                }
            }
            .assign(to: &$isLoading)
            
    }
    
    func bind(searchQuery: AnyPublisher<String, Never>) {
        let search = searchQuery
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.global())
            .removeDuplicates()
            .share()
        
        search
            .sink(receiveValue: { [weak self] value in
                if value.isEmpty {
                    self?.searchedMovies = []
                }
            })
            .store(in: &subscriptions)
    
        
        search
            .map { $0.isNotEmpty }
            .assign(to: &$isSearchActive)
        
        let searched = search
            .filter { $0.isNotEmpty }
            .map{ self.searchAPIService.searchMovies(queryString: $0, page: 1) }
            .switchToLatest()
            .replaceError(with: PaginationResponse<Movie>.empty)
            .share()
        
        searched
            .map { OrderedSet($0.results) }
            .receive(on: DispatchQueue.main)
            .assign(to: &$searchedMovies)
        
        searched
            .map{ Pagination.dto(from: $0) }
            .receive(on: DispatchQueue.main)
            .assign(to: &$searchPagination)
        
        search
            .map { _ in true }
            .merge(with: searched
                .map { _ in false }
                .delay(for: .seconds(0.5), scheduler: DispatchQueue.global())
            )
            .replaceError(with: false)
            .receive(on: DispatchQueue.main)
            .assign(to: &$isSearching)
    }
    
    func bind(loadMoretrigger: AnyPublisher<Void, Never>) {
        loadMoretrigger
            .dropFirst(1)
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .sink { [weak self] in
                self?.loadNextPageTrendingMovies()
            }
            .store(in: &subscriptions)
    }
    
    func loadTrendingMovies() {
        isLoadingTrendingMovies = true
        
        trendingAPIService
            .getTrendingMovie(timeWindow: .day, page: 1)
            .sink { [weak self] completion in
                self?.isLoadingTrendingMovies = false
                
                if case let .failure(err) = completion {
                    self?.errorMessage = err.localizedDescription
                } else {
                    self?.errorMessage = nil
                }
            } receiveValue: { [weak self]  pagination in
                self?.pagination = Pagination(currentPage: pagination.page, totalPages: pagination.totalPages)
                self?.trendingMovies.append(contentsOf: pagination.results)
            }
            .store(in: &subscriptions)
    }
    
    func loadNextPageTrendingMovies() {
        guard let pagination = self.pagination, !isLoadingMore else { return }
        isLoadingMore = true

        trendingAPIService
            .getTrendingMovie(timeWindow: .day, page: pagination.nextPage)
            .sink { [weak self] completion in
                self?.isLoadingMore = false
            } receiveValue: { [weak self]  newPagination in
                self?.pagination = Pagination(currentPage: newPagination.page, totalPages: newPagination.totalPages)
                self?.trendingMovies = self?.trendingMovies.union(OrderedSet(newPagination.results)) ?? []
            }
            .store(in: &subscriptions)
    }
}
