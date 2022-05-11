//
//  AssemblyModelBuilder.swift
//  Movies
//
//  Created by Danylo Klymov on 28.04.2022.
//

import UIKit

protocol AssemblyBuilderProtocol {
    func createMovieListModule(router: RouterProtocol) -> UIViewController
    func createMovieDetailModule(router: RouterProtocol,
                                 movieID: Int?) -> UIViewController
    func createMoviePosterModule(router: RouterProtocol,
                                 image: UIImage) -> UIViewController
}

class AssemblyModelBuilder: AssemblyBuilderProtocol {
    
    //MARK: - Internal -
    func createMovieListModule(router: RouterProtocol) -> UIViewController {
        let view = MovieListViewController()
        let networkService = NetworkService()
        let presenter = MovieListPresenter(view: view,
                                           networkService: networkService,
                                           router: router)
        view.presenter = presenter
        return view
    }
    
    func createMovieDetailModule(router: RouterProtocol,
                                 movieID: Int?) -> UIViewController {
        let view = MovieDetailViewController()
        let networkService = NetworkService()
        let presenter = MovieDetailPresenter(view: view,
                                             networkService: networkService,
                                             router: router,
                                             movieID: movieID)
        view.presenter = presenter
        return view
    }
    
    func createMoviePosterModule(router: RouterProtocol,
                                 image: UIImage) -> UIViewController {
        let view = MoviePosterViewController()
        let presenter = MoviePosterPresenter(view: view,
                                             router: router,
                                             image: image)
        view.presenter = presenter
        return view
    }
}
