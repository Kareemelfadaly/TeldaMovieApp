//
//  Cast.swift
//  TeldaMovieApp
//
//  Created by Kareem Elfadaly on 24/04/2025.
//

struct Cast: Codable {
    let id: Int
    let name: String
    let popularity: Double
    let department: String
    let profilePath: String?

    enum CodingKeys: String, CodingKey {
        case id, name, popularity, department
        case profilePath = "profile_path"
    }
}
