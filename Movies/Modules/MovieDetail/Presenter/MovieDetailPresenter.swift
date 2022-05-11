//
//  MovieDetailPresenter.swift
//  Movies
//
//  Created by Danylo Klymov on 28.04.2022.
//

import Foundation
import UIKit

protocol MovieDetailViewProtocol: AnyObject {
    func update(with movie: MovieDetailModel)
    func displayError(_ error: String)
    func showActivityIndicator()
    func hideActivityIndicator()
}

protocol MovieDetailPresenterProtocol: AnyObject {
    init(view: MovieDetailViewProtocol,
         networkService: NetworkServiceProtocol,
         router: RouterProtocol,
         movieID: Int?)
    func viewDidLoad()
    func getTrailerKey() -> String
    func trailersAvailable() -> Bool
    func comePreviousScreen()
    func showPosterFullScreen(_ image: UIImage) 
}

class MovieDetailPresenter: MovieDetailPresenterProtocol {
    
    //MARK: - Properties -
    private weak var view: MovieDetailViewProtocol?
    private let networkService: NetworkServiceProtocol!
    private var router: RouterProtocol?
    private var movie: MovieDetailModel!
    private var movieID: Int!
    private var trailers: [TrailerIDModel]
    
    //MARK: - Life Cycle -
    required init(view: MovieDetailViewProtocol,
                  networkService: NetworkServiceProtocol,
                  router: RouterProtocol,
                  movieID: Int?) {
        self.view = view
        self.networkService = networkService
        self.router = router
        self.movieID = movieID
        self.trailers = []
    }
    
    //MARK: - Internal -
    func viewDidLoad() {
        getMovieTrailerLink()
        getDatailMovie()
    }
    
    func getTrailerKey() -> String {
        let firstVideo = 0
        return trailers[firstVideo].key
    }
    
    func trailersAvailable() -> Bool {
        return trailers.isNotEmpty
    }
    
    func comePreviousScreen() {
        router?.popToRoot()
    }
    
    func showPosterFullScreen(_ image: UIImage) {
        router?.showPosterFullScreen(image)
    }
    
    //MARK: - Private -
    private func getDatailMovie() {
        let endpoint = EndPoint.movieDetails(id: movieID)
        networkService.request(endPoint: endpoint,
                               expecting: MovieDetailModel.self) { [weak self] result in
            switch result {
            case .success(let result):
                if let result = result {
                    DispatchQueue.main.async { [weak self] in
                        self?.movie = result
                        self?.view?.update(with: result)
                    }
                }
            case .failure(let error):
                self?.view?.displayError("Failed to get movie details: \(error)")
            }
        }
    }
    
    private func getMovieTrailerLink() {
        view?.showActivityIndicator()
        let endpoint = EndPoint.movieTrailer(id: movieID)
        networkService.request(endPoint: endpoint,
                               expecting: MovieTrailerModel.self) { [weak self] result in
            switch result {
            case .success(let result):
                if let result = result {
                    DispatchQueue.main.async { [weak self] in
                        self?.trailers = result.results
                    }
                }
            case .failure(let error):
                self?.view?.displayError("Failed to get movie details: \(error)")
            }
        }
    }
    
    
}
