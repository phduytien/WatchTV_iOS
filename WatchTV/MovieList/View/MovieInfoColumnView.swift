//
//  MovieInfoColumnView.swift
//  WatchTV
//
//  Created by Tien Pham on 10/4/24.
//

import Foundation
import SwiftUI

class MovieInfoColumnView: UIView {
    private var item: MovieItemModel
    
    init(frame: CGRect, item: MovieItemModel) {
        self.item = item
        super.init(frame: frame)
        self.backgroundColor = .clear
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
        
        self.addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        return stackView
    }()
    
    func addViewsToStackView() {
        stackView.addArrangedSubview(UIView())
        stackView.addArrangedSubview(
            arrangedViewForTitleAndSubtitle(
                title: item.title,
                subtitle: item.overview,
                releaseDate: item.releaseDate,
                votingAverage: item.voteAverage
            )
        )
        stackView.addArrangedSubview(UIView())
    }
    
    func arrangedViewForTitleAndSubtitle(title: String, subtitle: String, releaseDate: String, votingAverage: Float) -> UIView {
        let containerView = UIStackView(frame: .zero)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.axis = .vertical
        containerView.distribution = .equalSpacing
        
        containerView.addArrangedSubview(titleViewForText(title))
        containerView.addArrangedSubview(separatorView(4))
        containerView.addArrangedSubview(subtitleViewForText(subtitle))
        containerView.addArrangedSubview(separatorView(8))
        containerView.addArrangedSubview(releaseDateViewForText(releaseDate))
        containerView.addArrangedSubview(separatorView(4))
        containerView.addArrangedSubview(ratingViewForText(votingAverage))
        
        return containerView
    }
    
    func titleViewForText(_ text: String) -> UIView {
        let label = UILabel()
        label.text = text
        label.font = UIFont.preferredFont(forTextStyle: .title2).bold()
        label.minimumScaleFactor = 0.75
        label.adjustsFontForContentSizeCategory = true
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .darkGray
        label.backgroundColor = .clear
        label.numberOfLines = 1
        return label
    }
    
    func subtitleViewForText(_ text: String) -> UIView {
        let label = UILabel()
        label.text = text
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .gray
        label.backgroundColor = .clear
        label.numberOfLines = 2
        return label
    }
    
    func ratingViewForText(_ vote: Float) -> UIView {
        let label = UILabel()
        label.text = "⭐️ Rating: \(vote)/10"
        label.font = UIFont.preferredFont(forTextStyle: .callout)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .gray
        label.backgroundColor = .clear
        label.numberOfLines = 2
        return label
    }
    
    func releaseDateViewForText(_ text: String) -> UIView {
        let label = UILabel()
        label.text = "Release Date: \(text)"
        label.font = UIFont.preferredFont(forTextStyle: .callout)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .gray
        label.backgroundColor = .clear
        label.numberOfLines = 2
        return label
    }
    
    
    func separatorView(_ spacing: CGFloat) -> UIView {
        let separator = UIView()
        separator.heightAnchor.constraint(equalToConstant: spacing).isActive = true
        return separator
    }
}
