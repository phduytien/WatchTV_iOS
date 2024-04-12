//
//  MovieDetailViewModelTests.swift
//  WatchTVTests
//
//  Created by Tien Pham on 12/4/24.
//

import XCTest
import CoreData
@testable import WatchTV

class MovieDetailViewModelTests: XCTestCase {
    var viewModel: MovieDetailViewModel!
    var moc: NSManagedObjectContext!
    var mockNetworkMonitor: MockNetworkPathMonitor!
    var networkManager: NetworkManager!
    var mockURLSession: MockURLSession!
    
    private let mockUrl = URL(string: "https://example.com")!
    
    override func setUp() {
        super.setUp()
        let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle.main])!
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        try! persistentStoreCoordinator.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: nil)
        
        moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        moc.persistentStoreCoordinator = persistentStoreCoordinator
        mockNetworkMonitor = MockNetworkPathMonitor()
        mockURLSession = MockURLSession()
        networkManager = NetworkManager(session: mockURLSession)
        viewModel = MovieDetailViewModel(1, managedObjectContext: moc, networkMonitor: mockNetworkMonitor, networkManager: networkManager)
    }
    
    func testFetchMovieDetailWithNetworkConnectedSuccess() {
        let mockViewController = MockMovieDetailViewController()
        viewModel.viewController = mockViewController
        mockURLSession.response = URLResponse(
            url: mockUrl,
            mimeType: "application/json",
            expectedContentLength: 1000,
            textEncodingName: nil
        )
        mockURLSession.data = JSONHelpers.data(fromJSONFile: "movie_detail_978592")
        // Given
        mockNetworkMonitor.pathUpdateHandler?(.satisfied)
        
        // When
        let expectation = XCTestExpectation(description: "ViewModel requests data successfully")
        viewModel.fetchMovieDetail()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
        
        // Then
        XCTAssertTrue(mockNetworkMonitor.startCalled)
        XCTAssertTrue(mockViewController.updateViewCalled)
        XCTAssertFalse(mockViewController.showMessageCalled)
    }
    
    func testFetchMovieDetailNetworkConnectedFailed() {
        let mockViewController = MockMovieDetailViewController()
        viewModel.viewController = mockViewController
        mockURLSession.response = URLResponse(
            url: mockUrl,
            mimeType: "application/json",
            expectedContentLength: 1000,
            textEncodingName: nil
        )
        mockURLSession.error = NSError(
            domain: "com.example",
            code: 100,
            userInfo: [NSLocalizedDescriptionKey: "Something went wrong"]
        )
        // Given
        mockNetworkMonitor.pathUpdateHandler?(.satisfied)
        
        // When
        let expectation = XCTestExpectation(description: "ViewModel requests data failure")
        viewModel.fetchMovieDetail()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
        
        // Then
        XCTAssertTrue(mockNetworkMonitor.startCalled)
        XCTAssertFalse(mockViewController.updateViewCalled)
        XCTAssertTrue(mockViewController.showMessageCalled)
    }
    
    override func tearDown() {
        viewModel = nil
        moc = nil
        mockNetworkMonitor = nil
        super.tearDown()
    }
}
