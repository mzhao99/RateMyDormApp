//
//  RateMyDormApp.swift
//  RateMyDorm
//
//  Created by Manling Zhao on 12/2/23.
//

import SwiftUI

@main
struct RateMyDormApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
