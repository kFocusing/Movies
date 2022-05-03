//
//  GenerService.swift
//  Movies
//
//  Created by Danylo Klymov on 02.05.2022.
//

import Foundation

struct GenerService {
    
    //MARK: - Static Constants -
    static var shared = GenerService()
    
    //MARK: - Private Variable -
    private var genreList: [GenreModel]!
    
    //MARK: - Life Cycle -
    private init() {}
    
    //MARK: - Internal -
    mutating func setGenreList(_ genreList: [GenreModel]) {
        self.genreList = genreList
    }
    
    func getGenreList() -> [GenreModel] {
        return genreList
    }
    
    func getGenres(by id: [Int]) -> [GenreModel] {
        var genreListFromID: [GenreModel] = []
        for id in id {
            genreListFromID += genreList.filter { $0.id == id }
        }
        return genreListFromID
    }
}
