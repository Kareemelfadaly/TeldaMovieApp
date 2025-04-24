//
//  CreditsResponse.swift
//  TeldaMovieApp
//
//  Created by Kareem Elfadaly on 24/04/2025.
//


struct CreditsResponse: Codable {
    let cast: [Cast]
    let crew: [Crew]
}