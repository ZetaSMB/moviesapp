//
//  MockedTMDbRepository.swift
//  moviesTests
//
//  Created by Santiago on 12/6/19.
//  Copyright © 2019 zeta. All rights reserved.
//

import Foundation
@testable import movies

class MockedTMDbRepository : TMDbService {
    
    private let jsonDecoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-mm-dd"
        jsonDecoder.dateDecodingStrategy = .formatted(dateFormatter)
        return jsonDecoder
    }()

    private(set) var allFetchedMovies:[Movie] = []
    
    func fetchMovieCollection(by collectionType: TMDbMovieCollection, successHandler: @escaping (MoviesResponse) -> Void, errorHandler: @escaping (Error) -> Void) {
        var expectedValue: MoviesResponse = MoviesResponse(page: 0, totalResults: 0, totalPages: 0, results: [])
        let fileName: String
        switch collectionType {
        case .upcoming:
            fileName = "StubMovieCollectionResponse_Upcoming"
        case .popular:
            fileName = "StubMovieCollectionResponse_Popular"
        case .topRated:
            fileName = "StubMovieCollectionResponse_TopRated"
        }
        if let path = Bundle(for: MovieCollectionViewModelTest.self).path(forResource: fileName, ofType: "json") {
            let data = try! Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            expectedValue = try! jsonDecoder.decode(MoviesResponse.self, from: data)
        }
        allFetchedMovies = expectedValue.results
        successHandler(expectedValue)
    }
    
    func fetchMovie(id: Int, successHandler: @escaping (MovieDetail) -> Void, errorHandler: @escaping (Error) -> Void) {
        //TODO:
    }
    
    func searchMovie(query: String, successHandler: @escaping (MoviesResponse) -> Void, errorHandler: @escaping (Error) -> Void) {
        //TODO:
    }
    
}
