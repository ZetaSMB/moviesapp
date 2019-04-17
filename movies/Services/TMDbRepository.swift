//
//  TMDbStore.swift
//  movies
//
//  Created by Santiago B on 09/04/2019.
//  Copyright © 2019 zeta. All rights reserved.
//

import Alamofire

class TMDbRepository: TMDbService {

    public static let shared = TMDbRepository()
    
    private let jsonDecoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-mm-dd"
        jsonDecoder.dateDecodingStrategy = .formatted(dateFormatter)
        return jsonDecoder
    }()
    
    
    fileprivate func fetchCodableEntity<T: Codable>(from request: TMDbRequest, successHandler: @escaping (T) -> Void, errorHandler: @escaping (Error) -> Void) {
        
        Alamofire.request(request)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
//            .responseString(completionHandler: { (rsp) in
//                print(rsp)
//            })
            .responseData { response in
                switch response.result {
                case .success(let data):
                    do {
                        let rsp = try self.jsonDecoder.decode(T.self, from: data)
                        DispatchQueue.main.async {
                            successHandler(rsp)
                        }
                    } catch {
                        print(error)
                        DispatchQueue.main.async {
                            errorHandler(TMDbError.serializationError)
                        }
                    }
                    
                case .failure(let error):
                    DispatchQueue.main.async {
                        errorHandler(TMDbError.requestError(error))
                    }
                }
        }
    }
    
    func fetchMovieCollection(by collectionType: TMDbMovieCollection, successHandler: @escaping (MoviesResponse) -> Void, errorHandler: @escaping (Error) -> Void) {
        fetchCodableEntity(from: TMDbRequest.collection(collectionType), successHandler: successHandler, errorHandler: errorHandler)
    }
    
    func fetchMovie(id: Int, successHandler: @escaping (MovieDetail) -> Void, errorHandler: @escaping (Error) -> Void) {
        fetchCodableEntity(from: TMDbRequest.fetchMovieByID(id), successHandler: successHandler, errorHandler: errorHandler)
    }
    
    func searchMovie(query: String, successHandler: @escaping (MoviesResponse) -> Void, errorHandler: @escaping (Error) -> Void) {
        fetchCodableEntity(from: TMDbRequest.searchByText(query), successHandler: successHandler, errorHandler: errorHandler)
    }
    
}
