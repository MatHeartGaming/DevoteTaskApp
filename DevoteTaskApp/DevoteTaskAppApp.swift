//
//  DevoteTaskAppApp.swift
//  DevoteTaskApp
//
//  Created by Matteo Buompastore on 28/07/23.
//

import SwiftUI

@main
struct DevoteTaskAppApp: App {
    
    //MARK: - PROPERTIES
    @AppStorage("isDarkMode") private var isDarkMode : Bool = false
    let persistenceController = PersistenceController.shared

    //MARK: - BODY
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .preferredColorScheme(isDarkMode ? .dark : .light)
        }
    }
}
