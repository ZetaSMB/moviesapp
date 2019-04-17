//
//  FirstViewController.swift
//  movies
//
//  Created by Santiago B on 16/04/2019.
//  Copyright © 2019 zeta. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class MovieCollectionViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var errorInfoLabel: UILabel!
    @IBOutlet weak var categoryCollectionSegControl: UISegmentedControl!
    
    var movieCollectionViewModel: MovieCollectionViewModel!
    let disposeBag = DisposeBag()
    
    
    fileprivate enum UIConstants {
        static let margin: CGFloat = 15.0
        static let nbrOfItemsInARow: CGFloat = 2.0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        
        setupSegmentedController()
        
        movieCollectionViewModel = MovieCollectionViewModel(collectionType: categoryCollectionSegControl.rx.selectedSegmentIndex
            .map { TMDbMovieCollection(index: $0) ?? .popular }
            .asDriver(onErrorJustReturn: .popular)
            , movieRepository: TMDbRepository.shared)
        
        movieCollectionViewModel.movies.drive(onNext: {[unowned self] (_) in
                self.collectionView.reloadSections(IndexSet(integersIn: 0...0))
        }).disposed(by: disposeBag)

        movieCollectionViewModel.isFetching.drive(activityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)

        movieCollectionViewModel.error.drive(onNext: {[unowned self] (error) in
            self.errorInfoLabel.isHidden = !self.movieCollectionViewModel.hasError
            self.errorInfoLabel.text = error
        }).disposed(by: disposeBag)
    }
    
    private func setupSegmentedController() {
        self.categoryCollectionSegControl.removeAllSegments()
        var idx = 0
        for collectionType in TMDbMovieCollection.allCases {
            self.categoryCollectionSegControl.insertSegment(withTitle: collectionType.description, at: idx, animated: false)
            idx+=1
        }
        self.categoryCollectionSegControl.selectedSegmentIndex = 0
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerReusableCell(MovieCollectionViewCell.self)
    }
    
}
extension MovieCollectionViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieCollectionViewModel.numberOfMovies
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: MovieCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        cell.configure(with: movieCollectionViewModel.viewModelItemForMovie(at: indexPath.row))
        return cell
    }
}

extension MovieCollectionViewController: UICollectionViewDelegate {
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        if let vm = movieCollectionViewModel.viewModelDetailForMovie(at: indexPath.row), let vcDetail = MovieDetailViewController.createMovieDetailController(detailViewModel:vm) {
            self.navigationController?.pushViewController(vcDetail, animated: true)
        }
    }
}

extension MovieCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenSize = UIScreen.main.bounds
        let cellWidth = (screenSize.width - (UIConstants.margin*(UIConstants.nbrOfItemsInARow+1))) / UIConstants.nbrOfItemsInARow
        let cellHeight = cellWidth*ImageSize.heightPosterRatio;
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.self.init(top: UIConstants.margin, left: UIConstants.margin, bottom: UIConstants.margin, right: UIConstants.margin)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return UIConstants.margin
    }
    
}
