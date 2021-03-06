//
//  MoviesListRequestEntity+Mapping.swift
//  Clean Architechure MVVM
//
//  Created by Vidhyadharan on 06/03/21.
//

import Foundation
import CoreData

extension MoviesListRequestEntity {
    convenience init(moviesRequest: MoviesListRequest, insertInto context: NSManagedObjectContext) {
        self.init(context: context)
        category = moviesRequest.category.rawValue
        page = Int32(moviesRequest.page)
    }
}
