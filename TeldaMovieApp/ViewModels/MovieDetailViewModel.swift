//
//  MovieDetailViewModel.swift
//  TeldaMovieApp
//
//  Created by Kareem Elfadaly on 24/04/2025.
//

import Foundation

final class MovieDetailViewModel {
    let movieID: Int

    var movieDetail: MovieDetail?
    var similarMovies: [Movie] = []
    var topActors: [Cast] = []
    var topDirectors: [Crew] = []

    var onUpdate: (() -> Void)?

    init(movieID: Int) {
        self.movieID = movieID
    }

    func fetchAll() {
        fetchMovieDetail()
        fetchSimilarMoviesAndCredits()
    }

    private func fetchMovieDetail() {
        NetworkManager.shared.request(urlString: APIEndpoints.movieDetails(id: movieID)) { [weak self] (result: Result<MovieDetail, Error>) in
            if case .success(let detail) = result {
                self?.movieDetail = detail
                DispatchQueue.main.async { self?.onUpdate?() }
            }
        }
    }

    private func fetchSimilarMoviesAndCredits() {
        NetworkManager.shared.request(urlString: APIEndpoints.similarMovies(id: movieID)) { [weak self] (result: Result<MovieResponse, Error>) in
            guard case .success(let response) = result else { return }
            self?.similarMovies = Array(response.results.prefix(5))
            self?.fetchAllCredits(for: self?.similarMovies.map { $0.id } ?? [])
        }
    }

    private func fetchAllCredits(for movieIDs: [Int]) {
        var allCast: [Cast] = []
        var allCrew: [Crew] = []

        let group = DispatchGroup()
        for id in movieIDs {
            group.enter()
            NetworkManager.shared.request(urlString: APIEndpoints.movieCredits(id: id)) { (result: Result<CreditsResponse, Error>) in
                switch result {
                case .success(let credits):
                    allCast.append(contentsOf: credits.cast.filter { $0.department == "Acting" })
                    allCrew.append(contentsOf: credits.crew.filter { $0.job == "Director" })
                case .failure(let error):
                    print("Failed to fetch credits for movie \(id): \(error)")
                }
                group.leave()
            }
        }

        group.notify(queue: .main) { [weak self] in
            self?.topActors = Array(allCast.sorted(by: { $0.popularity > $1.popularity }).prefix(5))
            self?.topDirectors = Array(allCrew.sorted(by: { $0.popularity > $1.popularity }).prefix(5))
            self?.onUpdate?()
        }
    }
}
