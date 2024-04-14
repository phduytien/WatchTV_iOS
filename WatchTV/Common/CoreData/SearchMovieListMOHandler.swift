//
//  SearchMoviesMOHandler.swift
//  WatchTV
//
//  Created by Tien Pham on 10/4/24.
//

import Foundation
import CoreData

class SearchMovieListMOHandler {
    
    private static let entityName = "SearchMovieListMO"
    
    
    static func saveCurrentSearchMovies(_ key: String, movies: [MovieItemModel], moc: NSManagedObjectContext) {
        // Check if keyword is exists, then remove and update it
        if SearchMovieListMOHandler.checkKeywordIsExist(key, moc: moc) {
            SearchMovieListMOHandler.removeSearchMovies(key, moc: moc)
        }
        if let entity = NSEntityDescription.entity(forEntityName: SearchMovieListMOHandler.entityName, in: moc) {
            let moviesMO = NSManagedObject(entity: entity, insertInto: moc)
            let moviesData = try? JSONEncoder().encode(movies)
            moviesMO.setValue(key, forKey: "keyword")
            moviesMO.setValue(moviesData, forKey: "movieListData")
            moviesMO.setValue(Date(), forKey: "timestamp")
            do {
                try moc.save()
            } catch let error as NSError {
                print("Could not save SearchMovieMO for keyword: \(key). Error: \(error)")
            }
        }
    }
    
    static func checkKeywordIsExist(_ key: String, moc: NSManagedObjectContext) -> Bool {
        return !fetchSearchMovies(key, moc: moc).isEmpty
    }
    
    static func fetchSearchMovies(_ key: String, moc: NSManagedObjectContext) -> [MovieItemModel] {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: SearchMovieListMOHandler.entityName)
        fetchRequest.predicate = NSPredicate(format: "keyword == %@", key)
        do {
            let moviesMO = try moc.fetch(fetchRequest)
            guard moviesMO.count > 0, let moviesData = moviesMO.first?.value(forKey: "movieListData") as? Data, let movies = try? JSONDecoder().decode([MovieItemModel].self, from: moviesData) else {
                return []
            }
            return movies
        } catch let error as NSError {
            print("Could not fetch SearchMovieMO for keyword: \(key). Error: \(error)")
        }
        return []
    }
    
    static func removeSearchMovies(_ key: String, moc: NSManagedObjectContext) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: SearchMovieListMOHandler.entityName)
        fetchRequest.predicate = NSPredicate(format: "keyword == %@", key)
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try moc.execute(batchDeleteRequest)
        } catch {
            print("Could not remove SearchMovieMO entity record for keyword: \(key). Error: \(error)")
        }
    }
    
    static func clearAllSearchMovies(moc: NSManagedObjectContext) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: SearchMovieListMOHandler.entityName)
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try moc.execute(batchDeleteRequest)
        } catch {
            print("Could not remove all SearchMovieMO entity records. Error: \(error)")
        }
    }
}
