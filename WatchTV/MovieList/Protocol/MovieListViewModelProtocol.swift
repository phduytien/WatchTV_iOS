//
//  MovieListViewModelProtocol.swift
//  WatchTV
//
//  Created by Tien Pham on 10/4/24.
//

import Foundation
import CoreData

protocol MovieListViewModelProtocol {
    var viewController: MovieListViewControllerProtocol? { get set }
    
    func loadViewInitialData()
    func searchMovies(searchText: String?)
    func moviesCount() -> Int
    func movieItemModel(at index: Int) -> MovieItemModel?
    func currentMOC() -> NSManagedObjectContext
    func checkAndHandleIfPaginationRequired(at row: Int)
}

class MovieListViewModel: MovieListViewModelProtocol {
    
    weak var viewController: MovieListViewControllerProtocol?
    
    init() {
        // Does nothing
    }
    
    func loadViewInitialData() {
        // Does nothing
    }
    
    func moviesCount() -> Int {
        return 0
    }
    
    func movieItemModel(at index: Int) -> MovieItemModel? {
        return nil
    }
    
    func currentMOC() -> NSManagedObjectContext {
        return NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    }
    
    func checkAndHandleIfPaginationRequired(at row: Int) {
        // Does nothing
    }
    
    func searchMovies(searchText: String?) {
    
    }
}
