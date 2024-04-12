//
//  MockMovieDetailViewController.swift
//  WatchTVTests
//
//  Created by Tien Pham on 12/4/24.
//

import XCTest
@testable import WatchTV

class MockMovieDetailViewController: MovieDetailViewControllerProtocol {
    var updateViewCalled = false
    var showMessageCalled = false
    
    func updateView() {
        updateViewCalled = true
    }
    
    func showMessage(_ message: String, type: MessageType) {
        showMessageCalled = true
    }
}
