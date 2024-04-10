//
//  MovieListViewController.swift
//  WatchTV
//
//  Created by Tien Pham on 10/4/24.
//

import Foundation
import CoreData
import UIKit

class MovieListViewController: UIViewController {
    private let cellReuseIdentifier = "MovieTableViewCell"
    
    var viewModel: MovieListViewModelProtocol
    
    public init(_ managedObjectContext: NSManagedObjectContext) {
        viewModel = MovieListViewModel()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar();
        setupBackgroundView()
        viewModel.loadViewInitialData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)
        super.viewWillAppear(animated)
    }
    
    private func setupNavigationBar() {
        title = "Trending Movie Today"
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search movie"
        self.navigationItem.searchController = searchController
        self.definesPresentationContext = true
        navigationItem.searchController = searchController
    }
    
    private func setupBackgroundView() {
        view.backgroundColor = .white
    }
    
    private lazy var homeTabView: UIView = {
        let homeTabView = UIView.init(frame: view.frame)
        homeTabView.translatesAutoresizingMaskIntoConstraints = false
        homeTabView.backgroundColor = .clear
        
        view.addSubview(homeTabView)
        homeTabView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        homeTabView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        homeTabView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        homeTabView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        return homeTabView
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: self.view.frame, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .singleLine
        tableView.register(MovieTableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        
        self.homeTabView.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: self.homeTabView.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: self.homeTabView.leadingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.homeTabView.bottomAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: self.homeTabView.trailingAnchor).isActive = true
        
        return tableView
    }()
}

extension MovieListViewController: UITableViewDelegate, UITableViewDataSource, MovieListViewControllerProtocol {
    func updateView() {
        tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.moviesCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as? MovieTableViewCell else {
            return UITableViewCell()
        }
        
        viewModel.checkAndHandleIfPaginationRequired(at: indexPath.row)
        
        if let movieModel = viewModel.movieItemModel(at: indexPath.row) {
            cell.configure(with: movieModel)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let movieModel = viewModel.movieItemModel(at: indexPath.row) {
            let movieDetailsVC = MovieDetailViewController(movieModel, managedObjectContext: viewModel.currentMOC())
            navigationController?.pushViewController(movieDetailsVC, animated: true)
        }
    }
}
