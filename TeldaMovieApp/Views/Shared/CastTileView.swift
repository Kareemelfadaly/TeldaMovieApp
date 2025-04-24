//
//  CastTileView.swift
//  TeldaMovieApp
//
//  Created by Kareem Elfadaly on 24/04/2025.
//

import SwiftUI

struct CastTileView: View {
    let name: String
    let popularity: Double
    let profilePath: String?

    var body: some View {
        VStack(spacing: 6) {
            if let path = profilePath,
               let _ = URL(string: "https://image.tmdb.org/t/p/w500\(path)") {
                URLImage(url: URL(string: "https://image.tmdb.org/t/p/w500\(path)"))
                    .frame(width: 80, height: 80)
                    .clipShape(Circle())
            } else {
                Circle().fill(Color.gray)
                    .frame(width: 80, height: 80)
            }

            Text(name)
                .font(.caption)
                .multilineTextAlignment(.center)
                .lineLimit(2)

            Text("⭐️ \(Int(popularity))")
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .frame(width: 90)
    }
}
