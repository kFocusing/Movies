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
        backgroundColor = .darkNavy
        addDropShadow(shadowOpacity: 0.3, shadowRadius: 3, shadowOffset: CGSize(width: 0, height: 3))
        configureTextFields(movie)
        configurePosterImage(movie)
    }
    
    //MARK: - Private -
    private func configureTextFields(_ movie: PreviewMovieModel) {
        titleLabel.text = movie.title + " (\(movie.releaseDate.prefix(4)))"
        

        
        
        ratingLabel.text = String(movie.voteAverage)
        genresLabel.text = GenerService.shared.getGenres(by: movie.genreIDS)
                                        .map{ $0.name.capitalized }
                                        .joined(separator: ", ")
        
    }
    
    private func configurePosterImage(_ movie: PreviewMovieModel) {
        posterImage.kf.setImage(with: URL(string: "https://image.tmdb.org/t/p/w500\(movie.backdropPath)"))
        posterImage.makeRoundCorner(15)
    }
}
