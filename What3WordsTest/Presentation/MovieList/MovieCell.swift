//
//  MovieCell.swift
//  What3WordsTest
//
//  Created by Hien Tran on 22/10/2023.
//

import UIKit
import TinyConstraints
import Combine

class MovieCell: UITableViewCell {
    
    private lazy var posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .lightGray
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var overviewLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .left
        label.numberOfLines = 3
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var ratingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .center //.left
        label.numberOfLines = 0
        label.layer.cornerRadius = 5
        label.layer.masksToBounds = true
        return label
    }()
    
    private lazy var voteCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    private var cancellable: AnyCancellable?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with movie: Movie) {
        titleLabel.text = movie.title.capitalized
        voteCountLabel.text = movie.voteCount > 1
            ? "\(movie.voteCount) votes"
            : "\(movie.voteCount) vote"
        ratingLabel.text = String(format: "%.1f", movie.voteAverage)
        ratingLabel.backgroundColor = movie.voteAverage >= 5.0
            ? .systemGreen
            : .systemRed
        
        if let releaseDate = movie.releaseDate {
            dateLabel.text = "\(Calendar.current.component(.year, from: releaseDate))"
        }

        overviewLabel.text = movie.overview
        
        cancellable = movie.poster
            .sink(receiveValue: { [unowned self] imageBuilder in
                cancelImageLoading()
                imageBuilder?.set(to: self.posterImageView)
            })
    }

    private func addSubviews() {
        contentView.addSubview(posterImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(overviewLabel)
        contentView.addSubview(ratingLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(voteCountLabel)

        posterImageView.topToSuperview(offset: 8)
        posterImageView.leftToSuperview(offset: 8)
        posterImageView.bottomToSuperview(offset: -8, relation: .equalOrLess)
        posterImageView.size(CGSize(width: 70, height: 100))

        titleLabel.top(to: posterImageView)
        titleLabel.leftToRight(of: posterImageView, offset: 8)
        titleLabel.rightToSuperview(offset: 8)
        
        dateLabel.topToBottom(of: titleLabel, offset: 8)
        dateLabel.left(to: titleLabel)
        dateLabel.rightToSuperview()

        overviewLabel.topToBottom(of: dateLabel, offset: 8)
        overviewLabel.left(to: titleLabel)
        overviewLabel.rightToSuperview()

        ratingLabel.topToBottom(of: overviewLabel, offset: 8)
        ratingLabel.left(to: titleLabel)
        ratingLabel.width(50)
        ratingLabel.bottomToSuperview(offset: -8, relation: .equalOrLess)

        voteCountLabel.leftToRight(of: ratingLabel, offset: 8)
        voteCountLabel.rightToSuperview(relation: .equalOrLess)
        voteCountLabel.bottom(to: ratingLabel)
    }
    
    private func cancelImageLoading() {
        print("Cancelling \(titleLabel.text!)")
        cancellable?.cancel()
        posterImageView.kf.cancelDownloadTask()
        posterImageView.image = nil
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cancelImageLoading()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
