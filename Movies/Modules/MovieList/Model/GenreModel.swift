//
//  GenreModel.swift
//  Movies
//
//  Created by Danylo Klymov on 02.05.2022.
//

import Foundation

// MARK: - GenreListModel -
struct GenreListModel: Codable {
    let genres: [GenreModel]
}

// MARK: - GenreModel -
struct GenreModel: Codable {
    let id: Int
    let name: String
}
