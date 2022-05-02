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
}

protocol MovieListPresenterProtocol: AnyObject {
    init(view: MovieListViewProtocol,
         router: RouterProtocol)
    func viewDidLoad()
    func search(with searhText: String)
    func item(at index: Int) -> PreviewMovieModel
    func itemsCount() -> Int
    func showMovieDetail()
    func searchItems(_ searchText: String)
    func sortPosts(by criterion: SortType)
    func pagination()
    func selectedSortType() -> SortType 
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
    
    func search(with searhText: String) {
        updateSearchResults(searhText)
    }
    
    func item(at index: Int) -> PreviewMovieModel {
        return movies[index]
    }
    
    func selectedSortType() -> SortType {
        return selectedSort
    }
    
    func itemsCount() -> Int {
        return dataSource.count
    }
    
    func showMovieDetail() {
        //TODO: make prepare movie detail
        //        router?.showMovieDetailViewController()
    }
    
    func searchItems(_ searchText: String) {
        self.searchText = searchText
        if isSearchActive {
            workItem?.cancel()
            let localWorkItem = DispatchWorkItem { [weak self] in
                self?.search(with: searchText)
            }
            DispatchQueue.global().asyncAfter(deadline: .now() + 1, execute: localWorkItem)
            workItem = localWorkItem
        }
        view?.update()
                
    }
    
    func sortPosts(by criterion: SortType) {
        switch criterion {
        case .dateSort:
            selectedSort = .dateSort
        case .ratingSort:
            selectedSort = .ratingSort
            getting()
        case .defaultSort:
            selectedSort = .defaultSort
        }
        getPreviewPosts()
    }
    
    func pagination() {
        currentPage += 1
        isPagination = true
        getPreviewPosts()
    }
    
    //MARK: - Private -
    private func getPreviewPosts() {
        let endpoint = EndPoint.list(sort: selectedSort.title,
                                     page: currentPage)
        NetworkService.shared.request(endPoint: endpoint,
                                      expecting: PreviewMovieListModel.self) { result in
            switch result {
            case .success(let result):
                if let result = result {
                    DispatchQueue.main.async { [weak self] in
                        if ((self?.isPagination) != nil) {
                            self?.movies.append(contentsOf: result.results)
                            self?.isPagination.toggle()
                        } else {
                            self?.movies = result.results
                        }
                        self?.view?.update()
                    }
                }
            case .failure(let error):
                self.view?.displayError(error.localizedDescription)
            }
        }
    }
    
    private func getting() {
        let endpoint = EndPoint.list(sort: SortType.ratingSort.title,
                                     page: 1)
        NetworkService.shared.request(endPoint: endpoint,
                                      expecting: PreviewMovieListModel.self) { result in
            switch result {
            case .success(let result):
                if let result = result {
                    DispatchQueue.main.async { [weak self] in
//                        if ((self?.isPagination) != nil) {
//                            self?.movies.append(contentsOf: result.results)
//                            self?.isPagination.toggle()
//                        } else {
//                            self?.movies = result.results
//                        }
//                        self?.view?.update()
                        print(result)
                    }
                } else {
                    print("хуйня")
                }
            case .failure(let error):
                self.view?.displayError(error.localizedDescription)
            }
        }
    }
    
    private func getGenres() {
        let endpoint = EndPoint.genres
        NetworkService.shared.request(endPoint: endpoint,
                                      expecting: GenreListModel.self) { result in
            switch result {
            case .success(let result):
                if let result = result {
                    DispatchQueue.main.async { [weak self] in
                        GenerService.shared.setGenreList(result.genres)
                        self?.view?.update()
                    }
                }
            case .failure(let error):
                self.view?.displayError(error.localizedDescription)
            }
        }
    }
    
    private func getSearchMovies(_ searchText: String) {
        let endpoint = EndPoint.searchMovies(query: searchText,
                                             page: currentPage)
        NetworkService.shared.request(endPoint: endpoint,
                                      expecting: PreviewMovieListModel.self) { result in
            switch result {
            case .success(let result):
                if let result = result {
                    DispatchQueue.main.async { [weak self] in
                        self?.searchResults = result.results
                        self?.view?.update()
                    }
                }
            case .failure(let error):
                self.view?.displayError(error.localizedDescription)
            }
        }
    }
    
    
    
    private func updateSearchResults(_ searchText: String)  {
        getSearchMovies(searchText)
        view?.update()
    }
}

