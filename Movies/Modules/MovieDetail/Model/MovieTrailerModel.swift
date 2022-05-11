//
//  MovieTrailerModel.swift
//  Movies
//
//  Created by Danylo Klymov on 09.05.2022.
//

import Foundation

// MARK: - MovieTrailerModel -
struct MovieTrailerModel: Codable {
    let results: [TrailerIDModel]
}

// MARK: - TrailerIdModel -
struct TrailerIDModel: Codable {
    let key: String
}
