//
//  MovieDetailViewModel.swift
//  movies
//
//  Created by Santiago B on 16/04/2019.
//  Copyright © 2019 zeta. All rights reserved.
//

import RxSwift
import RxCocoa

public struct MovieDetailViewModelInputs {
    let movie: Movie
    let movieRepository: TMDbService
}

public protocol MovieDetailViewModelOutputs {
    var movieInfo: Driver<String> { get }
    var movieCast: Driver<[MovieCast]> { get }
    var topImageURL: URL? { get }
    var title: String? { get }
    var overview: String? { get }
    var numberOfCastPersons: Int { get }
    var numberOfCrewPersons: Int { get }
    func castMemberViewModelForIndex(_ index: Int) -> CastMemberItemViewModel?
}

public protocol MovieDetailViewModelType {
    init(_ inputs: MovieDetailViewModelInputs)
    var outputs: MovieDetailViewModelOutputs { get }
    func fetchMovieDetail()
}

public final class MovieDetailViewModel: MovieDetailViewModelType, MovieDetailViewModelOutputs {
    private let inputs: MovieDetailViewModelInputs
    private let disposeBag = DisposeBag()
    private let _movieCast = BehaviorRelay<[MovieCast]>(value: [])
    private let _movieInfo = BehaviorRelay<String>(value: "")
    
    private static let dateFormatter: DateFormatter = {
        $0.dateFormat = "yyyy"
        return $0
    }(DateFormatter())
    
    public init(_ inputs: MovieDetailViewModelInputs) {
        self.inputs = inputs
    }

    public var outputs: MovieDetailViewModelOutputs {
        return self
    }
    
    public var movieInfo: Driver<String> {
        return _movieInfo.asDriver()
    }
    
    public var movieCast: Driver<[MovieCast]> {
        return _movieCast.asDriver()
    }
    
    public var topImageURL: URL? {
        if let path = inputs.movie.posterPath {
            return URL(string: "https://image.tmdb.org/t/p/w500\(path)")
        }
        return nil
    }
    
    public var title: String? {
        return inputs.movie.title
    }
    
    public var overview: String? {
        return inputs.movie.overview
    }

    public var numberOfCastPersons: Int {
        return _movieCast.value.count
    }
    
    public var numberOfCrewPersons: Int {
        return _movieCast.value.count
    }
    
    public func castMemberViewModelForIndex(_ index: Int) -> CastMemberItemViewModel? {
        guard index < _movieCast.value.count else {
            return nil
        }
        return CastMemberItemViewModel(withMember: _movieCast.value[index])
    }
    
    public func fetchMovieDetail() {
        inputs.movieRepository.fetchMovie(id: inputs.movie.id, successHandler: { [weak self](detail) in
            self?._movieInfo.accept(self?.movieInfoString(movieDetail: detail) ?? "")
            self?._movieCast.accept(detail.credits?.cast ?? [] )
        }, errorHandler: { [weak self] (_) in
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
            details += (details.isEmpty ? "" : " • ") + "\(runtime) min"
        }

        if let voteAvg = movieDetail?.voteAverage {
            details += (details.isEmpty ? "" : " • ") + "\(voteAvg)/10 ★"
        }
        return details
    }
    
}
