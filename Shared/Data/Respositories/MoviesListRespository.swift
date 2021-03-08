//
//  MoviesListRespository.swift
//  UIKit-Example
//
//  Created by Vidhyadharan on 06/03/21.
//

import Foundation

enum MoviesListCategory: String, Encodable, CaseIterable {
    case upcoming
    case top_rated
    case popular
}

protocol MoviesListRepositoryProtocol {
    @discardableResult
    func fetchMoviesList(category: MoviesListCategory, page: Int,
                         cached: @escaping (MoviesListResponseEntity) -> Void,
                         completion: @escaping (Result<MoviesListResponseEntity, Error>) -> Void) -> Cancellable?
}

final class MoviesListRepository {

    private let networkDecodableService: NetworkDecodableServiceProtocol
    private let cache: MoviesListStorageServiceProtocol

    init(networkDecodableService: NetworkDecodableServiceProtocol, cache: MoviesListStorageServiceProtocol) {
        self.networkDecodableService = networkDecodableService
        self.cache = cache
    }
}

extension MoviesListRepository: MoviesListRepositoryProtocol {

    public func fetchMoviesList(category: MoviesListCategory,
                                page: Int,
                                cached: @escaping (MoviesListResponseEntity) -> Void,
                                completion: @escaping (Result<MoviesListResponseEntity, Error>) -> Void) -> Cancellable? {

        let request = MoviesListRequest(category: category, page: page)
        let task = RepositoryTask()

        cache.getResponse(for: request) { result in

            if case let .success(response?) = result {
                cached(response)
            }
            guard !task.isCancelled else { return }

            let endpoint = APIEndpoints.getMovies(with: request)
            task.networkTask = self.networkDecodableService.request(with: endpoint) { result in
                switch result {
                case .success(let response):
                    self.cache.save(response: response, for: request)
                    self.cache.getResponse(for: request) { (result) in
                        switch result {
                        case .success(let response):
                            completion(.success(response!))
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
        return task
    }
}
