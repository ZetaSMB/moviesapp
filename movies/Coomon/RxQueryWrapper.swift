////
////  RxQueryWrapper.swift
////  movies
////
////  Created by Santiago on 11/16/19.
////  Copyright © 2019 zeta. All rights reserved.
////
//
//import Foundation
//import RxSwift
//import RxCocoa
//
//let isNetworkActive: Driver<Bool> = {
//    return networkActivity.asDriver()
//}()
//
//private let networkActivity = ActivityIndicator()
//
//typealias URLResponse = Result<(data: Data, response: HTTPURLResponse), Error>
//
//func queryWrapper(with request: URLRequest) -> Single<URLResponse> {
//    return Single.create { observer in
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            if let data = data, let response = response as? HTTPURLResponse {
//                observer(.success(.success((data: data, response: response))))
//            } else {
//                observer(.success(.failure(error ?? RxError.unknown)))
//            }
//        }
//        task.resume()
//        return Disposables.create { task.cancel() }
//    }
//    .trackActivity(networkActivity)
//    .asSingle()
//}
