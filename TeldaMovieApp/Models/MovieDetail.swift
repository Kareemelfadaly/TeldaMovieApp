//
//  MovieDetail.swift
//  TeldaMovieApp
//
//  Created by Kareem Elfadaly on 24/04/2025.
//

struct MovieDetail: Codable {
    let id: Int
    let title: String
    let overview: String
    let tagline: String?
    let revenue: Int?
    let releaseDate: String
    let status: String
    let posterPath: String?

    enum CodingKeys: String, CodingKey {
        case id, title, overview, tagline, revenue, status
        case releaseDate = "release_date"
        case posterPath = "poster_path"
    }
}
