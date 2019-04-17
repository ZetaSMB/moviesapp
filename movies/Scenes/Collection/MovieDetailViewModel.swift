//
//  MovieDetailViewModel.swift
//  movies
//
//  Created by Santiago B on 10/04/2019.
//  Copyright © 2019 zeta. All rights reserved.
//

import Foundation

struct MovieCollectionItemViewModel {
    
    private var movie: Movie
    
    private static let numberFormatter: NumberFormatter = {
        $0.minimumFractionDigits = 1
        return $0
    }(NumberFormatter())
    
    private static let dateFormatter: DateFormatter = {
        $0.dateStyle = .medium
        $0.timeStyle = .none
        return $0
    }(DateFormatter())
    
    
    init(movie: Movie) {
        self.movie = movie
    }
    
    var title: String {
        return movie.title
    }
    
    var overview: String {
        return movie.overview
    }
    
    var posterURL: URL {
        return movie.posterURL
    }
    
    var releaseDate: String? {
        if let releaseDate = movie.releaseDate {
            return MovieCollectionItemViewModel.dateFormatter.string(from: releaseDate)
        }
        return nil
    }
    
    var rating: String? {
        if let rate = movie.voteAverage {
            return MovieCollectionItemViewModel.numberFormatter.string(from: NSNumber(value: rate))
        }
        return nil
    }
    
}
