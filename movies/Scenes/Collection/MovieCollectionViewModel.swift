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

public struct MovieCollectionViewModelInputs {
    let movieRepository: TMDbService
    let collectionTypeSelected: Driver<TMDbMovieCollection>
}

public protocol MovieCollectionViewModelOutputs {
    var movies: Driver<[Movie]> { get }
    var isFetching: Driver<Bool> { get }
    var error: Driver<String?> { get }
    var hasError: Bool { get }
    var numberOfMovies: Int { get }
    func viewModelItemForMovie(at index: Int) -> MovieCollectionItemViewModel?
    func viewModelDetailForMovie(at index: Int) -> MovieDetailViewModel?
}

public protocol MovieCollectionViewModelType {
    init(_ inputs: MovieCollectionViewModelInputs)
    var outputs: MovieCollectionViewModelOutputs { get }
}

public final class MovieCollectionViewModel: MovieCollectionViewModelType, MovieCollectionViewModelOutputs {
    private let inputs: MovieCollectionViewModelInputs
    private let disposeBag = DisposeBag()
    private let _movies = BehaviorRelay<[Movie]>(value: [])
    private let _isFetching = BehaviorRelay<Bool>(value: false)
    private let _error = BehaviorRelay<String?>(value: nil)
    
    private enum UIMessages {
        static let error: String = "Oops, there was an error fetching data :(\nPlease, check your connection and try again."
    }

    public var outputs: MovieCollectionViewModelOutputs {
        return self
    }
    
    public init(_ inputs: MovieCollectionViewModelInputs) {
        self.inputs = inputs
        inputs.collectionTypeSelected
            .drive(onNext: { [weak self] (type) in
                self?.fetchMovies(by: type)
            }).disposed(by: disposeBag)
    }
    
    public var isFetching: Driver<Bool> {
        return _isFetching.asDriver()
    }
    
    public var movies: Driver<[Movie]> {
        return _movies.asDriver()
    }
    
    public var error: Driver<String?> {
        return _error.asDriver()
    }
    
    public var hasError: Bool {
        return _error.value != nil
    }
    
    public var numberOfMovies: Int {
        return _movies.value.count
    }
    
    public func viewModelItemForMovie(at index: Int) -> MovieCollectionItemViewModel? {
        guard index < _movies.value.count else {
            return nil
        }
        return MovieCollectionItemViewModel(withMovie: _movies.value[index])
    }
    
    public func viewModelDetailForMovie(at index: Int) -> MovieDetailViewModel? {
        guard index < _movies.value.count else {
            return nil
        }
        let vmInput = MovieDetailViewModelInputs(movie: _movies.value[index], movieRepository: inputs.movieRepository)
        return MovieDetailViewModel(vmInput)
    }
    
    private func fetchMovies(by collectionType: TMDbMovieCollection) {
        _movies.accept([])
        _isFetching.accept(true)
        _error.accept(nil)
        inputs
            .movieRepository
            .fetchMovieCollection(by: collectionType, successHandler: {[weak self] (response) in
                self?._isFetching.accept(false)
                self?._movies.accept(response.results)
            }) { [weak self] (error) in
                self?._isFetching.accept(false)
                self?._error.accept(UIMessages.error)
        }
    }
    
}
