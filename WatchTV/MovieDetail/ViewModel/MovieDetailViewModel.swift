//
//  MovieDetailViewData.swift
//  WatchTV
//
//  Created by Tien Pham on 10/4/24.
//

import Foundation
import CoreData


// MARK:- ViewModel
class MovieDetailViewModel {
    weak var viewController: MovieDetailViewControllerProtocol?
    
    private var detail: MovieDetailModel?
    private var id: Int
    private var managedObjectContext: NSManagedObjectContext
    private var networkMonitor: NetworkPathMonitorProtocol
    private lazy var networkManager: NetworkManager = {
        return NetworkManager()
    }()
    private var isConnected: Bool = false
    
    init(_ id: Int, managedObjectContext: NSManagedObjectContext) {
        self.id = id
        self.managedObjectContext = managedObjectContext
        networkMonitor = NetworkPathMonitor()
        networkMonitor.pathUpdateHandler = { [weak self] status in
            DispatchQueue.main.async { [weak self] in
                print("Network changed. Connected: \(status == .satisfied)")
                self?.isConnected = status == .satisfied
            }
        }
        networkMonitor.start(queue: DispatchQueue.global())
    }
    
    deinit {
        self.networkMonitor.cancel();
    }
    
    func fetchMovieDetail() {
        if isConnected {
            print("Fetch movie detail on network")
            networkManager.fetchMovieDetail(id: id) { response in
                DispatchQueue.main.async { [weak self] in
                    guard let self = self, let response = response else { return }
                    self.handleMovieDetail(detail: response)
                }
            }
        } else if let result = MovieDetailMOHandler.fetchMovieDetail(id, moc: managedObjectContext) {
            print("Fetch movie detail on local")
            handleMovieDetailMO(detail: result)
        }
    }
    
    func handleMovieDetail(detail: MovieDetailModel) {
        self.detail = detail
        viewController?.updateView()
        MovieDetailMOHandler.addMovieDetail(detail, moc: managedObjectContext)
    }
    
    func handleMovieDetailMO(detail: MovieDetailModel) {
        self.detail = detail
        viewController?.updateView()
    }
    
    
    func movieDetailModel() -> MovieDetailModel? {
        return detail
    }
    
    func currentMOC() -> NSManagedObjectContext {
        return managedObjectContext
    }
}