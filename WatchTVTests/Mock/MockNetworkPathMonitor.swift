//
//  MockNetworkPathMonitor.swift
//  WatchTVTests
//
//  Created by Tien Pham on 10/4/24.
//

@testable import WatchTV
import Network

final class MockNetworkPathMonitor: NetworkPathMonitorProtocol {

    var pathUpdateHandler: ((NWPath.Status) -> Void)?
    var currentNetworkStatus : NWPath.Status

    var isStartCalled = false
    var isCancelCalled = false

    init(currentNetworkStatus : NWPath.Status = .unsatisfied) {
        self.currentNetworkStatus = currentNetworkStatus
    }

    func start(queue: DispatchQueue) {
        isStartCalled = true
        pathUpdateHandler?(currentNetworkStatus)
    }

    func cancel() {
        isCancelCalled = true
    }
}
