//
//  MovieDetailColumnView.swift
//  WatchTV
//
//  Created by Tien Pham on 10/4/24.
//

import Foundation
import UIKit

class MovieDetailColumnView: UIView {
    private var movieModel: MovieDetailModel?
    
    init(frame: CGRect, movieModel: MovieDetailModel?) {
        self.movieModel = movieModel
        super.init(frame: frame)
        backgroundColor = .clear
        addViewsToStackView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .equalCentering
        
        addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
        stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
        return stackView
    }()
    
    func addViewsToStackView() {
        stackView.addArrangedSubview(UIView())
        stackView.addArrangedSubview(arrangedViewForTitleAndSubtitle("Release Date", subtitle: movieModel?.releaseDate ?? "N/A"))
        stackView.addArrangedSubview(arrangedViewForTitleAndSubtitle("⭐️ Rating", subtitle: "\(String(movieModel?.voteAverage ?? 0))/10"))
        stackView.addArrangedSubview(arrangedViewForTitleAndSubtitle("♥️ Popularity", subtitle: "\(String(movieModel?.popularity ?? 0))"))
        stackView.addArrangedSubview(UIView())
    }
    
    func arrangedViewForTitleAndSubtitle(_ title: String, subtitle: String) -> UIView {
        let containerView = UIStackView(frame: .zero)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.axis = .vertical
        containerView.distribution = .fillProportionally
        
        containerView.addArrangedSubview(titleViewForText(title))
        containerView.addArrangedSubview(separatorView())
        containerView.addArrangedSubview(subtitleViewForText(subtitle))
        
        return containerView
    }
    
    func titleViewForText(_ text: String) -> UIView {
        let label = UILabel()
        label.text = text
        label.font = UIFont.preferredFont(forTextStyle: .title2)
        label.minimumScaleFactor = 0.75
        label.adjustsFontForContentSizeCategory = true
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .lightGray
        label.backgroundColor = .clear
        label.numberOfLines = 0
        return label
    }
    
    func subtitleViewForText(_ text: String) -> UIView {
        let label = UILabel()
        label.text = text
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .gray
        label.backgroundColor = .clear
        label.numberOfLines = 0
        return label
    }
    
    func separatorView() -> UIView {
        let separator = UIView()
        separator.heightAnchor.constraint(equalToConstant: 5).isActive = true
        return separator
    }
}
