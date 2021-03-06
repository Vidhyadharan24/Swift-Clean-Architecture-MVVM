//
//  MoviesListRequest.swift
//  Clean Architechure MVVM
//
//  Created by Vidhyadharan on 02/03/21.
//

import Foundation

struct MoviesListRequest: Encodable {
    let category: String
    let page: Int32
}
