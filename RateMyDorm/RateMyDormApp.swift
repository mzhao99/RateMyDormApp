//
//  RateMyDormApp.swift
//  RateMyDorm
//
//  Created by Manling Zhao on 12/2/23.
//

import SwiftUI
import Firebase

@main
struct RateMyDormApp: App {
    let persistenceController = PersistenceController.shared
    @StateObject private var userViewModel = UserViewModel()

    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(userViewModel)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
