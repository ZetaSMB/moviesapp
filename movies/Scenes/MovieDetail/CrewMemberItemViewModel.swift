//
//  CrewMemberItemViewModel.swift
//  movies
//
//  Created by Santiago B on 16/04/2019.
//  Copyright © 2019 zeta. All rights reserved.
//

import UIKit

class CastMemberItemViewModel: NSObject {
    
    private let movie: Cast
    
    init(withMovie movie: Movie) {
        self.movie = movie
    }
    
    var posterURL: URL? {
        if let path = movie.posterPath {
            return URL(string: "https://image.tmdb.org/t/p/w500\(path)")
        }
        return nil
    }
    var initials: String {
        return components(separatedBy: " ").reduce("") { (string, nextWord) -> String in
            guard nextWord.count > 0 else { return string }
            return string + nextWord.prefix(1).uppercased()
        }
    }
}
