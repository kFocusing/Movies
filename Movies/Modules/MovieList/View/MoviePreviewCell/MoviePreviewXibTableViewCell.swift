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
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var ratingLabel: UILabel!
    @IBOutlet private weak var genresLabel: UILabel!
    @IBOutlet private weak var posterImage: UIImageView!
    @IBOutlet weak var likeImage: UIImageView!
    
    //MARK: - Private Variables -
    private var cornerRadius: CGFloat = 15
    
    //MARK: - Internal -
    func configure(movie: PreviewMovieModel) {
        backgroundColor = .clear
        configureLabels(movie)
        configurePosterImage(movie)
        addLikeImageShadow()
    }
    
    //MARK: - Private -
    private func configureLabels(_ movie: PreviewMovieModel) {
        titleLabel.text = movie.title + " (\(movie.releaseDate.prefix(4)))"
        titleLabel.dropShadow()
        ratingLabel.text = String(movie.voteCount)
        ratingLabel.dropShadow()
        genresLabel.text = GenerService.shared.getGenres(by: movie.genreIDS)
                                        .map{ $0.name.capitalized }
                                        .joined(separator: ", ")
        genresLabel.dropShadow()
    }
    
    private func configurePosterImage(_ movie: PreviewMovieModel) {
        let path = movie.backdropPath != nil ?
                    "https://image.tmdb.org/t/p/w500\(movie.backdropPath ?? "")"
                    : "https://i.ytimg.com/vi/-maA-yHtBKU/maxresdefault.jpg"
        posterImage.kf.setImage(with: URL(string: path))
        posterImage.makeRoundCorner(Int(cornerRadius))
        addDropShadow(offset: CGSize.init(width: 0,
                                      height: 1),
                  color: UIColor.black,
                  radius: 2,
                  opacity: 0.7)
    }
    
    private func addLikeImageShadow() {
        likeImage.addDropShadow(offset: CGSize.zero,
                                color: UIColor.black,
                                radius: 2,
                                opacity: 1)
    }
}
