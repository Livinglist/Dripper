//
//  DaysApp.swift
//  Days
//
//  Created by Jiaqi Feng on 12/17/20.
//

import SwiftUI

@main
struct DaysApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
