//
//  TodayTrendingMOHandler.swift
//  WatchTV
//
//  Created by Tien Pham on 10/4/24.
//

import Foundation
import CoreData

class TodayTrendingMOHandler {
    
    private static let entityName = "TodayTrendingMO"
    
    
    static func saveTodayTrendingMovies(_ movies: [MovieItemModel], moc: NSManagedObjectContext) {
        TodayTrendingMOHandler.clearTodayTrendingMovies(moc: moc)
        if let entity = NSEntityDescription.entity(forEntityName: TodayTrendingMOHandler.entityName, in: moc) {
            let moviesMO = NSManagedObject(entity: entity, insertInto: moc)
            do {
                let moviesData = try? JSONEncoder().encode(movies)
                moviesMO.setValue(moviesData, forKeyPath: "movieListData")
                moviesMO.setValue(Date(), forKey: "timestamp")
                try moc.save()
            } catch let error as NSError {
                print("Could not save TodayTrendingMO entity record. Error \(error)")
            }
        }
    }
    
    static func fetchTodayTrendingMovies(in moc: NSManagedObjectContext) -> [MovieItemModel] {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: TodayTrendingMOHandler.entityName)
        do {
            let moviesMO = try moc.fetch(fetchRequest)
            guard moviesMO.count > 0, let moviesData = moviesMO[0].value(forKey: "movieListData") as? Data, let movies = try? JSONDecoder().decode([MovieItemModel].self, from: moviesData) else {
                return []
            }
            return movies
        } catch let error as NSError {
            print("Could not fetch TodayTrendingMO entity record. Error \(error)")
        }
        return []
    }
    
    static func clearTodayTrendingMovies(moc: NSManagedObjectContext) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: TodayTrendingMOHandler.entityName)
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try moc.execute(batchDeleteRequest)
        } catch {
            print("Could not remove TodayTrendingMO entity record. Error: \(error)")
        }
    }
}
