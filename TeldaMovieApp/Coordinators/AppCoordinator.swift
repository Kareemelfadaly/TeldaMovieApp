//
//  AppCoordinator.swift
//  TeldaMovieApp
//
//  Created by Kareem Elfadaly on 24/04/2025.
//

import UIKit

class AppCoordinator {
    var window: UIWindow?
    var navigationController: UINavigationController?

    func start(in window: UIWindow) {
        self.window = window
        let nav = UINavigationController()
        self.navigationController = nav
        window.rootViewController = nav
        window.makeKeyAndVisible()
        showMovieList()
    }

    func showMovieList() {
        let movieListCoordinator = MovieListCoordinator(navigationController: navigationController!)
        movieListCoordinator.start()
    }
}
