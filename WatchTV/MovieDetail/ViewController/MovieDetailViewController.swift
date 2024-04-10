//
//  MovieDetailViewController.swift
//  WatchTV
//
//  Created by Tien Pham on 10/4/24.
//

import Foundation
import CoreData
import UIKit

class MovieDetailViewController: UIViewController, MovieDetailViewControllerProtocol {
    
    private var viewModel: MovieDetailViewModel
    private var movieTitle: String
    
    init(_ id: Int, title: String, managedObjectContext: NSManagedObjectContext) {
        viewModel = MovieDetailViewModel(id, managedObjectContext: managedObjectContext)
        movieTitle = title
        super.init(nibName: nil, bundle: nil)
        viewModel.viewController = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else { return }
            self.viewModel.fetchMovieDetail()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.navigationBar.topItem?.title = ""
        setupNavigationBar()
        setupBackgroundView()
        super.viewWillAppear(animated)
    }
    
    private func setupNavigationBar() {
        title = movieTitle
    }
    
    private func setupBackgroundView() {
        view.backgroundColor = .white
    }
    
    func updateView() {
        movieTopView.isHidden = false
        movieOverview.isHidden = false
    }
    
    private lazy var movieTopView: MovieDetailTopView = {
        let topView = MovieDetailTopView(frame: .zero, movieModel: viewModel.movieDetailModel())
        topView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(topView)
        topView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        topView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        topView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        return topView
    }()
    
    private lazy var movieOverview: MovieDetailOverview = {
        let overview = MovieDetailOverview(frame: .zero, movieModel: viewModel.movieDetailModel())
        overview.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(overview)
        overview.topAnchor.constraint(equalTo: movieTopView.bottomAnchor, constant: 20).isActive = true
        overview.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        overview.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        overview.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        return overview
    }()
}
