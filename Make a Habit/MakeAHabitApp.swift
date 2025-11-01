//
//  MakeAHabitApp.swift
//  Make a Habit
//
//  Created by Or Elkabetz on 01/11/2025.
//

import SwiftUI
import SwiftData

@main
struct MakeAHabitApp: App {
    @AppStorage("appearanceMode") private var appearanceMode: String = "system"
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Habit.self,
            Completion.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            print("❌ Failed to create ModelContainer: \(error)")
            print("Error details: \(error.localizedDescription)")
            // Try with in-memory storage as fallback
            do {
                let fallbackConfig = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
                return try ModelContainer(for: schema, configurations: [fallbackConfig])
            } catch {
                fatalError("Could not create ModelContainer even with in-memory storage: \(error)")
            }
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(appearanceMode == "light" ? .light : appearanceMode == "dark" ? .dark : nil)
        }
        .modelContainer(sharedModelContainer)
    }
}

