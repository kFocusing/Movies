//
//  MovieDetailViewController.swift
//  Movies
//
//  Created by Danylo Klymov on 28.04.2022.
//

import UIKit
import youtube_ios_player_helper

class MovieDetailViewController: BaseViewController {
    
    //MARK: - UIElements -
    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.showsHorizontalScrollIndicator = true
        scroll.showsVerticalScrollIndicator = true
        view.addSubview(scroll)
        return scroll
    }()
    
    private lazy var posterImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.backgroundColor = .white
        image.isUserInteractionEnabled = true
        image.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                          action: #selector (showPosterFullScreen)))
        scrollView.addSubview(image)
        return image
    }()
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = ""
        titleLabel.textColor = .black
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = .boldSystemFont(ofSize: 20)
        titleLabel.numberOfLines = 0
        scrollView.addSubview(titleLabel)
        return titleLabel
    }()
    
    private lazy var propertiesLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        scrollView.addSubview(label)
        return label
    }()
    
    private lazy var genresLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        scrollView.addSubview(label)
        return label
    }()
    
    private lazy var ratingLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 18)
        label.numberOfLines = 1
        scrollView.addSubview(label)
        return label
    }()
    
    private lazy var trailerButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "film"), for: .normal)
        button.backgroundColor = .black
        button.tintColor = .white
        button.isHidden = true
        button.makeRoundCorner(Int(buttonSize.width / 2))
        button.addTarget(self, action: #selector(trailerButtonPressed),
                                  for: .touchUpInside)
        scrollView.addSubview(button)
        return button
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20)
        label.numberOfLines = 0
        scrollView.addSubview(label)
        return label
    }()
    
    private lazy var trailerUnavailableLabel: UILabel = {
        let label = UILabel()
        label.text = "Trailer Unavailable"
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 18)
        label.numberOfLines = 1
        scrollView.addSubview(label)
        label.isHidden = true
        return label
    }()
    
    private lazy var playerView: YTPlayerView = {
        let player = YTPlayerView()
        player.translatesAutoresizingMaskIntoConstraints = false
        player.delegate = self
        player.isHidden = true
        player.autoresizingMask = .flexibleWidth
        scrollView.addSubview(player)
        return player
    }()
    
    //MARK: - Properties -
    var presenter: MovieDetailPresenterProtocol!
    private let horizontalInset: CGFloat = 15
    private let verticalInset: CGFloat = 15
    private let buttonSize = CGSize(width: 35, height: 35)
    private let posterHeight: CGFloat = 285
    
    //MARK: - Life Cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutUIElements()
        view.backgroundColor = .white
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        presenter.viewDidLoad()
        layoutActivityIndicator(to: posterImage)
    }

    //MARK: - Private -
    @objc private func trailerButtonPressed() {
        showActivityIndicator()
        playerView.load(withVideoId: presenter.getTrailerKey())
    }
    
    @objc private func backButtonTapped() {
        presenter.comePreviousScreen()
    }
    
    @objc private func hidePlayer() {
        playerView.stopVideo()
        playerView.isHidden = true
        navigationItem.rightBarButtonItem = UIBarButtonItem()
    }
    
    @objc private func showPosterFullScreen() {
        guard let image = posterImage.image else { return }
        presenter.showPosterFullScreen(image)
    }
    
    private func layoutUIElements() {
        DispatchQueue.main.async { [weak self] in
            self?.layoutScrollView()
            self?.layoutPosterImage()
            self?.layoutTitleLabel()
            self?.layoutPropertiesLabel()
            self?.layoutGenresLabel()
            self?.layoutRatingLabel()
            self?.layoutTrailerButton()
            self?.layoutDescriptionLabel()
            self?.layoutPlayerView()
            self?.layoutTrailerUnavailableLabel()
        }
    }
    
    private func layoutScrollView() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func layoutPosterImage() {
        NSLayoutConstraint.activate([
            posterImage.topAnchor.constraint(equalTo: scrollView.topAnchor),
            posterImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            posterImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            posterImage.heightAnchor.constraint(equalToConstant: posterHeight)
        ])
    }
    
    private func layoutTitleLabel() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: posterImage.bottomAnchor,
                                            constant: verticalInset),
            titleLabel.leadingAnchor.constraint(equalTo: posterImage.leadingAnchor,
                                                constant: horizontalInset),
            titleLabel.trailingAnchor.constraint(equalTo: posterImage.trailingAnchor,
                                                 constant: -horizontalInset)
        ])
    }
    
    private func layoutPropertiesLabel() {
        NSLayoutConstraint.activate([
            propertiesLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor,
                                                 constant: verticalInset),
            propertiesLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            propertiesLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor)
        ])
    }
    
    private func layoutGenresLabel() {
        NSLayoutConstraint.activate([
            genresLabel.topAnchor.constraint(equalTo: propertiesLabel.bottomAnchor,
                                             constant: verticalInset),
            genresLabel.leadingAnchor.constraint(equalTo: propertiesLabel.leadingAnchor),
            genresLabel.trailingAnchor.constraint(equalTo: propertiesLabel.trailingAnchor)
        ])
    }
    
    private func layoutRatingLabel() {
        NSLayoutConstraint.activate([
            ratingLabel.centerYAnchor.constraint(equalTo: trailerButton.centerYAnchor),
            ratingLabel.trailingAnchor.constraint(equalTo: genresLabel.trailingAnchor)
        ])
    }
    
    private func layoutTrailerButton() {
        NSLayoutConstraint.activate([
            trailerButton.topAnchor.constraint(equalTo: genresLabel.bottomAnchor,
                                               constant: verticalInset),
            trailerButton.leadingAnchor.constraint(equalTo: genresLabel.leadingAnchor),
            trailerButton.widthAnchor.constraint(equalToConstant: buttonSize.width),
            trailerButton.heightAnchor.constraint(equalToConstant: buttonSize.height)
        ])
    }
    
    private func layoutDescriptionLabel() {
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: trailerButton.bottomAnchor,
                                                  constant: verticalInset),
            descriptionLabel.leadingAnchor.constraint(equalTo: trailerButton.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: ratingLabel.trailingAnchor),
            descriptionLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
    }
    
    private func layoutTrailerUnavailableLabel() {
        NSLayoutConstraint.activate([
            trailerUnavailableLabel.centerYAnchor.constraint(equalTo: trailerButton.centerYAnchor),
            trailerUnavailableLabel.leadingAnchor.constraint(equalTo: genresLabel.leadingAnchor)
        ])
    }
    
    private func layoutPlayerView() {
        NSLayoutConstraint.activate([
            playerView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            playerView.leadingAnchor.constraint(equalTo: posterImage.leadingAnchor),
            playerView.trailingAnchor.constraint(equalTo: posterImage.trailingAnchor),
            playerView.heightAnchor.constraint(equalToConstant: posterHeight)
        ])
    }
    
    private func setupUIElements(with movie: MovieDetailModel) {
        DispatchQueue.main.async { [weak self] in
            self?.setupNavigationBar(movie)
            self?.setupPosterImage(movie)
            self?.setupTitleLabel(movie)
            self?.setupPropertiesLabel(movie)
            self?.setupGenresTitle(movie)
            self?.setupRatingLabel(movie)
            self?.setupTrailerButton(movie)
            self?.setupDesriptionLabel(movie)
            self?.hideActivityIndicator()
        }
    }
    
    private func setupNavigationBar(_ movie: MovieDetailModel) {
        title = movie.title
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.backward"),
            style: .plain,
            target: self,
            action: #selector(backButtonTapped)
        )
    }
    
    private func setupPosterImage(_ movie: MovieDetailModel) {
        let path = movie.backdropPath != nil ?
        "https://image.tmdb.org/t/p/w500\(movie.backdropPath ?? "")"
        : "https://i.ytimg.com/vi/-maA-yHtBKU/maxresdefault.jpg"
        posterImage.kf.setImage(with: URL(string: path))
    }
    
    private func setupTitleLabel(_ movie: MovieDetailModel) {
        titleLabel.text = movie.title
    }
    
    private func setupPropertiesLabel(_ movie: MovieDetailModel) {
        var text = movie.productionCountries.map{ $0.name.capitalized }
            .joined(separator: ", ")
        text += movie.releaseDate != nil ? " (\(movie.releaseDate!.prefix(4)))" : ""
        propertiesLabel.text = text
    }
    
    private func setupGenresTitle(_ movie: MovieDetailModel) {
        genresLabel.text = movie.genres.map{ $0.name.capitalized }
        .joined(separator: ", ")
    }
    
    private func setupRatingLabel(_ movie: MovieDetailModel) {
        ratingLabel.text = "Rating: \(movie.voteAverage)"
    }
    
    private func setupTrailerButton(_ movie: MovieDetailModel) {
        trailerButton.isHidden = !presenter.trailersAvailable()
        trailerUnavailableLabel.isHidden = presenter.trailersAvailable()
    }
    
    private func setupDesriptionLabel(_ movie: MovieDetailModel) {
        descriptionLabel.text = movie.overview
    }
    
}

//MARK: - MovieDetailViewProtocol -
extension MovieDetailViewController: MovieDetailViewProtocol {
    func update(with movie: MovieDetailModel) {
        DispatchQueue.main.async { [weak self] in
            self?.setupUIElements(with: movie)
        }
    }
    
    func displayError(_ error: String) {
        showErrorAlert(with: error)
    }
}

//MARK: - YTPlayerViewDelegate -
extension MovieDetailViewController: YTPlayerViewDelegate {
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        hideActivityIndicator()
        playerView.isHidden = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Off Trailer",
            style: .plain,
            target: self,
            action: #selector(hidePlayer)
        )
    }
}

extension MovieDetailViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
