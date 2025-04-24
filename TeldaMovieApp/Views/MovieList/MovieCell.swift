//
//  MovieCell.swift
//  TeldaMovieApp
//
//  Created by Kareem Elfadaly on 24/04/2025.
//

import UIKit

final class MovieCell: UITableViewCell {
    private let titleLabel = UILabel()
    private let overviewLabel = UILabel()
    private let posterImageView = UIImageView()
    private let bookmarkIcon = UIImageView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .default // or .none if you don't want highlight
        isUserInteractionEnabled = true
        setupUI()
    }

    required init?(coder: NSCoder) { fatalError() }

    func configure(with movie: Movie, isInWatchlist: Bool) {
        titleLabel.text = movie.title
        overviewLabel.text = movie.overview
        bookmarkIcon.image = UIImage(systemName: isInWatchlist ? "bookmark.fill" : "bookmark")

        if let path = movie.posterPath {
            let url = URL(string: "https://image.tmdb.org/t/p/w500\(path)")
            posterImageView.loadImage(from: url)
        }
    }


    private func setupUI() {
        posterImageView.contentMode = .scaleAspectFill
        posterImageView.clipsToBounds = true
        posterImageView.layer.cornerRadius = 6

        titleLabel.font = .boldSystemFont(ofSize: 16)
        overviewLabel.font = .systemFont(ofSize: 13)
        overviewLabel.numberOfLines = 3

        bookmarkIcon.tintColor = .systemBlue

        let textStack = UIStackView(arrangedSubviews: [titleLabel, overviewLabel])
        textStack.axis = .vertical
        textStack.spacing = 4

        let hStack = UIStackView(arrangedSubviews: [posterImageView, textStack, bookmarkIcon])
        hStack.axis = .horizontal
        hStack.spacing = 12
        hStack.alignment = .center

        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        posterImageView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        posterImageView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        bookmarkIcon.translatesAutoresizingMaskIntoConstraints = false
        bookmarkIcon.widthAnchor.constraint(equalToConstant: 24).isActive = true
        bookmarkIcon.heightAnchor.constraint(equalToConstant: 24).isActive = true

        contentView.addSubview(hStack)
        hStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            hStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            hStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            hStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
}
