//
//  MoviesListViewModel.swift
//  UIKit-Example
//
//  Created by Vidhyadharan on 07/03/21.
//

import Foundation

struct MoviesListViewModelActions {
    let showMovieDetails: (MovieEntity) -> Void
}

enum MoviesListViewModelLoading {
    case fullScreen
    case refresh
    case nextPage
}

protocol MoviesListViewModelInputProtocol {
    func viewDidLoad()
    func refresh()
    func didLoadNextPage()
    func didChangeList(to category: MoviesListCategory)
    func didSelectItem(at index: Int)
}

protocol MoviesListViewModelOutputProtocol {
    var items: Observable<[MoviesListItemViewModel]> { get }
    var loading: Observable<MoviesListViewModelLoading?> { get }
    var category: Observable<MoviesListCategory> { get }
    var error: Observable<String> { get }
    var isEmpty: Bool { get }
    var isCached: Bool { get }
    var screenTitle: String { get }
    var emptyDataTitle: String { get }
    var errorTitle: String { get }
    var searchBarPlaceholder: String { get }
}

protocol MoviesListViewModelProtocol: MoviesListViewModelInputProtocol, MoviesListViewModelOutputProtocol {}

final class MoviesListViewModel: MoviesListViewModelProtocol {

    private let moviesListUseCase: MoviesListUseCaseProtocol
    private let actions: MoviesListViewModelActions?

    var currentPage: Int = 0
    var totalPageCount: Int = 1
    var hasMorePages: Bool { currentPage < totalPageCount }
    var nextPage: Int { hasMorePages ? currentPage + 1 : currentPage }

    private var pages: [MoviesListResponseEntity] = []
    private var moviesLoadTask: Cancellable? { willSet { moviesLoadTask?.cancel() } }

    // MARK: - OUTPUT

    let items: Observable<[MoviesListItemViewModel]> = Observable([])
    let loading: Observable<MoviesListViewModelLoading?> = Observable(.none)
    let category: Observable<MoviesListCategory> = Observable(.popular)
    let error: Observable<String> = Observable("")
    var isEmpty: Bool { return items.value.isEmpty }
    var isCached: Bool = false
    let screenTitle = NSLocalizedString("Movies", comment: "")
    let emptyDataTitle = NSLocalizedString("Search results", comment: "")
    let errorTitle = NSLocalizedString("Error", comment: "")
    let searchBarPlaceholder = NSLocalizedString("Search Movies", comment: "")

    // MARK: - Init

    init(moviesListUseCase: MoviesListUseCaseProtocol,
         actions: MoviesListViewModelActions? = nil) {
        self.moviesListUseCase = moviesListUseCase
        self.actions = actions
    }
    
    // MARK: - Private

    private func appendPage(_ moviesPage: MoviesListResponseEntity) {
        currentPage = Int(moviesPage.page)
        totalPageCount = Int(moviesPage.totalPages)

        pages = pages
            .filter { $0.page != moviesPage.page }
            + [moviesPage]

        items.value = pages.movies.map(MoviesListItemViewModel.init)
    }

    private func resetPages() {
        isCached = false
        currentPage = 0
        totalPageCount = 1
        pages.removeAll()
        items.value.removeAll()
    }

    private func load(moviesListCategory: MoviesListCategory, loading: MoviesListViewModelLoading) {
        self.loading.value = loading
        category.value = moviesListCategory

        moviesLoadTask = moviesListUseCase.execute(
            requestValue: .init(category: moviesListCategory, page: nextPage),
            cached: appendPage,
            completion: { result in
                switch result {
                case .success(let page):
                    self.isCached = false
                    self.appendPage(page)
                case .failure(let error):
                    if (self.items.value.count > 0) {
                        self.isCached = true
                    }
                    self.handle(error: error)
                }
                self.loading.value = .none
        })
    }

    private func handle(error: Error) {
        self.error.value = error.isInternetConnectionError ?
            NSLocalizedString("No internet connection", comment: "") :
            NSLocalizedString("Failed loading movies", comment: "")
    }

    private func update(moviesListCategory: MoviesListCategory) {
        resetPages()
        load(moviesListCategory: moviesListCategory, loading: .fullScreen)
    }
    
    private func refresh(moviesListCategory: MoviesListCategory) {
        resetPages()
        load(moviesListCategory: moviesListCategory, loading: .refresh)
    }
}

// MARK: - INPUT. View event methods

extension MoviesListViewModel {

    func viewDidLoad() {
        didChangeList(to: .popular)
    }
    
    func refresh() {
        refresh(moviesListCategory: category.value)
    }

    func didLoadNextPage() {
        guard hasMorePages, loading.value == .none else { return }
        load(moviesListCategory: category.value,
             loading: .nextPage)
    }

    func didChangeList(to category: MoviesListCategory) {
        update(moviesListCategory: category)
    }

    func didSelectItem(at index: Int) {
        actions?.showMovieDetails(pages.movies[index])
    }
}

// MARK: - Private

private extension Array where Element == MoviesListResponseEntity {
    var movies: [MovieEntity] {
        return (flatMap { $0.movies as! Set<MovieEntity> }).sorted {$0.sortOrder < $1.sortOrder}
    }
}
