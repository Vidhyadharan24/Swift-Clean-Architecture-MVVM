//
//  AppCoordinator.swift
//  Clean Architechure MVVM
//
//  Created by Vidhyadharan on 07/03/21.
//

import UIKit

final class AppCoordinator {

    var navigationController: UINavigationController
    private let appDIContainer: AppDIContainer
    
    init(navigationController: UINavigationController,
         appDIContainer: AppDIContainer) {
        self.navigationController = navigationController
        self.appDIContainer = appDIContainer
    }

    func start() {
        let moviesSceneDIContainer = appDIContainer.makeMoviesSceneDIContainer()
        let coordinator = moviesSceneDIContainer.makeMoviesListCoordinator(navigationController: navigationController)
        coordinator.start()
    }
}
