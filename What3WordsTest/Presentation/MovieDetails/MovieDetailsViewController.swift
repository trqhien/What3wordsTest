//
//  MovieDetailsViewController.swift
//  What3WordsTest
//
//  Created by Hien Tran on 24/10/2023.
//

import UIKit
import Resolver
import Combine
import TinyConstraints

final class MovieDetailsViewController: UIViewController {
    @Injected
    private var viewModel: MovieDetailsViewModel
    
    private let loadOnAppear = PassthroughSubject<Int, Never>()
    
    let movieId: Int
    
    init(movieId: Int) {
        self.movieId = movieId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var tableViewDataSource: UITableViewDiffableDataSource<Section, Row> = {
        let dataSource = UITableViewDiffableDataSource<Section, Row>(tableView: tableView) { tableView, indexPath, item in
            switch item {
            case .movie(let details):
                let cell = tableView.dequeueReusableCell(for: MovieDetailCell.self, forIndexPath: indexPath)
                cell.configure(with: details)
                return cell
            case .credit(let details):
                let cell = tableView.dequeueReusableCell(for: MovieDetailCell.self, forIndexPath: indexPath)
                cell.configure(with: details)
                return cell
            }
        }
        return dataSource
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.allowsSelection = false
        tableView.separatorStyle = .singleLine
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 150
        tableView.backgroundColor = .white
        tableView.separatorInset = .zero
        tableView.indicatorStyle = .white
        tableView.register(MovieDetailCell.self)
        return tableView
    }()
    
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.style = UIActivityIndicatorView.Style.medium
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private lazy var emptyStateLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.boldSystemFont(ofSize: 28)
        lbl.textAlignment = .center
        lbl.numberOfLines = 0
        return lbl
    }()
    
    private var subscriptions = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        defer {
            loadOnAppear.send(movieId)
        }
        
        configUI()
        configureInitialDiffableSnapshot()
        bind(to: viewModel)
    }
    
    private func configUI() {
        view.backgroundColor = .white
        
        view.addSubview(tableView)
        view.addSubview(loadingIndicator)
        view.addSubview(emptyStateLabel)
        view.bringSubviewToFront(loadingIndicator)
        view.bringSubviewToFront(emptyStateLabel)
        
        tableView.edgesToSuperview()
        loadingIndicator.centerInSuperview()
        emptyStateLabel.horizontalToSuperview(insets: TinyEdgeInsets.horizontal(20))
        emptyStateLabel.verticalToSuperview()
    }
    
    
    private func configureInitialDiffableSnapshot() {
        var initialSnapshot = NSDiffableDataSourceSnapshot<Section, Row>()
        initialSnapshot.appendSections([.movie, .credit])
        tableViewDataSource.apply(initialSnapshot, animatingDifferences: false)
    }
    
    private func bind(to viewModel: MovieDetailsViewModel) {
        
        viewModel.$loadingState
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] state in
                switch state {
                case .loading:
                    self?.loadingIndicator.startAnimating()
                    self?.tableView.isHidden = true
                    self?.emptyStateLabel.isHidden = true
                case .loaded(let result):
                    self?.loadingIndicator.stopAnimating()
                    
                    switch result {
                    case .success(let movieDetails):
                        self?.emptyStateLabel.isHidden = true
                        self?.tableView.isHidden = false
                        self?.updateTable(with: movieDetails)
                    case .failure(let err):
                        self?.emptyStateLabel.isHidden = false
                        self?.tableView.isHidden = true
                        self?.emptyStateLabel.text = err.localizedDescription
                    }
                default:
                    break
                }
            })
            .store(in: &subscriptions)
            
            
        viewModel.bind(loadOnAppear: loadOnAppear.eraseToAnyPublisher())
    }
    
    private func updateTable(with movieDetails: MovieDetails) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Row>()
        snapshot.appendSections([.movie])
        snapshot.appendItems([.movie(movieDetails)], toSection: .movie)
        self.tableViewDataSource.apply(snapshot, animatingDifferences: false)
    }
}

extension MovieDetailsViewController {
    enum Section: Hashable {
        case movie
        case credit
//        case credits(cast: [CastCodable], crew: [CrewCodable])
    }
    
    enum Row: Hashable {
        case movie(MovieDetails)
        case credit(MovieDetails)
    }
}
