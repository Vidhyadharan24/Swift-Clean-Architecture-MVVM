//
//  APIEndpoints.swift
//  Clean Architechure MVVM
//
//  Created by Vidhyadharan on 02/03/21.
//

import Foundation

struct APIEndpoints {
    
    static func getMovies(with moviesRequest: MoviesListRequest) -> Endpoint<MoviesListResponse> {

        return Endpoint(path: "3/search/movie/",
                        method: .get,
                        queryParametersEncodable: moviesRequest)
    }

    static func getMoviePoster(path: String, width: Int) -> Endpoint<Data> {

        let sizes = [92, 154, 185, 342, 500, 780]
        let closestWidth = sizes.enumerated().min { abs($0.1 - width) < abs($1.1 - width) }?.element ?? sizes.first!
        
        return Endpoint(path: "t/p/w\(closestWidth)\(path)",
                        method: .get,
                        responseDecoder: RawDataResponseDecoder())
    }
}
