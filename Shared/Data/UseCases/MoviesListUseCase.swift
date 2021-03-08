//
//  SearchMoviesUseCase.swift
//  UIKit-Example
//
//  Created by Vidhyadharan on 07/03/21.
//

import Foundation

protocol MoviesListUseCaseProtocol {
    func execute(requestValue: MoviesListUseCaseRequestValue,
                 cached: @escaping (MoviesListResponseEntity) -> Void,
                 completion: @escaping (Result<MoviesListResponseEntity, Error>) -> Void) -> Cancellable?
}

final class MoviesListUseCase: MoviesListUseCaseProtocol {

    private let moviesListRepository: MoviesListRepositoryProtocol

    init(moviesListRepository: MoviesListRepositoryProtocol) {
        self.moviesListRepository = moviesListRepository
    }

    func execute(requestValue: MoviesListUseCaseRequestValue,
                 cached: @escaping (MoviesListResponseEntity) -> Void,
                 completion: @escaping (Result<MoviesListResponseEntity, Error>) -> Void) -> Cancellable? {

        return moviesListRepository.fetchMoviesList(category: requestValue.category,
                                                    page: requestValue.page,
                                                    cached: cached,
                                                    completion: { result in
            completion(result)
        })
    }
}

struct MoviesListUseCaseRequestValue {
    let category: MoviesListCategory
    let page: Int
}
