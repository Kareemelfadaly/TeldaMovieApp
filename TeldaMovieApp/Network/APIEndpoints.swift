//
//  APIEndpoints.swift
//  TeldaMovieApp
//
//  Created by Kareem Elfadaly on 24/04/2025.
//

import Foundation

enum APIEndpoints {
    static let apiKey = "5d27a6bf138f92efb103acfc036b7bde"

    static func popularMovies() -> String {
        return "https://api.themoviedb.org/3/movie/popular?api_key=\(apiKey)"
    }

    static func searchMovies(query: String) -> String {
        let escaped = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query
        return "https://api.themoviedb.org/3/search/movie?api_key=\(apiKey)&query=\(escaped)"
    }

    static func movieDetails(id: Int) -> String {
        return "https://api.themoviedb.org/3/movie/\(id)?api_key=\(apiKey)"
    }

    static func similarMovies(id: Int) -> String {
        return "https://api.themoviedb.org/3/movie/\(id)/similar?api_key=\(apiKey)"
    }

    static func movieCredits(id: Int) -> String {
        return "https://api.themoviedb.org/3/movie/\(id)/credits?api_key=\(apiKey)"
    }
}
