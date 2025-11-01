//
//  HabitDetailView.swift
//  Make a Habit
//
//  Created by Or Elkabetz on 01/11/2025.
//

import SwiftUI
import SwiftData

struct HabitDetailView: View {
    @Bindable var habit: Habit
    @Environment(\.dismiss) var dismiss
    let viewModel: HabitViewModel
    
    private let logoGreen = Color(red: 0.298, green: 0.686, blue: 0.314) // #4CAF50
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Habit header
                    VStack(spacing: 12) {
                        Text(habit.name)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        HStack(spacing: 16) {
                            // Current streak
                            VStack {
                                Text("\(viewModel.getCurrentStreak(for: habit))")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(logoGreen)
                                Text("Day Streak")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            Divider()
                                .frame(height: 40)
                            
                            // Started date
                            VStack {
                                Text(startedDateString)
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                Text("Started")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(12)
                    }
                    .padding(.top)
                    
                    // Milestones section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Milestones")
                            .font(.headline)
                        
                        MilestoneRow(
                            title: "3 Days",
                            reached: habit.milestones.first.reached,
                            date: habit.milestones.first.date
                        )
                        MilestoneRow(
                            title: "3 Weeks",
                            reached: habit.milestones.second.reached,
                            date: habit.milestones.second.date
                        )
                        MilestoneRow(
                            title: "3 Months",
                            reached: habit.milestones.third.reached,
                            date: habit.milestones.third.date
                        )
                    }
                    .padding(.horizontal)
                    
                    Spacer(minLength: 20)
                }
            }
            .navigationTitle("Habit Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private var startedDateString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: habit.createdAt)
    }
}

struct MilestoneRow: View {
    let title: String
    let reached: Bool
    let date: Date?
    
    private let logoGreen = Color(red: 0.298, green: 0.686, blue: 0.314) // #4CAF50
    
    var body: some View {
        HStack {
            Image(systemName: reached ? "checkmark.circle.fill" : "circle")
                .foregroundColor(reached ? logoGreen : .gray)
                .font(.title3)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.body)
                    .fontWeight(.medium)
                
                if let date = date, reached {
                    Text(dateString(date))
                        .font(.caption)
                        .foregroundColor(.secondary)
                } else {
                    Text("Not reached yet")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
        }
        .padding()
        .background(Color.gray.opacity(0.05))
        .cornerRadius(12)
    }
    
    private func dateString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return "Reached on \(formatter.string(from: date))"
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Habit.self, Completion.self, configurations: config)
    let habit = Habit(name: "Exercise", period: .daily, reminderEnabled: false)
    
    // Add some sample completions
    let calendar = Calendar.current
    for i in 0..<15 {
        if let date = calendar.date(byAdding: .day, value: -i, to: Date()) {
            let completion = Completion(date: date, completed: true)
            habit.completions.append(completion)
        }
    }
    
    return HabitDetailView(habit: habit, viewModel: HabitViewModel())
        .modelContainer(container)
}

