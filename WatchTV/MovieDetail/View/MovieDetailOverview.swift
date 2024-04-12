//
//  MovieDetailOverview.swift
//  WatchTV
//
//  Created by Tien Pham on 10/4/24.
//

import Foundation
import SwiftUI

class MovieDetailOverview: UIView {
    private var movieModel: MovieDetailModel?
    
    init(frame: CGRect, movieModel: MovieDetailModel?) {
        self.movieModel = movieModel
        super.init(frame: frame)
        backgroundColor = .clear
        overviewTitle.isHidden = false
        overviewText.isHidden = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var overviewTitle: UIView = {
        let titleView = UITextView(frame: .zero)
        titleView.translatesAutoresizingMaskIntoConstraints = false
        titleView.isScrollEnabled = false
        titleView.isEditable = false
        titleView.text = "Overview"
        titleView.textColor = .lightGray
        titleView.font = .boldSystemFont(ofSize: 22)
        
        addSubview(titleView)
        titleView.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        titleView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        titleView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
        titleView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
        return titleView
    }()
    
    private lazy var overviewText: UITextView = {
        let textView = UITextView(frame: .zero)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isEditable = false
        textView.text = movieModel?.overview ?? ""
        textView.textColor = .gray
        textView.font = .systemFont(ofSize: 16)
        
        addSubview(textView)
        textView.topAnchor.constraint(equalTo: overviewTitle.bottomAnchor, constant: 0).isActive = true
        textView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        textView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
        textView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
        return textView
    }()
}

