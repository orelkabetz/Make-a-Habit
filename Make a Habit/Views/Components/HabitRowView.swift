//
//  HabitRowView.swift
//  Make a Habit
//
//  Created by Or Elkabetz on 01/11/2025.
//

import SwiftUI
import SwiftData

struct HabitRowView: View {
    @Bindable var habit: Habit
    let viewModel: HabitViewModel
    @State private var showCelebration = false
    @State private var celebrationMessage = ""
    @State private var showDetailView = false
    
    private let logoGreen = Color(red: 0.298, green: 0.686, blue: 0.314) // #4CAF50
    private let lightGreen = Color.gray.opacity(0.1) // Grayish background before completion
    private let darkerGreen = Color(red: 0.298, green: 0.686, blue: 0.314, opacity: 0.4) // More gradient when completed
    
    var body: some View {
        HStack(spacing: 0) {
            // Main card (tap to complete)
            Button(action: {
                viewModel.markHabitComplete(habit)
                checkForCelebration()
            }) {
                HStack(spacing: 16) {
                    // Habit name
                    Text(habit.name)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    // Green circle with streak number
                    ZStack {
                        Circle()
                            .fill(logoGreen)
                            .frame(width: 50, height: 50)
                        
                        Text("\(viewModel.getCurrentStreak(for: habit))")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                }
                .padding()
                .background(isCompletedToday ? darkerGreen : lightGreen)
                .cornerRadius(12)
            }
            .buttonStyle(.plain)
            
            // Info button to show calendar
            Button(action: {
                showDetailView = true
            }) {
                Image(systemName: "info.circle")
                    .font(.title3)
                    .foregroundColor(.secondary)
                    .padding(.leading, 12)
            }
            .buttonStyle(.plain)
        }
        .sheet(isPresented: $showDetailView) {
            HabitDetailView(habit: habit, viewModel: viewModel)
        }
        .alert("🎉 Congratulations!", isPresented: $showCelebration) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(celebrationMessage)
        }
    }
    
    private var isCompletedToday: Bool {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        return habit.completions.contains { completion in
            completion.completed && calendar.isDate(completion.date, inSameDayAs: today)
        }
    }
    
    private func checkForCelebration() {
        if habit.milestones.first.reached && habit.milestones.first.date != nil {
            let calendar = Calendar.current
            if let date = habit.milestones.first.date, calendar.isDateInToday(date) {
                let milestoneText: String
                switch habit.period {
                case .daily:
                    milestoneText = "3 days"
                case .weekly:
                    milestoneText = "3 weeks"
                case .monthly:
                    milestoneText = "3 months"
                }
                celebrationMessage = "You've completed \(milestoneText) of \(habit.name)! Keep it up! 🎉"
                showCelebration = true
            }
        } else if habit.milestones.second.reached && habit.milestones.second.date != nil {
            let calendar = Calendar.current
            if let date = habit.milestones.second.date, calendar.isDateInToday(date) {
                let milestoneText: String
                switch habit.period {
                case .daily:
                    milestoneText = "3 weeks"
                case .weekly:
                    milestoneText = "3 months"
                case .monthly:
                    milestoneText = "3 quarters"
                }
                celebrationMessage = "You've completed \(milestoneText) of \(habit.name)! Amazing progress! 🎉"
                showCelebration = true
            }
        } else if habit.milestones.third.reached && habit.milestones.third.date != nil {
            let calendar = Calendar.current
            if let date = habit.milestones.third.date, calendar.isDateInToday(date) {
                let milestoneText: String
                switch habit.period {
                case .daily:
                    milestoneText = "3 months"
                case .weekly:
                    milestoneText = "3 quarters"
                case .monthly:
                    milestoneText = "3 years"
                }
                celebrationMessage = "You've completed \(milestoneText) of \(habit.name)! Incredible achievement! 🎉"
                showCelebration = true
            }
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Habit.self, Completion.self, configurations: config)
    let habit = Habit(name: "Exercise", period: .daily, reminderEnabled: false)
    
    return HabitRowView(habit: habit, viewModel: HabitViewModel())
        .modelContainer(container)
        .padding()
}
