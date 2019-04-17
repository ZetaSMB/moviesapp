//
//  MovieDetailViewModel.swift
//  movies
//
//  Created by Santiago B on 10/04/2019.
//  Copyright © 2019 zeta. All rights reserved.
//

import RxSwift

struct MovieCollectionItemViewModel {
    
    private let disposeBag = DisposeBag()
    private let movie: Movie
    
    private static let dateFormatter: DateFormatter = {
        $0.dateFormat = "yyyy"
        return $0
    }(DateFormatter())
    
    
    init(withMovie movie: Movie) {
        self.movie = movie
    }
    
    var posterURL: URL? {
        if let path = movie.posterPath {
            return URL(string: "https://image.tmdb.org/t/p/w500\(path)")
        }
        return nil
    }
    
    var title : String? {
        return movie.title
    }
    
    var overview : String? {
        return movie.overview
    }    
}
