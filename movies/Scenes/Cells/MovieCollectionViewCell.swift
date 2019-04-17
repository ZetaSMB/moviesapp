//
//  FilmCollectionViewCell.swift
//  movies
//
//  Created by Santiago B on 16/04/2019.
//  Copyright © 2019 zeta. All rights reserved.
//

import UIKit

public final class MovieCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var filmPosterImageView: UIImageView!
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor(white: 0.8, alpha: 0.15)
    }
    
    func configure(with viewModel: MovieCollectionItemViewModel?) {
        if let posterURL = viewModel?.posterURL {
            self.filmPosterImageView.setImage(fromURL: posterURL)
        }
    }
}

extension MovieCollectionViewCell: NibLoadableView { }

extension MovieCollectionViewCell: ReusableView { }
