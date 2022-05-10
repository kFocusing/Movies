//
//  PosterFullScreenViewController.swift
//  Movies
//
//  Created by Danylo Klymov on 09.05.2022.
//

import UIKit

class PosterFullScreenViewController: BaseViewController {
    
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
        let image = UIImageView(frame: CGRect(x: 0,
                                              y: 0,
                                              width: view.frame.size.width,
                                              height: view.frame.size.width / 2))
        image.translatesAutoresizingMaskIntoConstraints = true
        image.center = view.center
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
    var presenter: PosterFullScreenPresenterProtocol!
//    private var minimumZoomScale = 0.1
//    private var maximumZoomScale = 5
    
    //MARK: - Life Cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
        layoutScrollView()
        setupNavigationBar()
    }
    
    //MARK: - Private -
    private func layoutScrollView() {
        scrollView.pinEdges(to: view)
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
            frameToCenter.origin.y = (viewSize.height - frameToCenter.size.height) / 2
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
extension PosterFullScreenViewController: PosterFullScreenViewProtocol {
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
extension PosterFullScreenViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.moviePoster
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        centerImage()
    }
}
