//
//  UIViewController+make.swift
//  UIKit-Example
//
//  Created by Vidhyadharan on 07/03/21.
//

import UIKit

extension UITableViewController {

    func makeActivityIndicator(size: CGSize) -> UIActivityIndicatorView {
        let style: UIActivityIndicatorView.Style = UIActivityIndicatorView.Style.medium

        let activityIndicator = UIActivityIndicatorView(style: style)
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
        activityIndicator.frame = .init(origin: .zero, size: size)

        return activityIndicator
    }
}
