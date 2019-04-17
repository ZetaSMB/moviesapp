//
//  UIScrollView+Reactive.swift
//  movies
//
//  Created by Santiago B on 13/04/2019.
//  Copyright © 2019 zeta. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: UIScrollView {
        
    public var reachedBottom: Observable<Void> {
        return contentOffset
            .flatMap { [unowned base] (contentOffset) -> Observable<Void> in
                let visibleHeight = base.frame.height - base.contentInset.top - base.contentInset.bottom
                let y = contentOffset.y + base.contentInset.top
                let threshold = max(0.0, base.contentSize.height - visibleHeight)
                return (y > threshold) ? Observable.just(()) : Observable.empty()
        }
    }
}
