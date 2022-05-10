//
//  PosterFullScreenPresenter.swift
//  Movies
//
//  Created by Danylo Klymov on 09.05.2022.
//

import UIKit

protocol PosterFullScreenViewProtocol: AnyObject {
    func showPoster(image: UIImage)
}

protocol PosterFullScreenPresenterProtocol: AnyObject {
    init(view: PosterFullScreenViewProtocol,
         router: RouterProtocol,
         image: UIImage)
    func viewDidLoad()
}

class PosterFullScreenPresenter: PosterFullScreenPresenterProtocol {
    
    //MARK: - Properties -
    private weak var view: PosterFullScreenViewProtocol?
    private var router: RouterProtocol?
    private var image: UIImage
    
    //MARK: - Life Cycle -
    required init(view: PosterFullScreenViewProtocol,
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
