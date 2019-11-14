//
//  MovieTableViewCell.swift
//  movies
//
//  Created by Santiago B on 16/04/2019.
//  Copyright © 2019 zeta. All rights reserved.
//

import UIKit

class MovieTableViewCell: UITableViewCell {

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    
    func configure(with viewModel: MovieCollectionItemViewModel?) {
        titleLabel.text = viewModel?.title ?? ""
        overviewLabel.text = viewModel?.overview ?? ""
        if let posterURL = viewModel?.posterURL {
            posterImageView.setImage(fromURL: posterURL)
        } else {
            posterImageView.image = nil
        }
    }
}

extension MovieTableViewCell: NibLoadableView { }

extension MovieTableViewCell: ReusableView { }
