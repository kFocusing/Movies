//
//  MoviePosterViewController.swift
//  Movies
//
//  Created by Danylo Klymov on 09.05.2022.
//

import UIKit

class MoviePosterViewController: BaseViewController {
    
    //MARK: - UIElements -
    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.showsHorizontalScrollIndicator = false
        scroll.showsVerticalScrollIndicator = false
        scroll.clipsToBounds = true
        scroll.delegate = self
        view.addSubview(scroll)
        return scroll
    }()
    
    private lazy var moviePoster: UIImageView = {
        let image = UIImageView()
        let screenSize: CGRect = UIScreen.main.bounds
        image.frame.size = CGSize(width: screenSize.width / 2, height: screenSize.height / 3)
        image.translatesAutoresizingMaskIntoConstraints = true
        image.contentMode = .scaleAspectFill
        image.isUserInteractionEnabled = true
        scrollView.addSubview(image)
        return image
    }()
    
    private lazy var zoomingTap: UITapGestureRecognizer = {
        let zoomingTap = UITapGestureRecognizer(target: self,
                                                action: #selector(handleZoomingTap))
        zoomingTap.numberOfTapsRequired = 2
        return zoomingTap
    }()
    
    //MARK: - Properties -
    var presenter: MoviePosterPresenterProtocol!
    
    //MARK: - Life Cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
        layoutScrollView()
        setupNavigationBar()
    }
    
    override func viewDidLayoutSubviews() {
        centerImage()
    }
    
    //MARK: - Private -
    private func layoutScrollView() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupNavigationBar() {
        view.backgroundColor = .black
        navigationController?.navigationBar.backgroundColor = .clear
    }
    
    @objc private func handleZoomingTap(sender: UITapGestureRecognizer) {
        let location = sender.location(in: sender.view)
        zoom(point: location, animated: true)
    }
    
    private func centerImage() {
        let viewSize = view.bounds.size
        var frameToCenter = moviePoster.frame
        
        if frameToCenter.size.width < viewSize.width {
            frameToCenter.origin.x = (viewSize.width - frameToCenter.size.width) / 2
        } else {
            frameToCenter.origin.x = 0
        }
        
        if frameToCenter.size.height < viewSize.height {
            frameToCenter.origin.y = ((viewSize.height - frameToCenter.size.height) / 2 ) - topbarHeight
        } else {
            frameToCenter.origin.y = 0
        }
        
        moviePoster.frame = frameToCenter
    }
    
    private func zoom(point: CGPoint, animated: Bool) {
        let currentScale = scrollView.zoomScale
        let minScale = scrollView.minimumZoomScale
        let maxScale = scrollView.maximumZoomScale
        
        if (minScale == maxScale && minScale > 1) {
            return
        }
        
        let toScale = maxScale
        let finalScale = (currentScale == minScale) ? toScale : minScale
        let zoomRect = zoomRect(scale: finalScale, center: point)
        scrollView.zoom(to: zoomRect, animated: true)
    }
    
    private func zoomRect(scale: CGFloat, center: CGPoint) -> CGRect {
        var zoomRect = CGRect.zero
        let bounds = scrollView.bounds
        
        zoomRect.size.width = bounds.size.width / scale
        zoomRect.size.height = bounds.size.height / scale
        
        zoomRect.origin.x = center.x - (zoomRect.size.width / 2)
        zoomRect.origin.y = center.y - (zoomRect.size.height / 2)
        return zoomRect
    }
}

//MARK: - PosterFullScreenViewProtocol -
extension MoviePosterViewController: MoviePosterViewProtocol {
    func showPoster(image: UIImage) {
        moviePoster.image = image
        configurateFor(imageSize: image.size)
    }
    
    private func configurateFor(imageSize: CGSize) {
        scrollView.contentSize = imageSize
        scrollView.maximumZoomScale = 3
        moviePoster.addGestureRecognizer(zoomingTap)
    }
}

//MARK: - UIScrollViewDelegate -
extension MoviePosterViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.moviePoster
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        centerImage()
    }
}
