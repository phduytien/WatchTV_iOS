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
    
    init(_ managedObjectContext: NSManagedObjectContext) {
        viewModel = MovieListViewModel()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: { [weak self] in
            self?.viewModel.loadViewInitialData()
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
        setupNavigationBar();
        setupBackgroundView()
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationItem.hidesSearchBarWhenScrolling = true
    }
    
    private func setupNavigationBar() {
        title = "Trending Today"
    }
    
    private func setupSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search movie"
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        definesPresentationContext = true
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
        let tableView = UITableView(frame: view.frame, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .singleLine
        tableView.register(MovieTableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        
        homeTabView.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: homeTabView.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: homeTabView.leadingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: homeTabView.bottomAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: homeTabView.trailingAnchor).isActive = true
        
        return tableView
    }()
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension MovieListViewController: UITableViewDelegate, UITableViewDataSource {
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let movie = viewModel.movieItemModel(at: indexPath.row) {
            let movieDetailsVC = MovieDetailViewController(
                movie.id,
                title: movie.title,
                managedObjectContext: viewModel.currentMOC(),
                networkMonitor:  NetworkPathMonitor()
            )
            navigationController?.pushViewController(movieDetailsVC, animated: true)
        }
    }
}

// MARK: - MovieListViewControllerProtocol
extension MovieListViewController: MovieListViewControllerProtocol {
    func showMessage(_ message: String, type: MessageType) {
        Toast.showToast( message: message, type: type)
    }
    
    func updateView() {
        tableView.reloadData()
    }
}

// MARK: - UISearchResultsUpdating
extension MovieListViewController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else {
            viewModel.searchMovies(searchText: nil)
            return
        }
        viewModel.searchMovies(searchText: searchText)
    }
}
