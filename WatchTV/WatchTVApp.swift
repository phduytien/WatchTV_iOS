//
//  WatchTVApp.swift
//  WatchTV
//
//  Created by Tien Pham on 10/4/24.
//

import SwiftUI

@main
struct WatchTVApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
