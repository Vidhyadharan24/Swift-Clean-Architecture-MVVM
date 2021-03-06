//
//  MoviesListResponseEntity+Mapping.swift
//  UIKit-Example
//
//  Created by Vidhyadharan on 06/03/21.
//

import Foundation
import CoreData

extension MoviesListResponseEntity {
    convenience init(moviesListResponse: MoviesListResponse, insertInto context: NSManagedObjectContext) {
        self.init(context: context)
        
        page = Int32(moviesListResponse.page)
        totalPages = Int32(moviesListResponse.totalPages)
        
        moviesListResponse.results.forEach {
            let movieEntity = $0.toEntity(movie: $0, in: context)
            self.addToMovies(movieEntity)
        }
    }
}

extension Movie {
    func toEntity(movie: Movie, in context: NSManagedObjectContext) -> MovieEntity {
        let movieEntity = MovieEntity(context: context)
        movieEntity.id = String(movie.id)
        movieEntity.overview = movie.overview
        movieEntity.popularity = movie.popularity
        movieEntity.posterPath = movie.posterPath
        movieEntity.title = movie.title
        
        return movieEntity
    }
}
