//
//  SwiftUI_App.swift
//  SwiftUI-Example
//
//  Created by Vidhyadharan on 23/02/21.
//

import SwiftUI

@main
struct SwiftUI_App: App {
    let persistenceController = PersistenceManager.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
