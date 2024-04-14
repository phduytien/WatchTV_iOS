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
    private var networkManager: NetworkManager
    
    private var isConnected = true
    
    init(_ id: Int, managedObjectContext: NSManagedObjectContext, networkMonitor: NetworkPathMonitorProtocol, networkManager: NetworkManager) {
        self.id = id
        self.managedObjectContext = managedObjectContext
        self.networkManager = networkManager
        self.networkMonitor = networkMonitor
        self.networkMonitor.pathUpdateHandler = { [weak self] status in
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
        self.networkMonitor.start(queue: DispatchQueue.global())
    }
    
    deinit {
        networkMonitor.cancel();
    }
    
    func fetchMovieDetail() {
        // In case internet connected
        if isConnected {
            print("Fetch movie detail on network")
            networkManager.fetchMovieDetail(id: id) { response in
                DispatchQueue.main.async { [weak self] in
                    guard let self = self, let response = response else { return }
                    self.handleMovieDetail(detail: response)
                }
            } failure: { error in
                DispatchQueue.main.async { [weak self] in
                    let err = error ?? "Something Went Wrong"
                    guard let self = self else { return }
                    self.viewController?.showMessage(err, type: MessageType.alert)
                }
            }
        }
        // Else internet not connected
        else {
            // Fetch movie detail on local database
            if let result = MovieDetailMOHandler.fetchMovieDetail(id, moc: managedObjectContext) {
                print("Fetch movie detail on local")
                handleMovieDetailMO(detail: result)
            } else {
                print("Movie detail isn't existed")
                viewController?.showMessage(
                    "Couldn't get movie. Please try later!",
                    type: MessageType.alert
                )
            }
        }
    }
    
    func handleMovieDetail(detail: MovieDetailModel) {
        self.detail = detail
        viewController?.updateView()
        // Save/update movie detail on local database
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
