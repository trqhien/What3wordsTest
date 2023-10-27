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
    private var viewModel: MovieListViewModel
    
    private let scrollToBottom = PassthroughSubject<Void, Never>()
    private let onAppearLoad = PassthroughSubject<Void, Never>()
//    private let selection = PassthroughSubject<Int, Never>()
    
    private var subscriptions = Set<AnyCancellable>()
    
    private lazy var tableViewDataSource: UITableViewDiffableDataSource<Section, MovieEntity> = {
        let dataSource = UITableViewDiffableDataSource<Section, MovieEntity>(tableView: tableView) { tableView, indexPath, movie in
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
        tableView.estimatedRowHeight = 50
        tableView.backgroundColor = .white
        tableView.separatorColor = .lightGray
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.indicatorStyle = .white
        tableView.keyboardDismissMode = .interactive
        tableView.showsVerticalScrollIndicator = true
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
        onAppearLoad.send()
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
        var initialSnapshot = NSDiffableDataSourceSnapshot<Section, MovieEntity>()
        initialSnapshot.appendSections([.trending])
        tableViewDataSource.apply(initialSnapshot, animatingDifferences: false)
    }
    
    private func bind(to viewModel: MovieListViewModel) {
        viewModel.$displayedMovies
            .receive(on: DispatchQueue.main)
            .sink { [weak self] movies in
                self?.update(with: movies.elements)
            }
            .store(in: &subscriptions)
        
        viewModel.$loadingState
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                switch state {
                case .loading:
                    self?.activityIndicator.startAnimating()
                    self?.tableView.isHidden = true
                    self?.errorLabel.text = nil
                    self?.errorLabel.isHidden = true
                case .loaded(let result):
                    self?.activityIndicator?.stopAnimating()
                    switch result {
                    case .failure(let err):
                        self?.errorLabel.text = err.failureReason
                        self?.errorLabel.isHidden = false
                        self?.tableView.isHidden = true
                    case .success:
                        self?.errorLabel.text = nil
                        self?.errorLabel.isHidden = true
                        self?.tableView.isHidden = false
                    }
                case .pristine:
                    self?.errorLabel.text = nil
                    self?.errorLabel.isHidden = true
                    break
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
        
        viewModel.bind(onAppearLoad: onAppearLoad.eraseToAnyPublisher())
        viewModel.bind(loadMoretrigger: scrollToBottom.eraseToAnyPublisher())
        viewModel.bind(searchQuery: searchBar.textDidChangePublisher)
    }
}

extension MovieListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let snapshot = tableViewDataSource.snapshot()
        let id = snapshot.itemIdentifiers[indexPath.row].id
        
        // TODO: Use coordinator to ochestrate this
//        selection.send(snapshot.itemIdentifiers[indexPath.row].id)
        navigationController?.pushViewController(MovieDetailsViewController(movieId: id), animated: true)
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
    
    func update(with movies: [MovieEntity], animate: Bool = false) {
        DispatchQueue.main.async {
            var snapshot = NSDiffableDataSourceSnapshot<Section, MovieEntity>()
            snapshot.appendSections([.trending])
            snapshot.appendItems(movies, toSection: .trending)
            self.tableViewDataSource.apply(snapshot, animatingDifferences: animate)
        }
    }
}
