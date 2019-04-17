//
//  MovieDetailViewModel.swift
//  movies
//
//  Created by Santiago B on 16/04/2019.
//  Copyright © 2019 zeta. All rights reserved.
//

import RxSwift
import RxCocoa

class MovieDetailViewModel: NSObject {

    private let movieRepository: TMDbService
    private let disposeBag = DisposeBag()
    
    private static let dateFormatter: DateFormatter = {
        $0.dateFormat = "yyyy"
        return $0
    }(DateFormatter())
    
    private let movie: Movie
    private let _movieCast = BehaviorRelay<[MovieCast]>(value: [])
    private let _movieInfo = BehaviorRelay<String>(value: "")
    
    var movieInfo: Driver<String> {
        return _movieInfo.asDriver()
    }
    
    var movieCast: Driver<[MovieCast]> {
        return _movieCast.asDriver()
    }
    
    init(withMovie movie: Movie, movieRepository: TMDbService) {
        self.movie = movie
        self.movieRepository = movieRepository
    }
    
    var topImageURL: URL? {
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

    var numberOfCastPersons : Int {
        return _movieCast.value.count
    }
    
    var numberOfCrewPersons : Int {
        return _movieCast.value.count
    }
    
    public func castMemberViewModelForIndex(_ index: Int) -> CastMemberItemViewModel? {
        guard index < _movieCast.value.count else {
            return nil
        }
        return CastMemberItemViewModel(withMember:_movieCast.value[index])
    }
    
    public func fetchMovieDetail() {
        movieRepository.fetchMovie(id: movie.id, successHandler: { [weak self](detail) in
            self?._movieInfo.accept(self?.movieInfoString(movieDetail: detail) ?? "")
            self?._movieCast.accept(detail.credits?.cast ?? [] )
        }, errorHandler: { [weak self] (error) in
            self?._movieInfo.accept("")
            self?._movieCast.accept([])
        })
    }
    
    private func movieInfoString(movieDetail: MovieDetail?) -> String {
        var details = "" //2019 • 129 min • 5.9/10 ★
        if let releaseDate = movieDetail?.releaseDate {
            details += MovieDetailViewModel.dateFormatter.string(from: releaseDate)
        }
        if let runtime = movieDetail?.runtime {
            details +=  (details.isEmpty ? "" : " • ") + "\(runtime) min"
        }

        if let voteAvg = movieDetail?.voteAverage {
            details +=  (details.isEmpty ? "" : " • ") + "\(voteAvg)/10 ★"
        }
        return details
    }
    
}
