//
//  MovieListViewController.swift
//  What3WordsTest
//
//  Created by Hien Tran on 21/10/2023.
//

import UIKit
import Resolver
import Combine
import TinyConstraints
import CombineCocoa

final class MovieListViewController: UIViewController {
    @Injected
    private var viewModel: MoviewListViewModel
    
    private let scrollToBottom = PassthroughSubject<Void, Never>()
    
    private var subscriptions = Set<AnyCancellable>()
    
    private lazy var tableViewDataSource: UITableViewDiffableDataSource<Section, Movie> = {
        let dataSource = UITableViewDiffableDataSource<Section, Movie>(tableView: tableView) { tableView, indexPath, movie in
            let cell = tableView.dequeueReusableCell(for: MovieCell.self, forIndexPath: indexPath)
            cell.configure(with: movie)
            return cell
        }
        return dataSource
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.isScrollEnabled = true
        tableView.separatorStyle = .singleLine
//        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50
//        tableView.tableFooterView = UIView(frame: .zero)
        tableView.backgroundColor = .white
        tableView.separatorColor = .lightGray
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.indicatorStyle = .white
        tableView.keyboardDismissMode = .interactive
        tableView.showsVerticalScrollIndicator = true
//        tableView.insertSubview(refreshControl, at: 0)
//        tableView.keyboardDismissMode = .interactive
//                tableView.insertSubview(refreshControl, at: 0)
        tableView.register(MovieCell.self)
        tableView.delegate = self
        tableView.tableFooterView = loadMoreActivityIndicator
        tableView.tableFooterView?.frame.size.height = 80
        return tableView
    }()
    
    private lazy var searchBar: UISearchBar = {
        let view = UISearchBar()
        view.placeholder = "Search for movie titles..."
        view.searchBarStyle = .minimal
//        view.delegate = self
        return view
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView! = {
        let indicator = UIActivityIndicatorView()
        indicator.style = UIActivityIndicatorView.Style.medium
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private lazy var loadMoreActivityIndicator: UIActivityIndicatorView! = {
        let indicator = UIActivityIndicatorView()
        indicator.style = UIActivityIndicatorView.Style.medium
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private lazy var errorLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.boldSystemFont(ofSize: 28)
        lbl.textAlignment = .center
        lbl.numberOfLines = 0
        return lbl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        configureInitialDiffableSnapshot()
        bind(to: viewModel)
        viewModel.loadTrendingMovies()
    }
    
    private func configUI() {
        view.backgroundColor = .white
        navigationItem.titleView = searchBar
        
        view.addSubview(tableView)
        view.addSubview(activityIndicator)
        view.addSubview(errorLabel)
        view.bringSubviewToFront(activityIndicator)
        view.bringSubviewToFront(errorLabel)
        
        tableView.edgesToSuperview()
        activityIndicator.centerInSuperview()
        errorLabel.horizontalToSuperview(insets: TinyEdgeInsets.horizontal(20))
        errorLabel.verticalToSuperview()
    }
    
    private func configureInitialDiffableSnapshot() {
        var initialSnapshot = NSDiffableDataSourceSnapshot<Section, Movie>()
        initialSnapshot.appendSections([.trending])
        tableViewDataSource.apply(initialSnapshot, animatingDifferences: false)
    }
    
    private func bind(to viewModel: MoviewListViewModel) {
        viewModel.$displayedMovies
            .receive(on: DispatchQueue.main)
            .sink { [weak self] movies in
                self?.update(with: movies.elements)
            }
            .store(in: &subscriptions)
        
        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                if isLoading {
                    self?.activityIndicator.startAnimating()
                    self?.tableView.isHidden = true
                } else{
                    self?.activityIndicator?.stopAnimating()
                    self?.tableView.isHidden = false
                }
            }
            .store(in: &subscriptions)
        
        viewModel.$isLoadingMore
            .receive(on: DispatchQueue.main)
            .sink { [weak loadMoreActivityIndicator] isLoadingMore in
                isLoadingMore
                    ? loadMoreActivityIndicator?.startAnimating()
                    : loadMoreActivityIndicator?.stopAnimating()
            }
            .store(in: &subscriptions)
        
        viewModel.$errorMessage
            .receive(on: DispatchQueue.main)
            .sink { [weak errorLabel] errorMessage in
                
                errorLabel?.text = errorMessage
                
                if errorMessage == nil {
//                    errorLabel?.isHidden = true
//                    self?.tableView.isHidden = false
                } else {
//                    errorLabel?.isHidden = false
//                    self?.tableView.isHidden = true
                }
            }
            .store(in: &subscriptions)
        
        viewModel.bind(loadMoretrigger: scrollToBottom.eraseToAnyPublisher())
        viewModel.bind(searchQuery: searchBar.textDidChangePublisher)
    }
}

extension MovieListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        let snapshot = tableViewDataSource.snapshot()
        //        selection.send(snapshot.itemIdentifiers[indexPath.row].id)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension MovieListViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        searchBar.resignFirstResponder()
        
        let postion = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let screenHeight = scrollView.frame.size.height
        
        if postion > contentHeight - screenHeight - 100 {
            scrollToBottom.send()
        }
    }
}

extension MovieListViewController {
    enum Section: String, CaseIterable {
        case trending
//        case search
//        case loadMore
    }
    
    func update(with movies: [Movie], animate: Bool = false) {
        DispatchQueue.main.async {
            var snapshot = NSDiffableDataSourceSnapshot<Section, Movie>()
            snapshot.appendSections([.trending])
            snapshot.appendItems(movies, toSection: .trending)
            self.tableViewDataSource.apply(snapshot, animatingDifferences: animate)
        }
    }
}
