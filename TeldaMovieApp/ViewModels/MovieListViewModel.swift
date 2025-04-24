//
//  MovieListViewModel.swift
//  TeldaMovieApp
//
//  Created by Kareem Elfadaly on 24/04/2025.
//

import Foundation

import Foundation

final class MovieListViewModel {
    private var allMovies: [Movie] = []

    /// Movies grouped by release year
    private(set) var groupedMovies: [String: [Movie]] = [:]

    /// Callback to update UI on data change
    var onUpdate: (() -> Void)?

    /// Fetch the most popular movies from TMDB
    func fetchPopularMovies() {
        let url = APIEndpoints.popularMovies()
        fetchMovies(from: url)
    }

    /// Search movies by title query
    func searchMovies(query: String) {
        let url = APIEndpoints.searchMovies(query: query)
        fetchMovies(from: url)
    }

    private func fetchMovies(from url: String) {
        NetworkManager.shared.request(urlString: url) { [weak self] (result: Result<MovieResponse, Error>) in
            guard let self = self else { return }

            switch result {
            case .success(let response):
                self.groupMoviesByYear(response.results)
            case .failure(let error):
                print("⚠️ Failed to fetch movies: \(error.localizedDescription)")
                // TODO: Handle user-visible error state
            }
        }
    }

    /// Group movies into sections based on release year
    private func groupMoviesByYear(_ movies: [Movie]) {
        self.allMovies = movies
        self.groupedMovies = Dictionary(grouping: movies) { $0.releaseYear }

        DispatchQueue.main.async {
            self.onUpdate?()
        }
    }

    // MARK: - Table View Accessors

    func numberOfSections() -> Int {
        groupedMovies.keys.count
    }

    func titleForSection(_ section: Int) -> String {
        groupedMovies.keys.sorted()[section]
    }

    func numberOfRows(in section: Int) -> Int {
        let key = titleForSection(section)
        return groupedMovies[key]?.count ?? 0
    }

    func movie(at indexPath: IndexPath) -> Movie {
        let year = titleForSection(indexPath.section)
        return groupedMovies[year]?[indexPath.row] ?? allMovies[indexPath.row] // Fallback shouldn't happen
    }

    func isMovieInWatchlist(_ movie: Movie) -> Bool {
        WatchlistManager.shared.isInWatchlist(movie.id)
    }
}
