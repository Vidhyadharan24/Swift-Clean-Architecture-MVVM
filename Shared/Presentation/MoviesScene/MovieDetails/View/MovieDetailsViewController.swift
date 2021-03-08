//
//  MovieDetailsViewController.swift
//  ExampleMVVM
//
//  Created by Oleh Kudinov on 04.08.19.
//  Copyright (c) 2019 All rights reserved.
//

import UIKit

final class MovieDetailsViewController: UIViewController, StoryboardInstantiable {

    @IBOutlet private var offlineView: UILabel!
    @IBOutlet private var offlineViewTopConstraint: NSLayoutConstraint!
    @IBOutlet private var movieImageView: UIImageView!
    @IBOutlet private var overviewValueLabel: UILabel!
    @IBOutlet private var scrollView: UIScrollView!
    @IBOutlet private var titleLabel: UILabel!

    // MARK: - Lifecycle

    private var viewModel: MovieDetailsViewModelProtocol!
    
    static func create(with viewModel: MovieDetailsViewModelProtocol) -> MovieDetailsViewController {
        let view = MovieDetailsViewController.instantiateViewController()
        view.viewModel = viewModel
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bind(to: viewModel)
    }

    private func bind(to viewModel: MovieDetailsViewModelProtocol) {
        viewModel.posterImage.observe(on: self) { [weak self] in self?.movieImageView.image = $0.flatMap(UIImage.init) }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        viewModel.updatePosterImage(width: Int(movieImageView.imageSizeAfterAspectFit.scaledSize.width))
    }

    // MARK: - Private

    private func setupViews() {
        title = viewModel.title
        
        offlineViewTopConstraint.constant = -offlineView.frame.height
        titleLabel.text = viewModel.title
        overviewValueLabel.text = viewModel.overview
        movieImageView.isHidden = viewModel.isPosterImageHidden
//        view.accessibilityIdentifier = AccessibilityIdentifier.movieDetailsView
    }
}
