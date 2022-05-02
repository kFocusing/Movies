//
//  MoviePreviewXibTableViewCell.swift
//  Movies
//
//  Created by Danylo Klymov on 28.04.2022.
//

import UIKit
import Kingfisher

class MoviePreviewXibTableViewCell: BaseTableViewCell {
    
    //MARK: - UIElements -
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var genresLabel: UILabel!
    @IBOutlet weak var posterImage: UIImageView!
    
    //MARK: - Internal -
    func configure(movie: PreviewMovieModel) {
        backgroundColor = .white
        configureLabels(movie)
        configurePosterImage(movie)
    }
    
    //MARK: - Private -
    private func configureLabels(_ movie: PreviewMovieModel) {
        titleLabel.text = movie.title + " (\(movie.releaseDate.prefix(4)))"
        titleLabel.dropShadow()
        ratingLabel.text = String(movie.voteAverage)
        ratingLabel.dropShadow()
        genresLabel.text = GenerService.shared.getGenres(by: movie.genreIDS)
                                        .map{ $0.name.capitalized }
                                        .joined(separator: ", ")
        genresLabel.dropShadow()
    }
    
    private func configurePosterImage(_ movie: PreviewMovieModel) {
        posterImage.kf.setImage(with: URL(string: "https://image.tmdb.org/t/p/w500\(movie.backdropPath)"))
        posterImage.makeRoundCorner(15)
        addDropShadow(shadowOpacity: 1, shadowRadius: 1, shadowOffset: CGSize(width: 1, height: 1))
    }
}
