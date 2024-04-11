//
//  MovieListViewControllerProtocol.swift
//  WatchTV
//
//  Created by Tien Pham on 10/4/24.
//

import Foundation

protocol MovieListViewControllerProtocol: AnyObject {
    func updateView()
    func showMessage(_ message: String, type: MessageType)
}
