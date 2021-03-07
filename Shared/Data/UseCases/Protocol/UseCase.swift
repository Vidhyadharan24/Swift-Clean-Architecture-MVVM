//
//  UseCase.swift
//  UIKit-Example
//
//  Created by Vidhyadharan on 07/03/21.
//

import Foundation

public protocol UseCase {
    @discardableResult
    func start() -> Cancellable?
}
