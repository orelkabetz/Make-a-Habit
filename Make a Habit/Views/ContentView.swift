//
//  ContentView.swift
//  Make a Habit
//
//  Created by Or Elkabetz on 01/11/2025.
//

import SwiftUI

struct ContentView: View {
    @State private var showOnboarding = true
    
    var body: some View {
        Group {
            if showOnboarding {
                // Show onboarding every time app opens
                OnboardingView(showOnboarding: $showOnboarding)
            } else {
                NavigationStack {
                    HabitListView()
                }
            }
        }
        .onAppear {
            // Show onboarding every time app opens
            showOnboarding = true
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [Habit.self, Completion.self], inMemory: true)
}

