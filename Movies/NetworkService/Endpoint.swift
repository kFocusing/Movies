//
//  Endpoint.swift
//  Movies
//
//  Created by Danylo Klymov on 28.04.2022.
//

import Alamofire

//MARK: - EndPointConstants -
private struct EndPointConstants {
    static let baseURL = "https://api.themoviedb.org/3/"
    static let kApiKey = "api_key="
    static let apiKey = "12b7dc94d4938aca806f6f0ef89a3bd0"
    static let kLanguage = "language="
    static let language = "en"
}

//MARK: - EndPoint -
enum EndPoint {
    case list(sort: String, page: Int)
    case genres
    case searchMovies(query: String, page: Int)
    case movieDetails(id: Int)
    case movieTrailer(id: Int)
    
    var path: String {
        switch self {
        case .list:
            return "discover/movie"
        case .genres:
            return "genre/movie/list"
        case .searchMovies:
            return "search/movie"
        case .movieDetails(let id):
            return "movie/\(id)"
        case .movieTrailer(let id):
            return "movie/\(id)/videos"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        default: return .get
        }
    
    }
    
    var encoding: ParameterEncoding {
        switch self {
        default: return URLEncoding.default
        }
    }
    
    var parameters: [String: Any] {
        switch self {
        case .list(sort: let sort, page: let page):
            return ["page": page, "sort_by": sort]
        case .searchMovies(query: let query, page: let page):
            return ["query": query, "page": page]
        default:
            return [:]
        }
    }
    
    func fullURLString() -> String {
        return String(format: "%@%@?%@%@&%@%@",
                      EndPointConstants.baseURL,
                      self.path,
                      EndPointConstants.kApiKey,
                      EndPointConstants.apiKey,
                      EndPointConstants.kLanguage,
                      EndPointConstants.language)
    }
}
