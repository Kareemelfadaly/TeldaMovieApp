//
//  MovieDetailCoordinator.swift
//  TeldaMovieApp
//
//  Created by Kareem Elfadaly on 24/04/2025.
//

import UIKit

class MovieDetailCoordinator {
    let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start(movieID: Int) {
        let viewModel = MovieDetailViewModel(movieID: movieID)
        let vc = MovieDetailViewController(viewModel: viewModel)
        navigationController.pushViewController(vc, animated: true)
    }
}
