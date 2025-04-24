//
//  MovieDetailViewController.swift
//  TeldaMovieApp
//
//  Created by Kareem Elfadaly on 24/04/2025.
//

import UIKit
import SwiftUI

final class MovieDetailViewController: UIViewController {
    private let viewModel: MovieDetailViewModel
    private let scrollView = UIScrollView()
    private let contentStack = UIStackView()
    private let watchlistButton = UIButton(type: .system)
    private var similarMoviesCollection: UICollectionView!

    init(viewModel: MovieDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError() }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBinding()
        viewModel.fetchAll()
    }

    private func setupUI() {
        title = "Details"
        view.backgroundColor = .systemBackground

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alwaysBounceVertical = true
        view.addSubview(scrollView)

        contentStack.translatesAutoresizingMaskIntoConstraints = false
        contentStack.axis = .vertical
        contentStack.spacing = 20
        contentStack.alignment = .fill
        scrollView.addSubview(contentStack)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            contentStack.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            contentStack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            contentStack.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -32)
        ])
    }

    private func setupBinding() {
        viewModel.onUpdate = { [weak self] in
            self?.reloadUI()
        }
    }

    private func reloadUI() {
        contentStack.arrangedSubviews.forEach { $0.removeFromSuperview() }

        if let detail = viewModel.movieDetail {
            let imageView = UIImageView()
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.layer.cornerRadius = 8
            imageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
            imageView.heightAnchor.constraint(equalToConstant: 150).isActive = true

            if let path = detail.posterPath,
               let url = URL(string: "https://image.tmdb.org/t/p/w500\(path)") {
                imageView.loadImage(from: url)
            }

            let label = UILabel()
            label.numberOfLines = 0
            label.text = """
            \(detail.title)
            \(detail.tagline ?? "")
            Status: \(detail.status)
            Revenue: $\(detail.revenue ?? 0)
            Release: \(detail.releaseDate)

            \(detail.overview)
            """

            let infoStack = UIStackView(arrangedSubviews: [imageView, label])
            infoStack.axis = .horizontal
            infoStack.spacing = 16
            infoStack.alignment = .top
            infoStack.translatesAutoresizingMaskIntoConstraints = false

            contentStack.addArrangedSubview(infoStack)

            watchlistButton.setTitle("Toggle Watchlist", for: .normal)
            watchlistButton.addTarget(self, action: #selector(toggleWatchlist), for: .touchUpInside)
            contentStack.addArrangedSubview(watchlistButton)
        }

        setupSimilarMoviesCollection()

        if !viewModel.topActors.isEmpty {
            addCastTiles(title: "Top Actors", people: viewModel.topActors)
        }

        if !viewModel.topDirectors.isEmpty {
            addCastTiles(title: "Top Directors", people: viewModel.topDirectors.map {
                Cast(id: $0.id, name: $0.name, popularity: $0.popularity, department: $0.department, profilePath: $0.profilePath)
            })
        }
    }

    private func setupSimilarMoviesCollection() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 140, height: 220)
        layout.minimumLineSpacing = 12

        similarMoviesCollection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        similarMoviesCollection.backgroundColor = .clear
        similarMoviesCollection.register(SimilarMovieCell.self, forCellWithReuseIdentifier: "SimilarMovieCell")
        similarMoviesCollection.dataSource = self
        similarMoviesCollection.showsHorizontalScrollIndicator = false

        contentStack.addArrangedSubview(similarMoviesCollection)
        similarMoviesCollection.heightAnchor.constraint(equalToConstant: 220).isActive = true
    }

    private func addCastTiles(title: String, people: [Cast]) {
        let label = UILabel()
        label.text = title
        label.font = .boldSystemFont(ofSize: 18)
        contentStack.addArrangedSubview(label)

        let scroll = UIScrollView()
        scroll.showsHorizontalScrollIndicator = false
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 16

        for person in people {
            let swiftUIView = CastTileView(name: person.name, popularity: person.popularity, profilePath: person.profilePath)
            let hosting = UIHostingController(rootView: swiftUIView)
            hosting.view.backgroundColor = .clear
            hosting.view.translatesAutoresizingMaskIntoConstraints = false
            hosting.view.widthAnchor.constraint(equalToConstant: 100).isActive = true
            hosting.view.heightAnchor.constraint(equalToConstant: 140).isActive = true
            stack.addArrangedSubview(hosting.view)
        }

        scroll.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: scroll.topAnchor),
            stack.bottomAnchor.constraint(equalTo: scroll.bottomAnchor),
            stack.leadingAnchor.constraint(equalTo: scroll.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: scroll.trailingAnchor, constant: -16),
            stack.heightAnchor.constraint(equalTo: scroll.heightAnchor)
        ])

        scroll.heightAnchor.constraint(equalToConstant: 140).isActive = true
        contentStack.addArrangedSubview(scroll)
    }

    @objc private func toggleWatchlist() {
        WatchlistManager.shared.toggle(viewModel.movieID)
        reloadUI()
    }
}

extension MovieDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.similarMovies.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let movie = viewModel.similarMovies[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SimilarMovieCell", for: indexPath) as! SimilarMovieCell
        cell.configure(with: movie)
        return cell
    }
}
