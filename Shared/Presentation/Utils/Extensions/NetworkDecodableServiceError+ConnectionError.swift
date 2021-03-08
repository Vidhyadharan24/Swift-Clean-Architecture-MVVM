//
//  NetworkDecodableServiceError+ConnectionError.swift
//  UIKit-Example
//
//  Created by Vidhyadharan on 07/03/21.
//

import Foundation

extension NetworkDecodableServiceError: ConnectionError {
    public var isInternetConnectionError: Bool {
        guard case let NetworkDecodableServiceError.networkFailure(networkError) = self,
            case .notConnected = networkError else {
                return false
        }
        return true
    }
}
