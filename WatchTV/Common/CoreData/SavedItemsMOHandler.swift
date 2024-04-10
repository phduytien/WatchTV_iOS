//
//  SavedItemsMOHandler.swift
//  WatchTV
//
//  Created by Tien Pham on 10/4/24.
//

import Foundation
import CoreData

class SavedItemsMOHandler {
    static func clearSavedItemsMO(moc: NSManagedObjectContext) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "SavedItemsMO")
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try moc.execute(batchDeleteRequest)
            NotificationCenter.default.post(name: Notification.Name("SavedItemsChanged"), object: nil)
        } catch {
            print("Could not delete SavedItemsMO entity records. \(error)")
        }
    }
    
    static func removeMovieDetailObjectFromSavedItems(_ movieDetail: MovieDetailModel, moc: NSManagedObjectContext) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "SavedItemsMO")
        fetchRequest.predicate = NSPredicate(format: "movieId == \(movieDetail.id)")
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try moc.execute(batchDeleteRequest)
            NotificationCenter.default.post(name: Notification.Name("SavedItemsChanged"), object: nil)
        } catch {
            print("Could not delete SavedItemsMO entity record for id: \(movieDetail.id) \(error)")
        }
    }
    
    static func addMovieInfoObjectToSavedItems(_ movieDetail: MovieDetailModel, moc: NSManagedObjectContext) {
        if checkMovieInfoExistsInSavedItems(movieDetail, moc: moc) { return }
        if let entity = NSEntityDescription.entity(forEntityName: "SavedItemsMO", in: moc) {
            let savedItemsMO = NSManagedObject(entity: entity, insertInto: moc)
            let movieDetailData = try? JSONEncoder().encode(movieDetail)
            savedItemsMO.setValue(movieDetailData, forKeyPath: "movieDetailData")
            savedItemsMO.setValue(Date(), forKey: "timeStamp")
            savedItemsMO.setValue(movieDetail.id, forKey: "movieId")
            
            do {
                try moc.save()
                NotificationCenter.default.post(name: Notification.Name("SavedItemsChanged"), object: nil)
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
    }
    
static func checkMovieInfoExistsInSavedItems(_ movieDetail: MovieDetailModel, moc: NSManagedObjectContext) -> Bool {
        let savedItems = fetchListMovieDetailSaved(moc: moc)
        for item in savedItems {
            if item.id == movieDetail.id {
                return true
            }
        }
        return false
    }
    
    static func fetchListMovieDetailSaved(moc: NSManagedObjectContext) -> [MovieDetailModel] {
        var fetchedMovieDetailList: [MovieDetailModel] = []
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "SavedItemsMO")
        do {
            let saveItemsMOResult = try moc.fetch(fetchRequest)
            for loadedSavedItemObject in saveItemsMOResult {
                if let loadedMovieDetailData = loadedSavedItemObject.value(forKey: "movieDetailData") as? Data,
                   let loadedMovieDetail = try? JSONDecoder().decode(MovieDetailModel.self, from: loadedMovieDetailData) {
                    fetchedMovieDetailList.append(loadedMovieDetail)
                }
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return fetchedMovieDetailList
    }
}
