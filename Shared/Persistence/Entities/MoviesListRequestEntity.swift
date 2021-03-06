//
//  MoviesListRequestEntity.swift
//  Clean Architechure MVVM
//
//  Created by Vidhyadharan on 05/03/21.
//

import Foundation
import CoreData

public class MoviesListRequestEntity: NSManagedObject, Codable {
    
    enum CodingKeys: String, CodingKey {
        case page
        case category
    }
    
    required convenience public init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.context] as? NSManagedObjectContext else {
            throw NetworkEntityServiceError.missingManagedObjectContext
        }

        self.init(context: context)

        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.page = try container.decode(Int32.self, forKey: .page)
        self.category = try container.decode(String.self, forKey: .category)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(page, forKey: .page)
        try container.encode(category, forKey: .category)
    }
    
}
