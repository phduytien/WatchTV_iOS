//
//  MovieInfoView.swift
//  WatchTV
//
//  Created by Tien Pham on 10/4/24.
//

import Foundation
import UIKit

class MovieInfoView: UIView {
    private var item: MovieItemModel
    
    init(frame: CGRect, item: MovieItemModel) {
        self.item = item
        super.init(frame: frame)
        movieImage.isHidden = false
        movieColumnDetail.isHidden = false
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
        imageView.leadingAnchor.constraint(equalTo:leadingAnchor, constant: 0).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 140).isActive = true
        
        imageView.backgroundColor = .clear
        imageView.clipsToBounds = true
        
        ImageHelper.setupImageForView(imageView, url: item.posterPath)
        return imageView
    }()
    
    private lazy var movieColumnDetail: MovieInfoColumnView = {
        let columnView = MovieInfoColumnView(frame: .zero, item: item)
        columnView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(columnView)
        columnView.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        columnView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        columnView.leadingAnchor.constraint(equalTo: movieImage.trailingAnchor, constant: 20).isActive = true
        columnView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
        return columnView
    }()
}
