//
//  TodayTrendingViewDataModel.swift
//  WatchTV
//
//  Created by Tien Pham on 10/4/24.
//

import Foundation
import CoreData

// MARK:- DataModel
class TodayTrendingViewDataModel {
    var movieList: [MovieItemModel]
    var currentPageNumber: Int
    var totalPages: Int
    
    init() {
        movieList = []
        currentPageNumber = 0
        totalPages = 100
    }
}

// MARK:- ViewModel
class TodayTrendingViewModel {
    
    weak var viewController: MovieListViewControllerProtocol?
    
    private var isLoading: Bool = false
    private var isConnected = true
    private var isSearch: Bool = false
    private var keyword = ""
    
    private let dataModel = TodayTrendingViewDataModel()
    private let searchDataModel = TodayTrendingViewDataModel()
    private lazy var networkMonitor: NetworkPathMonitorProtocol = {
        let networkMonitor = NetworkPathMonitor()
        networkMonitor.pathUpdateHandler = { [weak self] status in
            DispatchQueue.main.async { [weak self] in
                print("Network changed. Connected: \(status == .satisfied)")
                let connected = status == .satisfied
                if !connected || connected != self?.isConnected {
                    self?.isConnected = connected
                    self?.viewController?.showMessage(
                        status == .satisfied ? "Internet Connected!" : "No Internet Connection. Offline Mode",
                        type: status == .satisfied ? MessageType.success : MessageType.warning
                    )
                }
            }
        }
        return networkMonitor
    }()
    private let managedObjectContext: NSManagedObjectContext
    private lazy var networkManager: NetworkManager = {
        return NetworkManager()
    }()
    
    init(_ moc: NSManagedObjectContext) {
        managedObjectContext = moc
        networkMonitor.start(queue: DispatchQueue.global())
    }
    
    deinit {
        networkMonitor.cancel();
    }
    
    func updateView() {
        isLoading = false
        viewController?.updateView()
    }
    
