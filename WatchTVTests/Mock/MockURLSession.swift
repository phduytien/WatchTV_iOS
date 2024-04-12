//
//  MockURLSession.swift
//  WatchTVTests
//
//  Created by Tien Pham on 12/4/24.
//

import Foundation

class MockURLSession: URLSession {
    var data: Data?
    var response: URLResponse?
    var error: Error?
    
    override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        let task = MockURLSessionDataTask()
        task.completionHandler = { completionHandler(self.data, self.response, self.error) }
        return task
    }
}
