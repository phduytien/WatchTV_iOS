//
//  MovieDetailTopView.swift
//  WatchTV
//
//  Created by Tien Pham on 10/4/24.
//

import Foundation
import UIKit

class MovieDetailTopView: UIView {
    private var movieModel: MovieDetailModel?
    
    init(frame: CGRect, movieModel: MovieDetailModel?) {
        self.movieModel = movieModel
        super.init(frame: frame)
        movieImage.isHidden = false
        movieColumnDetails.isHidden = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var movieImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(imageView)
        imageView.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
        imageView.trailingAnchor.constraint(equalTo: centerXAnchor, constant: -10).isActive = true
        
        imageView.backgroundColor = .clear
        imageView.clipsToBounds = true
        
        ImageHelper.setupImageForView(imageView, url: movieModel?.posterPath)
        return imageView
    }()
    
    private lazy var movieColumnDetails: MovieDetailColumnView = {
        let columnView = MovieDetailColumnView(frame: .zero, movieModel: movieModel)
        columnView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(columnView)
        columnView.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        columnView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        columnView.leadingAnchor.constraint(equalTo: centerXAnchor, constant: 10).isActive = true
        columnView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
        return columnView
    }()
}