    // MARK:- Trending Today
    func fetchTodayTrendingData() {
        guard !isLoading else { return }
        isLoading = true
        if isConnected {
            print("Fetch today trending on network")
            networkManager.fetchTodayTrending(page: 1) { (response) in
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    guard let response = response else {
                        self.updateViewWithCachedMovies()
                        return
                    }
                    self.handleTodayTrendingResult(todayTrendingModel: response)
                }
            } failure: { error in
                DispatchQueue.main.async { [weak self] in
                    let err = error ?? "Something Went Wrong"
                    guard let self = self else { return }
                    self.viewController?.showMessage(err, type: MessageType.alert)
                }
            }
        } else {
            print("Fetch today trending on local")
            let movies = TodayTrendingMOHandler.fetchTodayTrendingMovies(in: managedObjectContext)
            // If list today trending movies is exists
            if movies.count > 0 {
                handleTodayTrendingMO(movies: movies)
            } else {
                viewController?.showMessage(
                    "Couldn't get list trending movies. Please try later!",
                    type: MessageType.alert
                )
            }
        }
    }
    
    func fetchNextPageTodayTrendingData() {
        guard !isLoading else { return }
        networkManager.fetchTodayTrending(page: dataModel.currentPageNumber + 1) { (response) in
            DispatchQueue.main.async { [weak self] in
                guard let self = self, let response = response else { return }
                self.handleTodayTrendingResult(todayTrendingModel: response)
            }
        } failure: { error in
            DispatchQueue.main.async { [weak self] in
                let err = error ?? "Something Went Wrong"
                guard let self = self else { return }
                self.viewController?.showMessage(err, type: MessageType.alert)
            }
        }
    }
    
    func handleTodayTrendingResult(todayTrendingModel: TodayTrendingResponseModel) {
        handleTodayTrendingPagination(todayTrendingModel: todayTrendingModel)
        appendMovies(todayTrendingModel.results)
        updateView()
        // Save/update list today trending movies
        TodayTrendingMOHandler.saveTodayTrendingMovies(dataModel.movieList, moc: managedObjectContext)
    }
    
    func handleTodayTrendingMO(movies: [MovieItemModel]) {
        appendMovies(movies)
        updateView()
    }
    
    func handleTodayTrendingPagination(todayTrendingModel: TodayTrendingResponseModel) {
        updateLastFetchedPageNumber(todayTrendingModel)
    }
    
    func appendMovies(_ movies: [MovieItemModel]) {
        dataModel.movieList.append(contentsOf: movies)
    }
    
    func updateLastFetchedPageNumber(_ todayTrendingModel: TodayTrendingResponseModel) {
        dataModel.currentPageNumber = todayTrendingModel.page
        dataModel.totalPages = todayTrendingModel.totalPages
        print("Load more: \(dataModel.currentPageNumber) out of \(dataModel.totalPages)")
    }
    
    func updateViewWithCachedMovies() {
        let movieModelList = TodayTrendingMOHandler.fetchTodayTrendingMovies(in: managedObjectContext)
        appendMovies(movieModelList)
        updateView()
    }
    
    func currentNetworkMonitor() -> NetworkPathMonitorProtocol {
        return networkMonitor
    }
    
    // MARK:- Search Movie
    
    func fetchSearchMoviesData() {
        guard !isLoading, !keyword.isEmpty else {
            return
        }
        if isConnected {
            print("Fetch search movie with keyword: \(keyword) on network")
            networkManager.searchMovies(keyword: keyword, page: 1, success: { response in
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    guard let response = response else {
                        self.updateViewWithCachedSearchMovies(keyword)
                        return
                    }
                    self.handleSearchMoviesResult(response, keyword: keyword, isNew: true)
                }
            }, failure: { error in
                DispatchQueue.main.async { [weak self] in
                    let err = error ?? "Something Went Wrong"
                    guard let self = self else { return }
                    self.viewController?.showMessage(err, type: MessageType.alert)
                }
            })
        } else {
            print("Fetch search movie with keyword: \(keyword) on local")
            let movies = SearchMovieListMOHandler.fetchSearchMovies(keyword, moc: managedObjectContext)
            if (movies.count > 0) {
                handleSearchMoviesMO(movies)
            } else {
                viewController?.showMessage(
                    "Couldn't search movies. Please try later!",
                    type: MessageType.alert
                )
            }
        }
    }
    
    func fetchNextPageSearchMoviesData() {
        guard !isLoading, !keyword.isEmpty else {
            return
        }
        isLoading = true
        networkManager.searchMovies(keyword: keyword, page: searchDataModel.currentPageNumber + 1) { (response) in
            DispatchQueue.main.async { [weak self] in
                guard let self = self, let response = response else { return }
                self.handleSearchMoviesResult(response, keyword: keyword, isNew: false)
            }
        } failure: { error in
            DispatchQueue.main.async { [weak self] in
                let err = error ?? "Something Went Wrong"
                guard let self = self else { return }
                self.viewController?.showMessage(err, type: MessageType.alert)
            }
        }
    }
    
    func handleSearchMoviesResult(_ model: SearchMoviesResponseModel, keyword: String, isNew: Bool) {
        if isNew {
            clearSearchMoviesModel()
        }
        updateSearchMoviesLastFetchedPageNumber(model)
        appendSearchMovies(model.results)
        updateView()
        SearchMovieListMOHandler.saveCurrentSearchMovies(
            keyword,
            movies: searchDataModel.movieList,
            moc: managedObjectContext
        )
    }
    
    func handleSearchMoviesMO(_ movies: [MovieItemModel]) {
        clearSearchMoviesModel()
        appendSearchMovies(movies)
        updateView()
    }
    
    func handleSearchMoviesPagination(_ model: SearchMoviesResponseModel) {
        updateSearchMoviesLastFetchedPageNumber(model)
    }
    
    func appendSearchMovies(_ movies: [MovieItemModel]) {
        searchDataModel.movieList.append(contentsOf: movies)
    }
    
    func updateSearchMoviesLastFetchedPageNumber(_ model: SearchMoviesResponseModel) {
        searchDataModel.currentPageNumber = model.page
        searchDataModel.totalPages = model.totalPages
        print("Search Movies - Load more: \(dataModel.currentPageNumber) out of \(dataModel.totalPages)")
    }
    
    func updateViewWithCachedSearchMovies(_ keyword: String) {
        clearSearchMoviesModel()
        let movieModelList = SearchMovieListMOHandler.fetchSearchMovies(keyword, moc: managedObjectContext)
        appendSearchMovies(movieModelList)
        updateView()
    }
    
    func clearSearchMoviesModel() {
        searchDataModel.movieList = []
        searchDataModel.currentPageNumber = 0
        searchDataModel.totalPages = 100
    }
}

// MARK:- MovieListViewModelProtocol
extension TodayTrendingViewModel: MovieListViewModelProtocol {
    func searchMovies(searchText: String?) {
        isSearch = !(searchText?.isEmpty ?? true)
        keyword = searchText ?? ""
        if let searchText = searchText, !searchText.isEmpty {
            fetchSearchMoviesData()
        } else {
            updateView()
        }
    }
    
    func loadViewInitialData() {
        fetchTodayTrendingData()
    }
    
    func moviesCount() -> Int {
        return isSearch ? searchDataModel.movieList.count : dataModel.movieList.count
    }
    
    func movieItemModel(at index: Int) -> MovieItemModel? {
        return isSearch ? searchDataModel.movieList[index] : dataModel.movieList[index]
    }
    
    func currentMOC() -> NSManagedObjectContext {
        return managedObjectContext
    }
    
    func checkAndHandleIfPaginationRequired(at row: Int) {
        let count = isSearch ? searchDataModel.movieList.count : dataModel.movieList.count
        let currentPageNumber = isSearch ? searchDataModel.currentPageNumber : dataModel.currentPageNumber
        let totalPages = isSearch ? searchDataModel.totalPages : dataModel.totalPages
        if (row + 2 == count) && (currentPageNumber < totalPages) {
            handlePaginationRequired()
        }
    }
    
    private func handlePaginationRequired() {
        let currentPageNumber = isSearch ? searchDataModel.currentPageNumber : dataModel.currentPageNumber
        if !isLoading && currentPageNumber != 0 && isConnected {
            if !keyword.isEmpty {
                fetchNextPageSearchMoviesData()
            } else {
                fetchNextPageTodayTrendingData()
            }
        }
    }
}

