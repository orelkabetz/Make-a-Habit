//
//  ContentView.swift
//  Make a Habit
//
//  Created by Or Elkabetz on 01/11/2025.
//

import SwiftUI

struct ContentView: View {
    @State private var showWelcomeBack = true
    
    var body: some View {
        Group {
            if showWelcomeBack {
                WelcomeBackView(showWelcomeBack: $showWelcomeBack)
            } else {
                NavigationStack {
                    HabitListView()
                }
            }
        }
        .onAppear {
            // Show welcome back every time app opens
            showWelcomeBack = true
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [Habit.self, Completion.self], inMemory: true)
}

