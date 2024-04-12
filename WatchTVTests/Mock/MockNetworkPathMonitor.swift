//
//  MockNetworkPathMonitor.swift
//  WatchTVTests
//
//  Created by Tien Pham on 10/4/24.
//

@testable import WatchTV
import Network

final class MockNetworkPathMonitor: NetworkPathMonitorProtocol {
    
    var startCalled = false
    var cancelCalled = false
    var pathUpdateHandler: ((NWPath.Status) -> Void)?
    
    func start(queue: DispatchQueue) {
        startCalled = true
    }
    
    func cancel() {
        cancelCalled = true
    }
}
