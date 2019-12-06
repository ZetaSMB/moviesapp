//
//  TMDbMovie.swift
//  movies
//
//  Created by Santiago B on 09/04/2019.
//  Copyright © 2019 zeta. All rights reserved.
//

import Foundation

public struct MoviesResponse: Codable, Equatable {
    let page: Int
    let totalResults: Int
    let totalPages: Int
    let results: [Movie]
}

public struct Movie: Codable, Equatable {
    public let id: Int
    public let title: String
    public let backdropPath: String?
    public let posterPath: String?
    public let overview: String
    public let adult: Bool
}

public struct MovieDetail: Codable, Equatable {
    public let id: Int
    public let title: String
    public let backdropPath: String?
    public let posterPath: String?
    public let overview: String
    public let releaseDate: Date
    public let voteAverage: Double
    public let voteCount: Int
    public let tagline: String?
    public let genres: [MovieGenre]?
    public let videos: MovieVideoResponse?
    public let credits: MovieCreditResponse?
    public let adult: Bool
    public let runtime: Int?
}

public struct MovieGenre: Codable, Equatable {
    let name: String
}

public struct MovieVideoResponse: Codable, Equatable {
    public let results: [MovieVideo]
}

public struct MovieVideo: Codable, Equatable {
    public let id: String
    public let key: String
    public let name: String
    public let site: String
    public let size: Int
    public let type: String
    
    public var youtubeURL: URL? {
        guard site == "YouTube" else {
            return nil
        }
        return URL(string: "https://www.youtube.com/watch?v=\(key)")
    }
}

public struct MovieCreditResponse: Codable, Equatable {
    public let cast: [MovieCast]
    public let crew: [MovieCrew]
}

public struct MovieCast: Codable, Equatable {
    public let profilePath: String?
    public let character: String
    public let name: String
}

public struct MovieCrew: Codable, Equatable {
    public let department: String
    public let job: String
    public let name: String
    public let profilePath: String?
}
