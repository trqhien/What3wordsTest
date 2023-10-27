//
//  MovieListViewModelTests.swift
//  What3WordsTestTests
//
//  Created by Hien Tran on 26/10/2023.
//

import Combine
import OrderedCollections
import XCTest
import Mockingbird
import Resolver
@testable import What3WordsTest

final class MovieListViewModelTests: XCTestCase {
    
    private var vm: MovieListViewModel!
    private var subscriptions = Set<AnyCancellable>()
    
    override func setUp() {
        vm = MovieListViewModel()
        Resolver.registerMockServices()
    }
    
    override func tearDown() {
        reset(trendingMockService)
        subscriptions.forEach { $0.cancel() }
    }

    func testLoadTrendingMovies_ShouldReturnCorrectly() throws {
        let onAppear = PassthroughSubject<Void, Never>()
        var expected: OrderedSet<MovieEntity> = []
        let movies = PaginationResponse<Movie>.loadFromFile("trending_movies_1")
        
        let expectation = self.expectation(description: "loadTrendingMovies")
        vm.$displayedMovies
            .dropFirst(1)
            .sink { results in
                expected = results
                expectation.fulfill()
            }
            .store(in: &subscriptions)
        vm.bind(onAppearLoad: onAppear.eraseToAnyPublisher())
        
        given(trendingMockService.getTrendingMovie(timeWindow: .day, page: 1)).willReturn(MockNetworkPublisher(movies).eraseToAnyPublisher())
        
        onAppear.send()
        waitForExpectations(timeout: 1.0, handler: nil)
        XCTAssertEqual(expected.count, 5)
        XCTAssertEqual(expected.map { $0.id }, [807172, 951491, 466420, 987917, 575264])
    }
    
    func testLoadNextPageTrendingMovies_ShouldNotContainDuplicates() throws {
        let loadNext = PassthroughSubject<Void, Never>()
        let onAppear = PassthroughSubject<Void, Never>()
        let movies_page_1 = PaginationResponse<Movie>.loadFromFile("trending_movies_1")
        let movies_page_2 = PaginationResponse<Movie>.loadFromFile("trending_movies_2")
        
        
        let expectation1 = expectation(description: "loadTrendingMoviesPage1")
        let expectation2 = expectation(description: "loadTrendingMoviesPage2")
        
        vm.bind(loadMoretrigger: loadNext.eraseToAnyPublisher())
        vm.$displayedMovies
            .dropFirst(1)
            .sink { results in
                if results.count == 5 { // Done loading the first page
                    expectation1.fulfill()
                } else if results.count > 5 { // Done loading the second page
                    expectation2.fulfill()
                }
            }
            .store(in: &subscriptions)
        vm.bind(onAppearLoad: onAppear.eraseToAnyPublisher())
        
        given(trendingMockService.getTrendingMovie(timeWindow: .day, page: 1)).willReturn(MockNetworkPublisher(movies_page_1).eraseToAnyPublisher())
        given(trendingMockService.getTrendingMovie(timeWindow: .day, page: 2)).willReturn(MockNetworkPublisher(movies_page_2).eraseToAnyPublisher())
        
        onAppear.send()
        wait(for: [expectation1], timeout: 1)
        loadNext.send()
        wait(for: [expectation2], timeout: 1.5)
        
        XCTAssertEqual(vm.displayedMovies.count, 9)
        XCTAssertEqual(vm.displayedMovies.map { $0.id }, [807172, 951491, 466420, 987917, 575264, 912916, 944952, 894205, 926393])
    }

}
