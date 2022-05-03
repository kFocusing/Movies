//
//  AssemblyModelBuilder.swift
//  Movies
//
//  Created by Danylo Klymov on 28.04.2022.
//

import UIKit

protocol AssemblyBuilderProtocol {
    func createMovieListModule(router: RouterProtocol) -> UIViewController
}

class AssemblyModelBuilder: AssemblyBuilderProtocol {

    //MARK: - Internal -
    func createMovieListModule(router: RouterProtocol) -> UIViewController {
        let view = MovieListViewController()
        let presenter = MovieListPresenter(view: view,
                                          router: router)
        view.presenter = presenter
        return view
    }
    
    //TODO: createMovieDetailModule
}
