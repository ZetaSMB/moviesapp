//
//  MovieCollectionViewModel.swift
//  movies
//
//  Created by Santiago B on 10/04/2019.
//  Copyright © 2019 zeta. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MovieCollectionViewModel {
    
    private let movieRepository: TMDbService
    private let disposeBag = DisposeBag()
    
    fileprivate enum UIMessages {
        static let error: String = "Oops, there was an error fetching data :(\nPlease, check your connection and try again."
    }
    
    init(collectionType: Driver<TMDbMovieCollection>, movieRepository: TMDbService) {
        self.movieRepository = movieRepository
        collectionType
            .drive(onNext: { [weak self] (type) in
                self?.fetchMovies(by: type)
            }).disposed(by: disposeBag)
    }
    
    private let _movies = BehaviorRelay<[Movie]>(value: [])
    private let _isFetching = BehaviorRelay<Bool>(value: false)
    private let _error = BehaviorRelay<String?>(value: nil)
    
    var isFetching: Driver<Bool> {
        return _isFetching.asDriver()
    }
    
    var movies: Driver<[Movie]> {
        return _movies.asDriver()
    }
    
    var error: Driver<String?> {
        return _error.asDriver()
    }
    
    var hasError: Bool {
        return _error.value != nil
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
    
    private func fetchMovies(by collectionType: TMDbMovieCollection) {
        self._movies.accept([])
        self._isFetching.accept(true)
        self._error.accept(nil)
        
        movieRepository.fetchMovieCollection(by: collectionType, successHandler: {[weak self] (response) in
            self?._isFetching.accept(false)
            self?._movies.accept(response.results)
        }) { [weak self] (error) in
            self?._isFetching.accept(false)            
            self?._error.accept(UIMessages.error)
        }
    }
    
}
