//
//  NetworkManagerTests.swift
//  WatchTVTests
//
//  Created by Tien Pham on 12/4/24.
//

@testable import WatchTV
import XCTest

class NetworkManagerTests: XCTestCase {
    var networkManager: NetworkManager!
    var mockURLSession: MockURLSession!
    private let mockUrl = URL(string: "https://example.com")!
    
    override func setUpWithError() throws {
        mockURLSession = MockURLSession()
        networkManager = NetworkManager(session: mockURLSession)
    }
    
    // MARK: - Today Trending
    
    func testFetchingTodayTrendingSuccess() throws {
        mockURLSession.response = URLResponse(
            url: mockUrl,
            mimeType: "application/json",
            expectedContentLength: 1000,
            textEncodingName: nil
        )
        mockURLSession.data = JSONHelpers.data(fromJSONFile: "today_trending_data")
        
        var responseData: TodayTrendingResponseModel?
        var responseError: String?
        
        let expectation = XCTestExpectation(description: "Fetching Today Trending Success")
        networkManager.fetchTodayTrending(page: 1) { response in
            responseData = response
            expectation.fulfill()
        } failure: { error in
            responseError = error
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
        
        XCTAssertNotNil(responseData)
        XCTAssertEqual(responseData?.page, 1, "Page is incorrect")
        XCTAssertEqual(responseData?.totalPages, 1000, "Total pages is incorrect")
        XCTAssertEqual(responseData?.totalResults, 20000, "Total results is incorrect")
        XCTAssertNotNil(responseData?.results.first)
        XCTAssertEqual(responseData?.results.first?.title, "Kung Fu Panda 4", "Response is incorrect")
        XCTAssertNil(responseError)
    }
    
    func testFetchingTodayTrendingFailed() throws {
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
        
        var responseData: TodayTrendingResponseModel?
        var responseError: String?
        
        let expectation = XCTestExpectation(description: "Fetching Today Trending Failed")
        networkManager.fetchTodayTrending(page: 1) { response in
            responseData = response
            expectation.fulfill()
        } failure: { error in
            responseError = error
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
        
        XCTAssertNil(responseData)
        XCTAssertEqual(responseError, "Something went wrong", "Error message is incorrect")
    }
    
    // MARK: - Movie Detail
    
    func testFetchingMovieDetailSuccess() throws {
        mockURLSession.response = URLResponse(
            url: mockUrl,
            mimeType: "application/json",
            expectedContentLength: 1000,
            textEncodingName: nil
        )
        mockURLSession.data = JSONHelpers.data(fromJSONFile: "movie_detail_978592")
        
        var responseData: MovieDetailModel?
        var responseError: String?
        
        let expectation = XCTestExpectation(description: "Fetching Movie Detail Success")
        networkManager.fetchMovieDetail(id: 978592, success: { response in
            responseData = response
            expectation.fulfill()
        }, failure: { error in
            responseError = error
            expectation.fulfill()
        })
        
        wait(for: [expectation], timeout: 5.0)
        
        XCTAssertNotNil(responseData)
        XCTAssertEqual(responseData?.title, "Sleeping Dogs", "Movie detail is incorrect")
        XCTAssertNil(responseError)
    }
    
    func testFetchingMovieDetailFailed() throws {
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
        
        var responseData: MovieDetailModel?
        var responseError: String?
        
        let expectation = XCTestExpectation(description: "Fetching Movie Detail Failed")
        networkManager.fetchMovieDetail(id: 978592, success: { response in
            responseData = response
            expectation.fulfill()
        }, failure: { error in
            responseError = error
            expectation.fulfill()
        })
        
        wait(for: [expectation], timeout: 5.0)
        
        XCTAssertNil(responseData)
        XCTAssertEqual(responseError, "Something went wrong", "Error message is incorrect")
    }
    
    // MARK: - Search Movies
    
    func testFetchingSearchMoviesSuccess() throws {
        mockURLSession.response = URLResponse(
            url: mockUrl,
            mimeType: "application/json",
            expectedContentLength: 1000,
            textEncodingName: nil
        )
        mockURLSession.data = JSONHelpers.data(fromJSONFile: "search_movies_data")
        
        var responseData: SearchMoviesResponseModel?
        var responseError: String?
        
        let expectation = XCTestExpectation(description: "Fetching Search Movies Success")
        networkManager.searchMovies(keyword: "long", page: 1, success: { response in
            responseData = response
            expectation.fulfill()
        }, failure: { error in
            responseError = error
            expectation.fulfill()
        })
        
        wait(for: [expectation], timeout: 5.0)
        
        XCTAssertNotNil(responseData)
        XCTAssertEqual(responseData?.page, 1, "Page is incorrect")
        XCTAssertEqual(responseData?.totalPages, 123, "Total pages is incorrect")
        XCTAssertEqual(responseData?.totalResults, 2454, "Total results is incorrect")
        XCTAssertNotNil(responseData?.results.first)
        XCTAssertEqual(responseData?.results.first?.title, "A Very Long Engagement", "Response is incorrect")
        XCTAssertNil(responseError)
    }
    
    func testFetchingSearchMoviesFailed() throws {
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
        
        var responseData: SearchMoviesResponseModel?
        var responseError: String?
        
        let expectation = XCTestExpectation(description: "Fetching Search Movies Failed")
        networkManager.searchMovies(keyword: "long", page: 1, success: { response in
            responseData = response
            expectation.fulfill()
        }, failure: { error in
            responseError = error
            expectation.fulfill()
        })
        
        wait(for: [expectation], timeout: 5.0)
        
        XCTAssertNil(responseData)
        XCTAssertEqual(responseError, "Something went wrong", "Error message is incorrect")
    }
    
    override func tearDown() {
        super.tearDown()
        networkManager = nil
        mockURLSession = nil
    }
}

