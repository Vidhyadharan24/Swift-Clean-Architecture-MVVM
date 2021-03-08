//
//  MoviesListViewController.swift
//  Movie-DB
//
//  Created by Vidhyadharan on 23/12/20.
//

import UIKit

class MoviesListViewController: UIViewController, StoryboardInstantiable {
        
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var offlineView: UILabel!
    @IBOutlet weak var offlineViewTopConstraint: NSLayoutConstraint!
    @IBOutlet private var moviesListContainer: UIView!
    @IBOutlet weak var noDataLabel: UILabel!

    private var moviesTableViewController: MoviesListTableViewController?
    private var refreshControl = UIRefreshControl()
    
    private var viewModel: MoviesListViewModelProtocol!
    private var posterImagesRepository: PosterImagesRepositoryProtocol!

    
    static func create(with viewModel: MoviesListViewModelProtocol,
                       posterImagesRepository: PosterImagesRepositoryProtocol?) -> MoviesListViewController {
        let controller = MoviesListViewController.instantiateViewController()
        controller.viewModel = viewModel
        controller.posterImagesRepository = posterImagesRepository
        return controller
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        bind(to: viewModel)
        viewModel.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == String(describing: MoviesListTableViewController.self),
            let destinationVC = segue.destination as? MoviesListTableViewController {
            moviesTableViewController = destinationVC
            moviesTableViewController?.viewModel = viewModel
            moviesTableViewController?.posterImagesRepository = posterImagesRepository
        }
    }
    
    func setupViews() {
        segmentControl.backgroundColor = view.backgroundColor
        segmentControl.removeAllSegments()
        
        var segment = 0
        for type in MoviesListCategory.allCases {
            let title: String
            switch type {
            case .popular:
                title = NSLocalizedString("Popular", comment: "")
            case .top_rated:
                title = NSLocalizedString("Top Rated", comment: "")
            case .upcoming:
                title = NSLocalizedString("Upcoming", comment: "")
            }
            
            segmentControl.insertSegment(action: UIAction(title: title, handler: { [weak self] _ in
                self?.viewModel.didChangeList(to: type)
            }), at: segment, animated: false)
            
            segment = segment + 1
        }
                
        moviesTableViewController?.tableView.backgroundColor  = view.backgroundColor
                
        hideNoDataLabel()
        hideOfflineView()
    }
    
    private func bind(to viewModel: MoviesListViewModelProtocol) {
        viewModel.items.observe(on: self) { [weak self] _ in self?.updateItems() }
        viewModel.loading.observe(on: self) { [weak self] in self?.updateLoading($0) }
        viewModel.error.observe(on: self) { [weak self] in self?.showError($0) }
        viewModel.category.observe(on: self) { [weak self] in self?.updateCategory($0) }
    }
    
    private func updateItems() {
        moviesTableViewController?.reload()
    }
    
    private func updateCategory(_ category: MoviesListCategory) {
        let allCases = MoviesListCategory.allCases
        segmentControl.selectedSegmentIndex = allCases.firstIndex(of: category) ?? 0
    }

    private func updateLoading(_ loading: MoviesListViewModelLoading?) {
        noDataLabel.isHidden = true
        LoadingView.hide()

        switch loading {
        case .fullScreen: LoadingView.show()
        case .refresh: break
        case .nextPage: break
        case .none:
            if (viewModel.isEmpty) {
                let error = viewModel.error.value
                if error.count > 0 {
                    showNoDataLabel(text: "\(error)")
                } else {
                    showNoDataLabel(text: "Unable to retrive movie list")
                }
            } else {
                hideNoDataLabel()
            }
        
        }

        moviesTableViewController?.updateLoading(loading)
    }

    private func showError(_ error: String) {
        guard !error.isEmpty else { return }
        showNoDataLabel(text: "\(error)")
    }
        
}

private extension MoviesListViewController {
    
    func showOfflineView() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.offlineViewTopConstraint.constant = 0
        }
    }
    
    func hideOfflineView() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let height = self?.offlineView.frame.size.height else { return }
            self?.offlineViewTopConstraint.constant = -height
        }
    }
    
    func showNoDataLabel(text: String) {
        self.moviesListContainer.isHidden = true
        noDataLabel.isHidden = false
        noDataLabel.text = text
    }
    
    func hideNoDataLabel() {
        self.moviesListContainer.isHidden = false
        noDataLabel.isHidden = true
    }
}
