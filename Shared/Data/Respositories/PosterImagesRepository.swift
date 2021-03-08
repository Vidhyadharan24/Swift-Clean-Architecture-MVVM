//
//  PosterImagesRepositoryInterface.swift
//  UIKit-Example
//
//  Created by Vidhyadharan on 06/03/21.
//

import Foundation

protocol PosterImagesRepositoryProtocol {
    func fetchImage(with imagePath: String, width: Int, completion: @escaping (Result<Data, Error>) -> Void) -> Cancellable?
}

final class PosterImagesRepository {
    
    private let networkDecodableService: NetworkDecodableServiceProtocol

    init(networkDecodableService: NetworkDecodableServiceProtocol) {
        self.networkDecodableService = networkDecodableService
    }
}

extension PosterImagesRepository: PosterImagesRepositoryProtocol {
    
    func fetchImage(with imagePath: String, width: Int, completion: @escaping (Result<Data, Error>) -> Void) -> Cancellable? {
        
        let endpoint = APIEndpoints.getMoviePoster(path: imagePath, width: width)
        let task = RepositoryTask()
        task.networkTask = networkDecodableService.request(with: endpoint) { (result: Result<Data, NetworkDecodableServiceError>) in

            let result = result.mapError { $0 as Error }
            DispatchQueue.main.async { completion(result) }
        }
        return task
    }
}
