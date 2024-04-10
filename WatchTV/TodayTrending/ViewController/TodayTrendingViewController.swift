//
//  TodayTrendingViewController.swift
//  WatchTV
//
//  Created by Tien Pham on 10/4/24.
//

import Foundation
import CoreData
import SwiftUI

class TodayTrendingViewController: MovieListViewController {
    
    override init(_ managedObjectContext: NSManagedObjectContext) {
        super.init(managedObjectContext)
        viewModel = TodayTrendingViewModel(managedObjectContext)
        viewModel.viewController = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
