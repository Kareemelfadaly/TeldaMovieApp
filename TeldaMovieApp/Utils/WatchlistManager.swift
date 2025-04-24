//
//  WatchlistManager.swift
//  TeldaMovieApp
//
//  Created by Kareem Elfadaly on 24/04/2025.
//


import Foundation

final class WatchlistManager {
    static let shared = WatchlistManager()
    private let key = "watchlist_movie_ids"

    private init() {}

    var watchlist: Set<Int> {
        get {
            let ids = UserDefaults.standard.array(forKey: key) as? [Int] ?? []
            return Set(ids)
        }
        set {
            UserDefaults.standard.set(Array(newValue), forKey: key)
        }
    }

    func isInWatchlist(_ id: Int) -> Bool {
        return watchlist.contains(id)
    }

    func toggle(_ id: Int) {
        var current = watchlist
        if current.contains(id) {
            current.remove(id)
        } else {
            current.insert(id)
        }
        watchlist = current
    }
}