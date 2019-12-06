//
//  MovieCollectionViewModelTest.swift
//  moviesTests
//
//  Created by Santiago on 12/6/19.
//  Copyright © 2019 zeta. All rights reserved.
//

import XCTest
import Foundation
import RxSwift
import RxCocoa
import RxTest
import RxBlocking
import OHHTTPStubs

@testable import movies

class MovieCollectionViewModelTest: XCTestCase {
    var sut: MovieCollectionViewModel!
    var sutInputs: MovieCollectionViewModelInputs!
    var sutTrigger: BehaviorSubject<TMDbMovieCollection>!
    var mockedRepository: MockedTMDbRepository!
    var scheduler: TestScheduler!
    var disposeBag: DisposeBag!
    
    private let jsonDecoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-mm-dd"
        jsonDecoder.dateDecodingStrategy = .formatted(dateFormatter)
        return jsonDecoder
    }()
    
    override func setUp() {
        sutTrigger = BehaviorSubject<TMDbMovieCollection>(value: .upcoming)
        mockedRepository = MockedTMDbRepository()
        sutInputs = MovieCollectionViewModelInputs(
            movieRepository: mockedRepository,
            collectionTypeSelected: sutTrigger.asDriver(onErrorJustReturn: .upcoming)
        )
        sut = MovieCollectionViewModel(sutInputs)
        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
        scheduler = nil
        sutInputs = nil
        disposeBag = nil
    }
    
    func testUpcomingOutput() throws {
// does not work, probably related to this issue:
// https://stackoverflow.com/questions/32879545/ohhttpstubs-not-stubbing-host
//Mocking is not really necessary
//        stub(condition: { (req) -> Bool in
//            return req.urlRequest?.description == TMDbRequest.collection(.upcoming).urlRequest?.description
//        }) { _ in return
//            OHHTTPStubsResponse(
//                fileAtPath: OHPathForFile("StubMovieCollectionResponse_Upcoming.json", type(of: self))!,
//                statusCode: 200,
//                headers: ["Content-Type":"application/json"]
//            )
//        }
        
        let moviesOutput = scheduler.createObserver([Movie].self)
        sut.outputs.movies
            .drive(moviesOutput)
            .disposed(by: disposeBag)
        
        // mock a reload
        let events: [Recorded<Event<TMDbMovieCollection>>] = []//[.next(10, .upcoming)]
        scheduler.createColdObservable(events)
            .bind(to: sutTrigger)
            .disposed(by: disposeBag)

        scheduler.start()

//        XCTAssertEqual(try sut.outputs.movies.asObservable().toBlocking().first(), mockedRepository.allFetchedMovies)
//        XCTAssertEqual(moviesOutput.events.count, 1)
        //above lines are equals than this
        XCTAssertEqual(moviesOutput.events, [Recorded.next(0, mockedRepository.allFetchedMovies)])
    }
}
