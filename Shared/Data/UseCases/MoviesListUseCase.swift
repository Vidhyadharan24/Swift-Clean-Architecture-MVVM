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

    private let moviesRepository: MoviesListRepository

    init(moviesRepository: MoviesListRepository) {
        self.moviesRepository = moviesRepository
    }

    func execute(requestValue: MoviesListUseCaseRequestValue,
                 cached: @escaping (MoviesListResponseEntity) -> Void,
                 completion: @escaping (Result<MoviesListResponseEntity, Error>) -> Void) -> Cancellable? {

        return moviesRepository.fetchMoviesList(category: requestValue.category,
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
