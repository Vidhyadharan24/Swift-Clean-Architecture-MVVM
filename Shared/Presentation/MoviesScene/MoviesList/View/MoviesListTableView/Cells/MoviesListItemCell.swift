//
//  MoviesListItemCell.swift
//  UIKit-Example
//
//  Created by Vidhyadharan on 07/03/21.
//

import UIKit

final class MoviesListItemCell: UITableViewCell {

    static let reuseIdentifier = String(describing: MoviesListItemCell.self)
    static let height = CGFloat(130)

    @IBOutlet weak var parentContainerView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!

    private var viewModel: MoviesListItemViewModel!
    private var posterImagesRepository: PosterImagesRepositoryProtocol?
    private var imageLoadTask: Cancellable?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
        
        self.containerView.layer.cornerRadius = 15
        self.containerView.layer.masksToBounds = true
        
        self.parentContainerView.backgroundColor = .clear
        self.parentContainerView.layer.shadowColor = UIColor.black.cgColor
        self.parentContainerView.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        self.parentContainerView.layer.shadowOpacity = 0.2
        self.parentContainerView.layer.shadowRadius = 4
    }

    func fill(with viewModel: MoviesListItemViewModel, posterImagesRepository: PosterImagesRepositoryProtocol?) {
        self.viewModel = viewModel
        self.posterImagesRepository = posterImagesRepository

        titleLabel.text = viewModel.title
        updatePosterImage(width: Int(movieImageView.imageSizeAfterAspectFit.scaledSize.width))
    }

    private func updatePosterImage(width: Int) {
        movieImageView.image = nil
        guard let posterImagePath = viewModel.posterImagePath else { return }

        imageLoadTask = posterImagesRepository?.fetchImage(with: posterImagePath, width: width) { [weak self] result in
            guard let self = self else { return }
            guard self.viewModel.posterImagePath == posterImagePath else { return }
            if case let .success(data) = result {
                self.movieImageView.image = UIImage(data: data)
            }
            self.imageLoadTask = nil
        }
    }
}
