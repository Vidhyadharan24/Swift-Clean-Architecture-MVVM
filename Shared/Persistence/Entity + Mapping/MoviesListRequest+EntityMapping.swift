//
//  MoviesListRequest+EntityMapping.swift
//  Clean Architechure MVVM
//
//  Created by Vidhyadharan on 06/03/21.
//

import Foundation
import CoreData

extension MoviesListRequest {
    func toEntity(in context: NSManagedObjectContext) -> MoviesListRequestEntity {
        let entity = MoviesListRequestEntity(context: context)
        entity.page = page
        entity.category = category
        return entity
    }
}
