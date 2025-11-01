//
//  DayDetailView.swift
//  Make a Habit
//
//  Created by Or Elkabetz on 01/11/2025.
//

import SwiftUI
import SwiftData

struct DayDetailView: View {
    let date: Date
    let habits: [Habit]
    let viewModel: HabitViewModel
    @Environment(\.dismiss) var dismiss
    
    private let logoGreen = Color(red: 0.298, green: 0.686, blue: 0.314) // #4CAF50
    private let calendar = Calendar.current
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Date header
                    VStack(spacing: 8) {
                        Text(dateString(date))
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        Text(weekdayString(date))
                            .font(.title3)
                            .foregroundColor(.secondary)
                    }
                    .padding(.top)
                    
                    // Completed habits section
                    if !completedHabits.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Completed Habits")
                                .font(.headline)
                                .padding(.horizontal)
                            
                            ForEach(completedHabits) { habit in
                                CompletedHabitRow(habit: habit, date: date, viewModel: viewModel)
                            }
                        }
                    } else {
                        VStack(spacing: 12) {
                            Image(systemName: "calendar.badge.exclamationmark")
                                .font(.system(size: 50))
                                .foregroundColor(.secondary)
                            Text("No habits completed on this day")
                                .font(.body)
                                .foregroundColor(.secondary)
                        }
                        .padding(.vertical, 40)
                    }
                    
                    Spacer(minLength: 20)
                }
                .padding()
            }
            .navigationTitle("Day Details")
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
    
    private var completedHabits: [Habit] {
        habits.filter { habit in
            habit.completions.contains { completion in
                completion.completed && calendar.isDate(completion.date, inSameDayAs: date)
            }
        }
    }
    
    private func dateString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter.string(from: date)
    }
    
    private func weekdayString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter.string(from: date)
    }
}

struct CompletedHabitRow: View {
    let habit: Habit
    let date: Date
    let viewModel: HabitViewModel
    
    private let logoGreen = Color(red: 0.298, green: 0.686, blue: 0.314) // #4CAF50
    
    var body: some View {
        HStack(spacing: 16) {
            // Habit icon/circle
            ZStack {
                Circle()
                    .fill(logoGreen)
                    .frame(width: 50, height: 50)
                
                Image(systemName: "checkmark")
                    .foregroundColor(.white)
                    .fontWeight(.bold)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(habit.name)
                    .font(.headline)
                
                HStack(spacing: 8) {
                    // Streak indicator
                    if viewModel.getCurrentStreak(for: habit) > 0 {
                        HStack(spacing: 4) {
                            Image(systemName: "flame.fill")
                                .foregroundColor(.orange)
                                .font(.caption)
                            Text("\(viewModel.getCurrentStreak(for: habit)) day streak")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            
            Spacer()
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
        .padding(.horizontal)
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Habit.self, Completion.self, configurations: config)
    let habit = Habit(name: "Exercise", period: .daily, reminderEnabled: false)
    let habit2 = Habit(name: "Read", period: .daily, reminderEnabled: false)
    
    // Add completion for today
    let completion = Completion(date: Date(), completed: true)
    habit.completions.append(completion)
    habit2.completions.append(completion)
    
    return DayDetailView(date: Date(), habits: [habit, habit2], viewModel: HabitViewModel())
        .modelContainer(container)
}

