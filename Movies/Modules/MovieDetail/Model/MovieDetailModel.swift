//
//  MovieDetailModel.swift
//  Movies
//
//  Created by Danylo Klymov on 09.05.2022.
//

import Foundation

// MARK: - MovieDetailsData -
struct MovieDetailModel: Codable {
    let budget, revenue, id: Int
    let genres: [GenreModel]
    let productionCountries: [CountryNameModel]
    let releaseDate, backdropPath: String?
    let originalTitle, overview, title: String
    let voteAverage: Double
    let video: Bool

    enum CodingKeys: String, CodingKey {
        case budget, genres, id, overview, title, revenue, video
        case originalTitle = "original_title"
        case backdropPath = "backdrop_path"
        case productionCountries = "production_countries"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
    }
}

// MARK: - CountryNameModel -
struct CountryNameModel: Codable {
    var name: String
}
