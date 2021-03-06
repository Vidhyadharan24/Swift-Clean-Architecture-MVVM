//
//  MoviesResponseEntity.swift
//  Clean Architechure MVVM
//
//  Created by Vidhyadharan on 05/03/21.
//

import Foundation
import CoreData

public class MoviesResponseEntity: NSManagedObject, Codable {
    
    private enum CodingKeys: String, CodingKey {
        case page
        case totalPages = "total_pages"
        case movies = "results"
    }
        
    required convenience public init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.context] as? NSManagedObjectContext else {
            throw NetworkEntityServiceError.missingManagedObjectContext
        }

        self.init(context: context)

        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.page = try container.decode(Int32.self, forKey: .page)
        self.totalPages = try container.decode(Int32.self, forKey: .totalPages)
        self.movies = try container.decode(Set<MovieEntity>.self, forKey: .movies) as NSSet
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(page, forKey: .page)
        try container.encode(totalPages, forKey: .totalPages)
        try container.encode(movies as! Set<MovieEntity>, forKey: .movies)

    }
    
}
