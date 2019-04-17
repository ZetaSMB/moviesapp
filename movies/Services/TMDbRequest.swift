//
//  TMDbRouter.swift
//  movies
//
//  Created by Santiago B on 09/04/2019.
//  Copyright © 2019 zeta. All rights reserved.
//

import Alamofire

public enum TMDbRequest : URLRequestConvertible {
    
    enum Constants {
        static let baseURLPath = "https://api.themoviedb.org/3"
        static let apiKey = "8fdaa2b630f347c3eddf9a336c9ad4cf"
    }
    
    case collection(TMDbMovieCollection)
    case fetchMovieByID(Int)
    case searchByText(String)
    
    var method: HTTPMethod {
        switch self {
        default:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .collection(let type):
            switch type {
            case .upcoming:
                return "/movie/upcoming"
            case .popular:
                return "/movie/popular"
            case .topRated:
                return "/movie/top_rated"
            }
        case .fetchMovieByID(let id):
            return "/movie/\(id)"
        case .searchByText:
            return "/search/movie"
        }
        
    }
    
    var parameters: [String: Any] {
        var params = ["api_key":Constants.apiKey]
        switch self {
        case .collection(_):
            break
        case .fetchMovieByID(_):
            params["append_to_response"] = "videos,credits"
        case .searchByText(let q):
            params["append_to_response"] = "videos,credits"
            params["language"] = "en-US"
            params["include_adult"] = "false"
            params["region"] = "US"
            params["query"] = q
        }
        return params
    }
    
    public func asURLRequest() throws -> URLRequest {
        let url = try Constants.baseURLPath.asURL()
        
        var request = URLRequest(url: url.appendingPathComponent(path))
        request.httpMethod = method.rawValue
        request.timeoutInterval = TimeInterval(10 * 1000)
        
        return try URLEncoding.default.encode(request, with: parameters)
    }
}
