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
}

protocol MovieListPresenterProtocol: AnyObject {
    init(view: MovieListViewProtocol,
         router: RouterProtocol)
    func viewDidLoad()
    func getItem(at index: Int) -> PreviewMovieModel
    func itemsCount() -> Int
    func showMovieDetail(with id: Int)
    func searchItems(_ searchText: String)
    func sortPosts(by criterion: SortType)
    func pagination()
    func selectedSortType() -> SortType
    func getCurrentPage() -> Int
    func resetCurrentPage()
}

class MovieListPresenter: MovieListPresenterProtocol {
    
    //MARK: - Properties -
    weak var view: MovieListViewProtocol?
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
    private var isPagination = false
    private var selectedSort = SortType.defaultSort
    
    //MARK: - Life Cycle -
    required init(view: MovieListViewProtocol,
                  router: RouterProtocol) {
        self.view = view
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
    
    func searchItems(_ searchText: String) {
        self.searchText = searchText
        if isSearchActive {
            workItem?.cancel()
            let localWorkItem = DispatchWorkItem { [weak self] in
                self?.updateSearchResults()
            }
            DispatchQueue.global().asyncAfter(deadline: .now() + 1, execute: localWorkItem)
            workItem = localWorkItem
        } else {
            view?.scrollToTop()
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
        view?.scrollToTop()
    }
    
    func pagination() {
        currentPage += 1
        isPagination = true
        isSearchActive ? getSearchMovies() : getPreviewPosts()
    }
    
    func resetCurrentPage() {
        currentPage = 1
    }
    
    //MARK: - Private -
    private func getPreviewPosts() {
        let endpoint = EndPoint.list(sort: selectedSort.title,
                                     page: currentPage)
        NetworkService.shared.request(endPoint: endpoint,
                                      expecting: PreviewMovieListModel.self) { [weak self] result in
            self?.view?.hideActivityIndicator()
            switch result {
            case .success(let result):
                if let result = result {
                    DispatchQueue.main.async { [weak self] in
                        if self?.isPagination == true {
                            self?.movies.append(contentsOf: result.results)
                        } else {
                            self?.movies = result.results
                        }
                        self?.isPagination = false
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
        NetworkService.shared.request(endPoint: endpoint,
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
    
    private func getSearchMovies() {
        let endpoint = EndPoint.searchMovies(query: searchText,
                                             page: currentPage)
        NetworkService.shared.request(endPoint: endpoint,
                                      expecting: PreviewMovieListModel.self) { [weak self] result in
            self?.view?.hideActivityIndicator()
            switch result {
            case .success(let result):
                if let result = result {
                    DispatchQueue.main.async { [weak self] in
                        if self?.isPagination == true {
                            self?.searchResults.append(contentsOf: result.results)
                        } else {
                            if result.results.count == 0 {
                                self?.view?.displayError("Failed Search")
                            }
                            self?.searchResults = result.results
                        }
                        self?.isPagination = false
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
        isSearchActive ? getSearchMovies() : getPreviewPosts()
        if itemsCount() > 1 {
            view?.scrollToTop()
        }
    }
}

