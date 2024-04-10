//
//  MovieDetailViewData.swift
//  WatchTV
//
//  Created by Tien Pham on 10/4/24.
//

import Foundation
import CoreData

class MovieDetailViewData {
    var movieItemModel: MovieItemModel
    
    init(_ movieItemModel: MovieItemModel) {
        self.movieItemModel = movieItemModel
    }
}

class MovieDetailViewModel {
    weak var viewController: MovieDetailViewController?
    private var dataModel: MovieDetailViewData
    private var managedObjectContext: NSManagedObjectContext
    
    init(_ movieItemModel: MovieItemModel, managedObjectContext: NSManagedObjectContext) {
        dataModel = MovieDetailViewData(movieItemModel)
        self.managedObjectContext = managedObjectContext
    }
    
    func movieInfoModel() -> MovieItemModel {
        return dataModel.movieItemModel
    }
    
    func movieTitle() -> String {
        return dataModel.movieItemModel.title
    }
    
    func currentMOC() -> NSManagedObjectContext {
        return managedObjectContext
    }
}
