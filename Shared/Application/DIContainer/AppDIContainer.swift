//
//  DIContainer.swift
//  UIKit-Example
//
//  Created by Vidhyadharan on 07/03/21.
//

import Foundation

final class AppDIContainer {
    
    lazy var appConfig = AppConfig()
    
    // MARK: - Network
    lazy var apiDecodableService: NetworkDecodableServiceProtocol = {
        let config = ApiConfig(baseURL: appConfig.apiBaseURL,
                               queryParameters: ["api_key": appConfig.apiKey,
                                                 "language": NSLocale.preferredLanguages.first ?? "en"])
        
        let apiDataService = NetworkDataService(config: config)
        return NetworkDecodableService(with: apiDataService)
    }()
    lazy var imageDecodableService: NetworkDecodableServiceProtocol = {
        let config = ApiConfig(baseURL: appConfig.imagesBaseURL)
        let imagesDataService = NetworkDataService(config: config)
        return NetworkDecodableService(with: imagesDataService)
    }()
    
    // MARK: - DIContainers of scenes
    func makeMoviesSceneDIContainer() -> MoviesSceneDIContainer {
        let dependencies = MoviesSceneDIContainer.Dependencies(apiDecodableService: apiDecodableService,
                                                               imageDecodableService: imageDecodableService)
        return MoviesSceneDIContainer(dependencies: dependencies)
    }
}
