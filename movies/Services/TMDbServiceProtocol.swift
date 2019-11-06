//
//  TMDbService.swift
//  movies
//
//  Created by Santiago B on 09/04/2019.
//  Copyright © 2019 zeta. All rights reserved.
//

import UIKit

protocol TMDbService {
    
    func fetchMovieCollection(by collectionType: TMDbMovieCollection, successHandler: @escaping (_ response: MoviesResponse) -> Void, errorHandler: @escaping(_ error: Error) -> Void)
    
    func fetchMovie(id: Int, successHandler: @escaping (_ response: MovieDetail) -> Void, errorHandler: @escaping(_ error: Error) -> Void)
    
    func searchMovie(query: String, successHandler: @escaping (_ response: MoviesResponse) -> Void, errorHandler: @escaping(_ error: Error) -> Void)
}

public enum TMDbMovieCollection: String, CustomStringConvertible, CaseIterable {    
    case upcoming
    case popular
    case topRated = "top_rated"
    
    public init?(index: Int) {
        switch index {
        case 0:
            self = .upcoming
        case 1:
            self = .popular
        case 2:
            self = .topRated
        default:
            return nil
        }
    }
    
    public var description: String {
        switch self {
        case .upcoming:
            return "Upcoming"
        case .popular:
            return "Popular"
        case .topRated:
            return "Top Rated"
        }
    }
}

public enum TMDbError: Error {
    case requestError(Error)
    case invalidResponse
    case serializationError
    case noData
}
