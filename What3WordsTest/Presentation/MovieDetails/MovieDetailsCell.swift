//
//  MovieDetailsCell.swift
//  What3WordsTest
//
//  Created by Hien Tran on 24/10/2023.
//

import UIKit
import TinyConstraints

final class MovieDetailCell: UITableViewCell {
    private let backDropImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.backgroundColor = .lightGray
        return view
    }()

    private let divider: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()

    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.boldSystemFont(ofSize: 20)
        lbl.textColor = .black
        lbl.textAlignment = .left
        lbl.numberOfLines = 0
        return lbl
    }()

    private let descriptionLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.boldSystemFont(ofSize: 16)
        lbl.textColor = .black
        lbl.textAlignment = .left
        lbl.numberOfLines = 0
        return lbl
    }()

    private let overviewLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 14)
        lbl.textColor = .black
        lbl.textAlignment = .left
        lbl.numberOfLines = 0
        return lbl
    }()

    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        addSubviews()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public helpers
    func configure(with movie: MovieDetailsEntity) {
        if let releaseDate = movie.releaseDate {
            titleLabel.text = "\(movie.title) (\(Calendar.current.component(.year, from: releaseDate)))"
        } else {
            titleLabel.text = movie.title
        }

        overviewLabel.text = movie.overview
        descriptionLabel.text = generateDesctiptions(from: movie)
        backDropImageView.kf.setImage(with: movie.backdrop)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        backDropImageView.kf.cancelDownloadTask()
        backDropImageView.image = nil
    }

    private func addSubviews() {
        contentView.addSubview(backDropImageView)
        contentView.addSubview(divider)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(divider)
        contentView.addSubview(overviewLabel)

        backDropImageView.edgesToSuperview(excluding: .bottom)
        backDropImageView.heightToWidth(of: backDropImageView, multiplier: CGFloat(9)/CGFloat(16))

        titleLabel.topToBottom(of: backDropImageView, offset: 8)
        titleLabel.horizontalToSuperview(insets: .all(8))

        descriptionLabel.topToBottom(of: titleLabel, offset: 8)
        descriptionLabel.horizontalToSuperview(insets: .all(8))

        divider.topToBottom(of: descriptionLabel, offset: 8)
        divider.horizontalToSuperview(insets: .zero)
        divider.height(1.5)

        overviewLabel.topToBottom(of: divider, offset: 8)
        overviewLabel.edgesToSuperview(excluding: .top, insets: .all(8))
    }

    private func generateDesctiptions(from movie: MovieDetailsEntity) -> String {
        var attributes: [String] = []

        if movie.voteAverage != 0 {
            attributes.append("⭐️\(String(format: "%.1f", movie.voteAverage))/10")
        }
        
        let genres = movie.genres
            .map { $0.name }
            .joined(separator: ", ")
        attributes.append(genres)

        var descriptionString = ""

        for (index, attribute) in attributes.enumerated() {
            if index == 0 {
                descriptionString += attribute
            } else {
                descriptionString += " | \(attribute)"
            }
        }

        return descriptionString
    }
}
