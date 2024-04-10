//
//  NetworkPathMonitorProtocol.swift
//  WatchTV
//
//  Created by Tien Pham on 10/4/24.
//

import Foundation

import Network

protocol NetworkPathMonitorProtocol {

    var pathUpdateHandler: ((_ newPath: NWPath.Status) -> Void)? { get set }
    func start(queue: DispatchQueue)
    func cancel()
}
