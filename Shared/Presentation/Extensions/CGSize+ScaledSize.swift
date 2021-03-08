//
//  CGSize+ScaledSize.swift
//  UIKit-Example
//
//  Created by Vidhyadharan on 07/03/21.
//

import Foundation
import UIKit

extension CGSize {
    var scaledSize: CGSize {
        .init(width: width * UIScreen.main.scale, height: height * UIScreen.main.scale)
    }
}
