//
//  MovieDetailMOHandlerTests.swift
//  WatchTVTests
//
//  Created by Tien Pham on 12/4/24.
//

import XCTest
import CoreData
@testable import WatchTV // Import your app module

class MovieDetailMOHandlerTests: XCTestCase {
    
    var moc: NSManagedObjectContext!
    
    override func setUp() {
        super.setUp()
        // Initialize a mock persistent container to create a managed object context
        let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle.main])!
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        try! persistentStoreCoordinator.addPersistentStore(
            ofType: NSInMemoryStoreType,
            configurationName: nil,
            at: nil,
            options: nil
        )
        
        // Create managed object context from the persistent store coordinator
        moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        moc.persistentStoreCoordinator = persistentStoreCoordinator
    }
    
    override func tearDown() {
        // Clear mock managed object context after each test
        moc = nil
        super.tearDown()
    }
    
    func testAddMovieDetail() {
        // Given
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        do {
            let movieDetail = try decoder.decode(MovieDetailModel.self, from: JSONHelpers.data(fromJSONFile: "movie_detail_978592")!)
            
            // When
            MovieDetailMOHandler.addMovieDetail(movieDetail, moc: moc)
            
            // Then
            XCTAssertTrue(MovieDetailMOHandler.checkMovieDetailIsExist(movieDetail.id, moc: moc))
        } catch {
            print("JSON parse data failed")
        }
    }
    
    func testGetMovieDetail() {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        do {
            // Given
            let movieDetail = try decoder.decode(MovieDetailModel.self, from: JSONHelpers.data(fromJSONFile: "movie_detail_978592")!)
            if (!MovieDetailMOHandler.checkMovieDetailIsExist(movieDetail.id, moc: moc)) {
                MovieDetailMOHandler.addMovieDetail(movieDetail, moc: moc)
            }
            
            // When
            let response = MovieDetailMOHandler.fetchMovieDetail(movieDetail.id, moc: moc)
            
            // Then
            XCTAssertNotNil(response)
            XCTAssertEqual(response?.title, "Sleeping Dogs", "Movie detail is incorrect")
        } catch {
            print("JSON parse data failed")
        }
    }
}
