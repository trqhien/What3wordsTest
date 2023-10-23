//
//  MovieListViewModel.swift
//  What3WordsTest
//
//  Created by Hien Tran on 21/10/2023.
//
import Resolver
import Combine
import UIKit

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
final class MoviewListViewModel {
    @LazyInjected private var trendingAPIService: TrendingAPIServiceType
    
    @Published var pagination: Pagination?
    @Published var trendingMovies: [Movie] = []
    @Published var currentTrendingPage: Int?
    @Published var errorMessage: String?
    @Published var isLoadingTrendingMovies: Bool = false
    @Published var isLoadingMore: Bool = false
    
//    @Published var emptyState: Either<Bool, String>
    
    private var subscriptions = Set<AnyCancellable>()
    
    func bind(loadMoretrigger: AnyPublisher<Bool, Never>) {
        loadMoretrigger
            .dropFirst(1)
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .sink { [weak self] shouldLoadMore in
                if shouldLoadMore {
                    self?.loadNextPageTrendingMovies()
                }
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
                }
            } receiveValue: { [weak self]  pagination in
                self?.pagination = Pagination(currentPage: pagination.page, totalPages: pagination.totalPages)
                self?.trendingMovies.append(contentsOf: pagination.results)
                
//                print("✅ count \(self!.trendingMovies.count)")
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
                self?.trendingMovies.append(contentsOf: newPagination.results)
            }
            .store(in: &subscriptions)
    }
    
}
