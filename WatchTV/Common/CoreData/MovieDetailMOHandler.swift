//
//  SavedItemsMOHandler.swift
//  WatchTV
//
//  Created by Tien Pham on 10/4/24.
//

import Foundation
import CoreData

class MovieDetailMOHandler {
    
    private static let entityName = "MovieDetailMO";
    
    static func addMovieDetail(_ movieDetail: MovieDetailModel, moc: NSManagedObjectContext) {
        if checkMovieDetailIsExist(movieDetail.id, moc: moc) { return }
        if let entity = NSEntityDescription.entity(forEntityName: MovieDetailMOHandler.entityName, in: moc) {
            let savedItemsMO = NSManagedObject(entity: entity, insertInto: moc)
            let movieDetailData = try? JSONEncoder().encode(movieDetail)
            savedItemsMO.setValue(movieDetailData, forKeyPath: "movieDetailData")
            savedItemsMO.setValue(Date(), forKey: "timestamp")
            savedItemsMO.setValue(movieDetail.id, forKey: "movieId")
            
            do {
                try moc.save()
            } catch let error as NSError {
                print("Could not save MovieDetailMO entity record. Error: \(error)")
            }
        }
    }
    
    static func checkMovieDetailIsExist(_ id: Int, moc: NSManagedObjectContext) -> Bool {
        return fetchMovieDetail(id, moc: moc) != nil
    }
    
    static func fetchMovieDetail(_ id: Int, moc: NSManagedObjectContext) -> MovieDetailModel? {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: MovieDetailMOHandler.entityName)
        fetchRequest.predicate = NSPredicate(format: "movieId == \(id)")
        do {
            let movieMO = try moc.fetch(fetchRequest)
            guard movieMO.count > 0, let movieData = movieMO[0].value(forKey: "movieDetailData") as? Data, let movie = try? JSONDecoder().decode(MovieDetailModel.self, from: movieData) else {
                return nil
            }
            return movie
        } catch let error as NSError {
            print("Could not fetch MovieDetailMO for id: \(id) entity record. Error: \(error)")
        }
        return nil
    }
    
    static func clearAllMovieDetails(moc: NSManagedObjectContext) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: MovieDetailMOHandler.entityName)
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try moc.execute(batchDeleteRequest)
        } catch {
            print("Could not remove all MovieDetailMO entity records. Error: \(error)")
        }
    }
    
    static func removeMovieDetail(_ id: Int, moc: NSManagedObjectContext) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: MovieDetailMOHandler.entityName)
        fetchRequest.predicate = NSPredicate(format: "movieId == \(id)")
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try moc.execute(batchDeleteRequest)
        } catch {
            print("Could not remove MovieDetailMO entity record for id: \(id). Error: \(error)")
        }
    }
}
