//
//  MoviePosterPresenter.swift
//  Movies
//
//  Created by Danylo Klymov on 09.05.2022.
//

import UIKit

protocol MoviePosterViewProtocol: AnyObject {
    func showPoster(image: UIImage)
}

protocol MoviePosterPresenterProtocol: AnyObject {
    init(view: MoviePosterViewProtocol,
         router: RouterProtocol,
         image: UIImage)
    func viewDidLoad()
}

class MoviePosterPresenter: MoviePosterPresenterProtocol {
    
    //MARK: - Properties -
    private weak var view: MoviePosterViewProtocol?
    private var router: RouterProtocol?
    private var image: UIImage
    
    //MARK: - Life Cycle -
    required init(view: MoviePosterViewProtocol,
                  router: RouterProtocol,
                  image: UIImage) {
        self.view = view
        self.router = router
        self.image = image
    }
    
    //MARK: - Internal -
    func viewDidLoad() {
        view?.showPoster(image: image)
    }
}
