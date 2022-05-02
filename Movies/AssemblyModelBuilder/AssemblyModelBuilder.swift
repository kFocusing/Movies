//
//  AssemblyModelBuilder.swift
//  Movies
//
//  Created by Danylo Klymov on 28.04.2022.
//

import UIKit

protocol AssemblyBuilderProtocol {
    func createMovieListModule(router: RouterProtocol) -> UIViewController
    func createMovieDetailModule(router: RouterProtocol, postID: Int) -> UIViewController
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
    
    func createMovieDetailModule(router: RouterProtocol, postID: Int) -> UIViewController {
//        let view = MovieDetailViewController()
//        let postsService = PostsService()
//        let presenter = MovieDetailPresenter(view: view,
//                                            postsService: postsService,
//                                            router: router,
//                                            postID: postID)
//        view.presenter = presenter
//        return view
        return UIViewController()
    }
}
