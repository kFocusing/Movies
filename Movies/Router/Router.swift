//
//  Router.swift
//  Movies
//
//  Created by Danylo Klymov on 28.04.2022.
//

import UIKit

protocol RouterMain {
    var navigationController: UINavigationController? { get set }
    var assemblyBuilder: AssemblyBuilderProtocol { get set }
}

protocol RouterProtocol: RouterMain {
    func showMovieListViewController()
    func showMovieDetailViewController(movieID: Int?)
    func showPosterFullScreen(_ image: UIImage) 
    func popToRoot()
}

class Router: RouterProtocol {
    
    //MARK: - Variables -
    var assemblyBuilder: AssemblyBuilderProtocol
    var navigationController: UINavigationController?
    
    //MARK: - Life Cycle -
    init(navigationController: UINavigationController,
         assemblyBuilder: AssemblyBuilderProtocol) {
        self.navigationController = navigationController
        self.assemblyBuilder = assemblyBuilder
    }
    
    //MARK: - Internal -
    func showMovieListViewController() {
        navigationController?.viewControllers = [assemblyBuilder.createMovieListModule(router: self)]
    }
    
    func showMovieDetailViewController(movieID: Int?) {
        let MovieDetailViewController = assemblyBuilder.createMovieDetailModule(router: self,
                                                                           movieID: movieID)
        navigationController?.pushViewController(MovieDetailViewController,
                                                 animated: true)
    }
    
    func showPosterFullScreen(_ image: UIImage) {
        let posterViewController = assemblyBuilder.createMoviePosterModule(router: self,
                                                                          image: image)
        navigationController?.present(posterViewController,
                                      animated: true,
                                      completion: nil)
    }
    
    func popToRoot() {
        navigationController?.popToRootViewController(animated: true)
    }
}
