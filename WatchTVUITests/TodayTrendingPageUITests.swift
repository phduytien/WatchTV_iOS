//
//  TodayTrendingPageUITests.swift
//  WatchTVUITests
//
//  Created by Tien Pham on 11/4/24.
//

import Foundation
import XCTest

final class TodayTrendingPageUITests: XCTestCase {
    let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }
    
    func testTodayTrendingShouldDisplayRightTitle() {
        // Check the title is correct
        XCTAssert(app.navigationBars["Trending Today"].exists, "Title does not exist")
    }
    
    func testTodayTrendingShouldDisplayRightSearchBar() {
        let navigationBar = app.navigationBars.element
        XCTAssertTrue(navigationBar.exists, "NavigationBar does not exist")
        let searchField = navigationBar.searchFields.element
        XCTAssertTrue(searchField.exists, "SearchField does not exist")
        // Check the search hint "Search movie" is correct
        XCTAssertEqual(searchField.placeholderValue, "Search movie", "Hint text is incorrect")
    }
    
    func testTodayTrendingCheckSearchBarInputTextCorrect() {
        let searchField = app.navigationBars.element.searchFields.element
        searchField.tap()
        searchField.typeText("Panda")
        // Check the search bar displays "Panda" is correct
        XCTAssertEqual(searchField.value as? String, "Panda", "Input text is incorrect")
    }
    
    func testTodayTrendingNavigateToMovieDetail() {
        let tableView = app.tables.element
        XCTAssertTrue(tableView.exists, "UITableView does not exist")
        let firstCell = tableView.cells.firstMatch
        XCTAssertTrue(firstCell.exists, "First cell does not exist")
        firstCell.tap()
        XCTAssertTrue(app.navigationBars["Kung Fu Panda 4"].waitForExistence(timeout: 5), "Failed to navigate to movie screen")
    }
    
    override func tearDownWithError() throws {
        
    }
}
