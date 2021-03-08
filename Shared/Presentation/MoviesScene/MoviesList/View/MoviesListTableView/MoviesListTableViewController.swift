//
//  MoviesListTableViewController.swift
//  UIKit-Example
//
//  Created by Vidhyadharan on 07/03/21.
//

import UIKit

final class MoviesListTableViewController: UITableViewController {

    var viewModel: MoviesListViewModelProtocol!

    var posterImagesRepository: PosterImagesRepositoryProtocol?
    var nextPageLoadingSpinner: UIActivityIndicatorView?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    func reload() {
        tableView.reloadData()
    }

    func updateLoading(_ loading: MoviesListViewModelLoading?) {
        switch loading {
        case .nextPage:
            nextPageLoadingSpinner?.removeFromSuperview()
            nextPageLoadingSpinner = makeActivityIndicator(size: .init(width: tableView.frame.width, height: 44))
            tableView.tableFooterView = nextPageLoadingSpinner
        case .fullScreen, .none:
            tableView.refreshControl?.endRefreshing()
            tableView.tableFooterView = nil
        case .refresh:
            tableView.tableFooterView = nil
        }
    }

    // MARK: - Private

    private func setupViews() {
        tableView.estimatedRowHeight = MoviesListItemCell.height
        tableView.rowHeight = UITableView.automaticDimension
        
        tableView.refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }
    
    @objc private func refresh() {
        viewModel.refresh()
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension MoviesListTableViewController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items.value.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MoviesListItemCell.reuseIdentifier,
                                                       for: indexPath) as? MoviesListItemCell else {
            assertionFailure("Cannot dequeue reusable cell \(MoviesListItemCell.self) with reuseIdentifier: \(MoviesListItemCell.reuseIdentifier)")
            return UITableViewCell()
        }

        cell.fill(with: viewModel.items.value[indexPath.row],
                  posterImagesRepository: posterImagesRepository)

        if indexPath.row == viewModel.items.value.count - 1 {
            viewModel.didLoadNextPage()
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.isEmpty ? tableView.frame.height : super.tableView(tableView, heightForRowAt: indexPath)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectItem(at: indexPath.row)
    }
}
