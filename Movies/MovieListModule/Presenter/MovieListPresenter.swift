//
//  MovieListPresenter.swift
//  Movies
//
//  Created by Danylo Klymov on 28.04.2022.
//

import UIKit

protocol MovieListViewProtocol: AnyObject {
    func update()
    func displayError(_ error: String)
    func showActivityIndicator()
    func hideActivityIndicator()
    func scrollToTop()
    func loadingStart()
}

protocol MovieListPresenterProtocol: AnyObject {
    init(view: MovieListViewProtocol,
         networkService: NetworkServiceProtocol,
         router: RouterProtocol)
    func viewDidLoad()
    func getItem(at index: Int) -> PreviewMovieModel
    func itemsCount() -> Int
    func showMovieDetail(with id: Int)
    func searchItems(_ searchText: String)
    func sortPosts(by criterion: SortType)
    func loadMore()
    func selectedSortType() -> SortType
    func getCurrentPage() -> Int
    func resetCurrentPage()
    func dataSourceIsNotEmpty() -> Bool
    func getTotalResults() -> Int
}

class MovieListPresenter: MovieListPresenterProtocol {
    
    //MARK: - Properties -
    weak var view: MovieListViewProtocol?
    let networkService: NetworkServiceProtocol!
    var router: RouterProtocol?
    private var movies: [PreviewMovieModel]
    private var searchResults: [PreviewMovieModel]
    private var searchText = ""
    private var isSearchActive: Bool {
        return searchText.count >= 3
    }
    private var dataSource: [PreviewMovieModel] {
        return isSearchActive ? searchResults : movies
    }
    private var currentPage = 1
    private var workItem: DispatchWorkItem?
    private var isLoading = false
    private var selectedSort = SortType.defaultSort
    private var totalResults = 1
    
    //MARK: - Life Cycle -
    required init(view: MovieListViewProtocol,
                  networkService: NetworkServiceProtocol,
                  router: RouterProtocol) {
        self.view = view
        self.networkService = networkService
        self.router = router
        self.movies = []
        self.searchResults = []
    }
    
    //MARK: - Internal -
    func viewDidLoad() {
        getGenres()
        getPreviewPosts()
    }
    
    func getItem(at index: Int) -> PreviewMovieModel {
        return dataSource[index]
    }
    
    func getCurrentPage() -> Int {
        return currentPage
    }
    
    func getTotalResults() -> Int {
        return totalResults
    }
    
    func selectedSortType() -> SortType {
        return selectedSort
    }
    
    func itemsCount() -> Int {
        return dataSource.count
    }
    
    func showMovieDetail(with id: Int) {
        //TODO: set id
        router?.showMovieDetailViewController()
    }
    
    func dataSourceIsNotEmpty() -> Bool {
        return dataSource.isNotEmpty
    }

    func searchItems(_ searchText: String) {
        self.searchText = searchText
        if isSearchActive {
            workItem?.cancel()
            let localWorkItem = DispatchWorkItem { [weak self] in
                self?.updateSearchResults()
            }
            DispatchQueue.global().asyncAfter(deadline: .now() + 1,
                                              execute: localWorkItem)
            workItem = localWorkItem
        }
        view?.update()
    }
    
    func sortPosts(by criterion: SortType) {
        view?.showActivityIndicator()
        switch criterion {
        case .dateSort:
            selectedSort = .dateSort
        case .ratingSort:
            selectedSort = .ratingSort
        case .defaultSort:
            selectedSort = .defaultSort
        }
        resetCurrentPage()
        getPreviewPosts()
        if dataSource.isNotEmpty {
            view?.scrollToTop()
        }
    }
    
    func loadMore() {
        if !isLoading {
            view?.loadingStart()
        }
        currentPage += 1
        isLoading = true
        isSearchActive ? searchMovies() : getPreviewPosts()
    }
    
    func resetCurrentPage() {
        currentPage = 1
    }
    
    //MARK: - Private -
    private func getPreviewPosts() {
        let endpoint = EndPoint.list(sort: selectedSort.title,
                                     page: currentPage)
        networkService.request(endPoint: endpoint,
                                      expecting: PreviewMovieListModel.self) { [weak self] result in
            self?.view?.hideActivityIndicator()
            switch result {
            case .success(let result):
                if let result = result {
                    DispatchQueue.main.async { [weak self] in
                        if self?.isLoading == true {
                            self?.movies.append(contentsOf: result.results)
                        } else {
                            self?.movies = result.results
                        }
                        self?.totalResults = result.totalPages
                        self?.isLoading = false
                        self?.view?.update()
                    }
                }
            case .failure(let error):
                self?.view?.displayError("Failed to get movies: \(error)")
            }
        }
    }
    
    private func getGenres() {
        let endpoint = EndPoint.genres
        networkService.request(endPoint: endpoint,
                                      expecting: GenreListModel.self) { [weak self] result in
            switch result {
            case .success(let result):
                if let result = result {
                    DispatchQueue.main.async { [weak self] in
                        GenerService.shared.setGenreList(result.genres)
                        self?.view?.update()
                    }
                }
            case .failure(let error):
                self?.view?.displayError("Failed to get genres: \(error)")
            }
        }
    }
    
    private func searchMovies() {
        let endpoint = EndPoint.searchMovies(query: searchText,
                                             page: currentPage)
        networkService.request(endPoint: endpoint,
                                      expecting: PreviewMovieListModel.self) { [weak self] result in
            self?.view?.hideActivityIndicator()
            switch result {
            case .success(let result):
                if let result = result {
                    DispatchQueue.main.async { [weak self] in
                        if self?.isLoading == true {
                            self?.searchResults.append(contentsOf: result.results)
                        } else {
                            if result.results.count == 0 {
                                self?.view?.displayError("Failed Search")
                            }
                            self?.searchResults = result.results
                        }
                        self?.totalResults = result.totalResults
                        self?.isLoading = false
                        self?.view?.update()
                    }
                }
            case .failure(let error):
                self?.view?.displayError("Failed to search movies: \(error)")
            }
        }
    }
    
    private func updateSearchResults() {
        view?.showActivityIndicator()
        resetCurrentPage()
        isSearchActive ? searchMovies() : getPreviewPosts()
        if dataSource.isNotEmpty {
            view?.scrollToTop()
        }
    }
}

//MARK: - SortType -
enum SortType: Int, CaseIterable {
    
    var title: String {
        switch rawValue {
        case 0:
            return "popularity.desc"
        case 1:
            return "vote_count.desc"
        default:
            return "revenue.desc"
        }
    }
    
    case defaultSort = 0
    case ratingSort
    case dateSort
}
