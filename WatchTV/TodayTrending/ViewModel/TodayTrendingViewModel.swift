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
        totalPages = 100 // default upper limit
    }
}

// MARK:- ViewModel
public class TodayTrendingViewModel: MovieListViewModelProtocol {
    
    private var isLoading: Bool
    private let dataModel: TodayTrendingViewDataModel
    private let managedObjectContext: NSManagedObjectContext
    private lazy var networkManager: NetworkManager = {
        return NetworkManager()
    }()
    
    weak var viewController: MovieListViewControllerProtocol?
    
    init(_ moc: NSManagedObjectContext) {
        dataModel = TodayTrendingViewDataModel()
        managedObjectContext = moc
        isLoading = true
    }
    
    func fetchTodayTrendingData() {
        networkManager.fetchTodayTrending(page: 1) { (response) in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                guard let response = response else {
                    self.updateViewWithCachedMovieList()
                    return
                }
                self.handleTodayTrendingResult(todayTrendingModel: response)
            }
        }
    }
    
    func fetchNextPageTodayTrendingData() {
        networkManager.fetchTodayTrending(page: dataModel.currentPageNumber+1) { (response) in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                guard let response = response else {
                    self.isLoading = false
                    return
                }
                self.handleTodayTrendingResult(todayTrendingModel: response)
            }
        }
    }
    
    func handleTodayTrendingResult(todayTrendingModel: TodayTrendingResponseModel) {
        handlePageDetails(todayTrendingModel: todayTrendingModel)
        addMovieInfoModelToMovieList(todayTrendingModel.results)
        updateView()
        NowPlayingMOHandler.saveCurrentMovieList(dataModel.movieList, moc: managedObjectContext)
    }
    
    func handlePageDetails(todayTrendingModel: TodayTrendingResponseModel) {
        updateLastFetchedPageNumber(todayTrendingModel)
    }
    
    func addMovieInfoModelToMovieList(_ modelList: [MovieItemModel]) {
        for movieInfoModel in modelList {
            dataModel.movieList.append(movieInfoModel)
        }
    }
    
    func updateLastFetchedPageNumber(_ todayTrendingModel: TodayTrendingResponseModel) {
        dataModel.currentPageNumber = todayTrendingModel.page
        dataModel.totalPages = todayTrendingModel.totalPages
        print("\(dataModel.currentPageNumber) out of \(dataModel.totalPages)")
    }
    
    func updateViewWithCachedMovieList() {
        let movieModelList = NowPlayingMOHandler.fetchSavedNowPlayingMovieList(in: managedObjectContext)
        addMovieInfoModelToMovieList(movieModelList)
        updateView()
    }
    
    func updateView() {
        isLoading = false
        viewController?.updateView()
    }
    
    // MARK: MovieListViewModelProtocol
    func didTap() {
        // Does nothing
    }
    
    func loadViewInitialData() {
        fetchTodayTrendingData()
    }
    
    func moviesCount() -> Int {
        return dataModel.movieList.count
    }
    
    func movieItemModel(at index: Int) -> MovieItemModel? {
        return dataModel.movieList[index]
    }
    
    func currentMOC() -> NSManagedObjectContext {
        return managedObjectContext
    }
}

// MARK:- Pagination
extension TodayTrendingViewModel {
    func checkAndHandleIfPaginationRequired(at row: Int) {
        if (row + 2 == dataModel.movieList.count) && (dataModel.currentPageNumber != dataModel.totalPages) {
            handlePaginationRequired()
        }
    }
    
    func handlePaginationRequired() {
        if !isLoading && dataModel.currentPageNumber != 0 {
            isLoading = true
            fetchNextPageTodayTrendingData()
        }
    }
}

