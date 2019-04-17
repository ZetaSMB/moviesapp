//
//  MovieDetailViewController.swift
//  movies
//
//  Created by Santiago B on 16/04/2019.
//  Copyright © 2019 zeta. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MovieDetailViewController: UIViewController {
    
    @IBOutlet weak var backdropImageView: UIImageView!
    @IBOutlet weak var backdropImageViewHeight: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollContentView: UIView!
    
    @IBOutlet weak var filmTitleLabel: UILabel!
    @IBOutlet weak var filmOverviewLabel: UILabel!
    @IBOutlet weak var filmDetailsLabel: UILabel!
    
    @IBOutlet weak var creditsView: UIView!
    @IBOutlet weak var castView: UIView!
    @IBOutlet weak var castViewHeight: NSLayoutConstraint!
    @IBOutlet weak var castLabel: UILabel!
    @IBOutlet weak var castCollectionView: UICollectionView!
    
    fileprivate var detailViewModel: MovieDetailViewModel!
    
    let disposeBag: DisposeBag = DisposeBag()
    
    fileprivate enum UIConstants {
        static let margin: CGFloat = 15.0
    }
    
    public static func createMovieDetailController(detailViewModel: MovieDetailViewModel) -> MovieDetailViewController? {
        let storyboard = UIStoryboard.init(name:"Main", bundle:nil)
        if let vc = storyboard.instantiateViewController(withIdentifier:"MovieDetailViewController") as? MovieDetailViewController {
            vc.detailViewModel = detailViewModel
            return vc
        }
        return nil
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupCollectionViews()
        setupBindings()
    }
    
    var didSetupOffset : Bool = false
    
    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let height: CGFloat = self.view.bounds.width * ImageSize.heightPosterRatio
        self.scrollView.contentInset = UIEdgeInsets(top: height, left: 0, bottom: 0, right: 0)
        self.scrollView.scrollIndicatorInsets = UIEdgeInsets(top: height, left: 0, bottom: 0, right: 0)
        DispatchQueue.main.async {
            if (!self.didSetupOffset) {
                self.didSetupOffset = true
                self.scrollView.setContentOffset(CGPoint(x:0,y:-height), animated: false)
            }
        }
    }
    
    fileprivate func setupUI() {
        navigationController?.navigationBar.prefersLargeTitles = false
        backdropImageView.contentMode = .scaleAspectFill
        if let imgURL = self.detailViewModel.topImageURL {
            backdropImageView.setImage(fromURL:imgURL)
        }
        filmOverviewLabel.text = self.detailViewModel.overview
        filmTitleLabel.text = self.detailViewModel.title
        navigationItem.title = self.detailViewModel.title
        scrollView.layoutIfNeeded()
    }
    
    fileprivate func setupCollectionViews() {
        castCollectionView.delegate = self
        castCollectionView.dataSource = self
       castCollectionView.registerReusableCell(CastMemberCollectionViewCell.self)
    }
    
    fileprivate func updateBackdropImageViewHeight(forScrollOffset offset: CGPoint?) {
        if let height = offset?.y {
            self.backdropImageViewHeight.constant = max(0.0, -height)
        } else {
            let height: CGFloat = self.view.bounds.width * ImageSize.heightPosterRatio
            self.backdropImageViewHeight.constant = max(0.0, height)
        }
    }
    
    fileprivate func setupBindings() {
        
        detailViewModel?.fetchMovieDetail()
        
        detailViewModel?
            .movieInfo
            .drive(onNext: { [weak self] (txt) in
                self?.filmDetailsLabel.text = txt
            }).disposed(by: disposeBag)
        
        scrollView.rx
            .contentOffset
            .subscribe { [weak self] (contentOffset) in
                self?.updateBackdropImageViewHeight(forScrollOffset: contentOffset.element)
            }.disposed(by: disposeBag)
        
        self.detailViewModel
            .movieCast
            .drive(onNext: {[unowned self] (movieCast) in
                let defaultHeight: CGFloat = 210.0
                if movieCast.count > 0 {
                    self.castLabel.text = "Cast"
                    self.castViewHeight.constant = defaultHeight
                } else {
                    self.castLabel.text = nil
                    self.castViewHeight.constant = 0.0
                }
                UIView.animate(withDuration: 0.2) {
                    self.castView.alpha = 1.0
                }
                self.castCollectionView.reloadSections(IndexSet(integersIn: 0...0))
                self.scrollView.layoutIfNeeded()
            }).disposed(by: disposeBag)
    }
}


extension MovieDetailViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.detailViewModel.numberOfCastPersons
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CastMemberCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        cell.configure(with: self.detailViewModel.castMemberViewModelForIndex(indexPath.row))
        return cell
    }
}

extension MovieDetailViewController: UICollectionViewDelegateFlowLayout {
        
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80.0, height: collectionView.bounds.height)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: UIConstants.margin, bottom: 0, right: UIConstants.margin)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return UIConstants.margin
    }
}
