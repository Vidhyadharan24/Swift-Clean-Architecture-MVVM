//
//  ApiConfig.swift
//  Clean Architechure MVVM
//
//  Created by Vidhyadharan on 27/02/21.
//

import Foundation

public struct ApiConfig {
    public let baseURL: String
    public let headers: [String: String]
    public let queryParameters: [String: String]
    
     public init(baseURL: String,
                 headers: [String: String] = [:],
                 queryParameters: [String: String] = [:]) {
        self.baseURL = baseURL
        self.headers = headers
        self.queryParameters = queryParameters
    }
}

