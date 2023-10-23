//
//  MovieCell.swift
//  What3WordsTest
//
//  Created by Hien Tran on 22/10/2023.
//

import UIKit
import TinyConstraints

class MovieCell: UITableViewCell {
    
    lazy var posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .lightGray
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    lazy var overviewLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .left
        label.numberOfLines = 3
        return label
    }()
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    lazy var ratingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .center //.left
        label.numberOfLines = 0
        label.layer.cornerRadius = 5
        label.layer.masksToBounds = true
        return label
    }()
    
    lazy var voteCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    
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
//        if let releaseDate = movie.releaseDate {
//            dateLabel.text = DateFormatter.appFormat.string(from: releaseDate)
//        }
        overviewLabel.text = movie.overview
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
        posterImageView.bottom(to: contentView, relation: .equalOrLess)
        posterImageView.size(CGSize(width: 70, height: 100))

        titleLabel.top(to: posterImageView)
        titleLabel.leftToRight(of: posterImageView, offset: 8)
        titleLabel.rightToSuperview()

        overviewLabel.topToBottom(of: titleLabel, offset: 8)
        overviewLabel.left(to: titleLabel)
        overviewLabel.rightToSuperview()

        ratingLabel.topToBottom(of: overviewLabel, offset: 8)
        ratingLabel.left(to: titleLabel)
        ratingLabel.width(50)

        voteCountLabel.leftToRight(of: ratingLabel, offset: 8)
        voteCountLabel.rightToSuperview(relation: .equalOrLess)
        voteCountLabel.bottom(to: ratingLabel)

        dateLabel.topToBottom(of: ratingLabel, offset: 8)
        dateLabel.left(to: titleLabel)
        dateLabel.rightToSuperview()
        dateLabel.bottomToSuperview(relation: .equalOrLess)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
