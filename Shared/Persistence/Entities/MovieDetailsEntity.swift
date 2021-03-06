//
//  MovieDetailsEntity.swift
//  Clean Architechure MVVM
//
//  Created by Vidhyadharan on 05/03/21.
//

import Foundation
import CoreData

public class MovieDetailsEntity: NSManagedObject, Codable {
    
    enum CodingKeys: String, CodingKey {
        case id
        case overview
        case posterPath = "poster_path"
        case title
        case originalLanguage = "original_language"
    }
    
    required convenience public init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.context] as? NSManagedObjectContext else {
            throw NetworkEntityServiceError.missingManagedObjectContext
        }

        self.init(context: context)

        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int64.self, forKey: .id)
        self.overview = try container.decode(String.self, forKey: .overview)
        self.posterPath = try container.decode(String.self, forKey: .posterPath)
        self.title = try container.decode(String.self, forKey: .title)
        self.originalLanguage = try container.decode(String.self, forKey: .originalLanguage)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(overview, forKey: .overview)
        try container.encode(posterPath, forKey: .posterPath)
        try container.encode(title, forKey: .title)
        try container.encode(originalLanguage, forKey: .originalLanguage)

    }
    
}
