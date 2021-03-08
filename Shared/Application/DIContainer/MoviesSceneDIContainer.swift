//
//  MoviesSceneDIContainer.swift
//  UIKit-Example
//
//  Created by Vidhyadharan on 07/03/21.
//

import UIKit
import SwiftUI

final class MoviesSceneDIContainer {
    
    struct Dependencies {
        let apiDecodableService: NetworkDecodableServiceProtocol
        let imageDecodableService: NetworkDecodableServiceProtocol
    }
    
    private let dependencies: Dependencies

    // MARK: - Persistent Storage
    lazy var moviesResponseCache: MoviesListStorageServiceProtocol = MoviesListStorageService()

    init(dependencies: Dependencies) {
        self.dependencies = dependencies        
    }
    
    // MARK: - Use Cases
    func makeMoviesListUseCase() -> MoviesListUseCaseProtocol {
        return MoviesListUseCase(moviesListRepository: makeMoviesListRepository())
    }
        
    // MARK: - Repositories
    func makeMoviesListRepository() -> MoviesListRepositoryProtocol {
        return MoviesListRepository(networkDecodableService: dependencies.apiDecodableService, cache: moviesResponseCache)
    }
    func makePosterImagesRepository() -> PosterImagesRepositoryProtocol {
        return PosterImagesRepository(networkDecodableService: dependencies.imageDecodableService)
    }
    
    // MARK: - Movies List
    func makeMoviesListViewController(actions: MoviesListViewModelActions) -> MoviesListViewController {
        return MoviesListViewController.create(with: makeMoviesListViewModel(actions: actions),
                                               posterImagesRepository: makePosterImagesRepository())
    }
    
    func makeMoviesListViewModel(actions: MoviesListViewModelActions) -> MoviesListViewModel {
        return MoviesListViewModel(moviesListUseCase: makeMoviesListUseCase(), actions: actions)
    }
    
    // MARK: - Movie Details
    func makeMoviesDetailsViewController(movie: MovieEntity) -> MovieDetailsViewController {
        return MovieDetailsViewController.create(with: makeMoviesDetailsViewModel(movie: movie))
    }

    func makeMoviesDetailsViewModel(movie: MovieEntity) -> MovieDetailsViewModelProtocol {
        return MovieDetailsViewModel(movie: movie,
                                     posterImagesRepository: makePosterImagesRepository())
    }
    
    // MARK: - Coordinators
    func makeMoviesListCoordinator(navigationController: UINavigationController) -> MoviesListCoordinator {
        return MoviesListCoordinator(navigationController: navigationController,
                                     dependencies: self)
    }
}

extension MoviesSceneDIContainer: MoviesListCoordinatorDependencies {}
