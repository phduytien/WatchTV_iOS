//
//  MovieTableViewCell.swift
//  WatchTV
//
//  Created by Tien Pham on 10/4/24.
//

import Foundation
import UIKit

class MovieTableViewCell: UITableViewCell {
    private var movieInfoView: MovieInfoView?
    
    override func prepareForReuse() {
        movieInfoView?.removeFromSuperview()
        movieInfoView = nil
        super.prepareForReuse()
    }
    
    func configure(with item: MovieItemModel) {
        backgroundColor = .clear
        selectionStyle = .none
        setupMovieInfoView(with: item)
    }
    
    func setupMovieInfoView(with item: MovieItemModel) {
        let view = MovieInfoView(frame: .zero, item: item)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(view)
        view.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5).isActive = true
        view.heightAnchor.constraint(equalToConstant: 150).isActive = true
        view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5).isActive = true
        view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        
        movieInfoView = view
    }
    
}
