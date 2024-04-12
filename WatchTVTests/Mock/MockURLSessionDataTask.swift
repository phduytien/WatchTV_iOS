//
//  MockURLSessionDataTask.swift
//  WatchTVTests
//
//  Created by Tien Pham on 12/4/24.
//

import Foundation

class MockURLSessionDataTask: URLSessionDataTask {
    var completionHandler: (() -> Void)?
    
    override func resume() {
        completionHandler?()
    }
}
