//
//  MovieSearchViewModel.swift
//  movies
//
//  Created by Santiago B on 16/04/2019.
//  Copyright © 2019 zeta. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class MovieSearchViewModel {
    
    private let movieRepository: TMDbService
    private let disposeBag = DisposeBag()
    
    fileprivate enum UIMessages {
        static let searchMessage: String = "Search your favorite movies in THE MOVIE DB"
        static let notFound: String = "No results found for "
        static let error: String = "Oops, there was an error fetching data :(\nPlease, check your connection and try again."
    }
    
    init(query: Driver<String>, repository: TMDbService) {
        self.movieRepository = repository
        query
            .throttle(1.0)
            .distinctUntilChanged()
            .drive(onNext: { [weak self] (queryString) in
                self?.searchMovie(query: queryString)
                if queryString.isEmpty {
                    self?._movies.accept([])
                    self?._info.accept(UIMessages.searchMessage)
                }
            }).disposed(by: disposeBag)
    }
    
    private let _movies = BehaviorRelay<[Movie]>(value: [])
    private let _isFetching = BehaviorRelay<Bool>(value: false)
    private let _info = BehaviorRelay<String?>(value: nil)
    
    var isFetching: Driver<Bool> {
        return _isFetching.asDriver()
    }
    
    var movies: Driver<[Movie]> {
        return _movies.asDriver()
    }
    
    var info: Driver<String?> {
        return _info.asDriver()
    }
    
    var hasInfo: Bool {
        return _info.value != nil
    }
    
    var numberOfMovies: Int {
        return _movies.value.count
    }
    
    func viewModelItemForMovie(at index: Int) -> MovieCollectionItemViewModel? {
        guard index < _movies.value.count else {
            return nil
        }
        return MovieCollectionItemViewModel(withMovie: _movies.value[index])
    }
    
    func viewModelDetailForMovie(at index: Int) -> MovieDetailViewModel? {
        guard index < _movies.value.count else {
            return nil
        }
        return MovieDetailViewModel(withMovie: _movies.value[index], movieRepository: movieRepository)
    }
    
    private func searchMovie(query: String?) {
        guard let query = query, !query.isEmpty else {
            self._info.accept(UIMessages.searchMessage)
            return
        }
        
        self._isFetching.accept(true)
        self._movies.accept([])
        self._info.accept(nil)
        
        movieRepository.searchMovie(query: query, successHandler: {[weak self] (response) in            
            self?._isFetching.accept(false)
            if response.totalResults == 0 {
                self?._info.accept(UIMessages.notFound + "'\(query)'")
            }
            self?._movies.accept(Array(response.results.prefix(5)))
        }) { [weak self] (error) in
            self?._isFetching.accept(false)
            self?._info.accept(UIMessages.error)
        }
    }
}
