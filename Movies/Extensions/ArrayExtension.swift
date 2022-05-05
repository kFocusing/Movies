//
//  ArrayExtension.swift
//  Movies
//
//  Created by Danylo Klymov on 05.05.2022.
//

import Foundation

extension Array where Element == PreviewMovieModel {
    var isNonEmpty: Bool  {
        return !self.isEmpty
    }
}
