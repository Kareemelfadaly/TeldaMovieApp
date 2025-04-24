//
//  Crew.swift
//  TeldaMovieApp
//
//  Created by Kareem Elfadaly on 24/04/2025.
//

struct Crew: Codable {
    let id: Int
    let name: String
    let job: String
    let department: String
    let popularity: Double
    let profilePath: String?

    enum CodingKeys: String, CodingKey {
        case id, name, job, department, popularity
        case profilePath = "profile_path"
    }
}
