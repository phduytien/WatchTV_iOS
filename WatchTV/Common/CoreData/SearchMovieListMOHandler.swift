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
    
    
    static func saveCurrentSearchMovies(_ keyword: String, movies: [MovieItemModel], moc: NSManagedObjectContext) {
        if SearchMovieListMOHandler.checkKeywordIsExist(keyword, moc: moc) {
            SearchMovieListMOHandler.removeSearchMovies(keyword, moc: moc)
        }
        if let entity = NSEntityDescription.entity(forEntityName: SearchMovieListMOHandler.entityName, in: moc) {
            let moviesMO = NSManagedObject(entity: entity, insertInto: moc)
            let moviesData = try? JSONEncoder().encode(movies)
            moviesMO.setValue(keyword, forKeyPath: "keyword")
            moviesMO.setValue(moviesData, forKeyPath: "movieListData")
            moviesMO.setValue(Date(), forKey: "timestamp")
            do {
                try moc.save()
            } catch let error as NSError {
                print("Could not save SearchMovieMO for keyword: \(keyword). Error: \(error)")
            }
        }
    }
    
    static func checkKeywordIsExist(_ keyword: String, moc: NSManagedObjectContext) -> Bool {
        return !fetchSearchMovies(keyword, moc: moc).isEmpty
    }
    
    static func fetchSearchMovies(_ keyword: String, moc: NSManagedObjectContext) -> [MovieItemModel] {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: SearchMovieListMOHandler.entityName)
        fetchRequest.predicate = NSPredicate(format: "keyword == \(keyword)")
        do {
            let moviesMO = try moc.fetch(fetchRequest)
            guard moviesMO.count > 0, let moviesData = moviesMO[0].value(forKey: "movieListData") as? Data, let movies = try? JSONDecoder().decode([MovieItemModel].self, from: moviesData) else {
                return []
            }
            return movies
        } catch let error as NSError {
            print("Could not fetch SearchMovieMO for keyword: \(keyword). Error: \(error)")
        }
        return []
    }
    
    static func removeSearchMovies(_ keyword: String, moc: NSManagedObjectContext) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: SearchMovieListMOHandler.entityName)
        fetchRequest.predicate = NSPredicate(format: "keyword == \(keyword)")
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try moc.execute(batchDeleteRequest)
        } catch {
            print("Could not remove SearchMovieMO entity record for keyword: \(keyword). Error: \(error)")
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
