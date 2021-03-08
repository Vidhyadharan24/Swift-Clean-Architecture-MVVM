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
        
        var diviser = 10
        
        while moviesListResponse.results.count / diviser > 1 {
            diviser = diviser * 10
        }
        
        for (index, movie) in moviesListResponse.results.enumerated() {
            let sortOrder = moviesListResponse.page * diviser + index + 1
            let movieEntity = movie.toEntity(movie: movie, sortOrder: sortOrder, in: context)
            self.addToMovies(movieEntity)
        }
    }
}

extension Movie {
    func toEntity(movie: Movie, sortOrder: Int, in context: NSManagedObjectContext) -> MovieEntity {
        let movieEntity = MovieEntity(context: context)
        movieEntity.id = Int64(movie.id)
        movieEntity.overview = movie.overview
        movieEntity.popularity = movie.popularity
        movieEntity.posterPath = movie.posterPath
        movieEntity.title = movie.title
        movieEntity.sortOrder = Int32(sortOrder)
        
        return movieEntity
    }
}
