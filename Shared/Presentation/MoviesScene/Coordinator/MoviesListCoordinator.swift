//
//  MoviesListCoordinator.swift
//  UIKit-Example
//
//  Created by Vidhyadharan on 07/03/21.
//

import UIKit

protocol MoviesListCoordinatorDependencies  {
    func makeMoviesListViewController(actions: MoviesListViewModelActions) -> MoviesListViewController
    func makeMoviesDetailsViewController(movie: MovieEntity) -> UIViewController
}

final class MoviesListCoordinator {
    
    private weak var navigationController: UINavigationController?
    private let dependencies: MoviesListCoordinatorDependencies

    private weak var moviesListVC: MoviesListViewController?
    private weak var moviesQueriesSuggestionsVC: UIViewController?

    init(navigationController: UINavigationController,
         dependencies: MoviesListCoordinatorDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        let actions = MoviesListViewModelActions(showMovieDetails: showMovieDetails)
        let vc = dependencies.makeMoviesListViewController(actions: actions)

        navigationController?.pushViewController(vc, animated: false)
        moviesListVC = vc
    }

    private func showMovieDetails(movie: MovieEntity) {
        let vc = dependencies.makeMoviesDetailsViewController(movie: movie)
        navigationController?.pushViewController(vc, animated: true)
    }
}
