//
//  UnifiedCalendarView.swift
//  Make a Habit
//
//  Created by Or Elkabetz on 01/11/2025.
//

import SwiftUI
import SwiftData

struct UnifiedCalendarView: View {
    @Query private var habits: [Habit]
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel = HabitViewModel()
    @State private var selectedMonth: Date = Date()
    @State private var selectedDate: Date? = nil
    
    private let logoGreen = Color(red: 0.298, green: 0.686, blue: 0.314) // #4CAF50
    private let calendar = Calendar.current
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Month header with navigation
                HStack {
                    Button(action: {
                        withAnimation {
                            selectedMonth = calendar.date(byAdding: .month, value: -1, to: selectedMonth) ?? selectedMonth
                        }
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.primary)
                    }
                    
                    Spacer()
                    
                    Text(monthYearString(selectedMonth))
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Spacer()
                    
                    Button(action: {
                        withAnimation {
                            selectedMonth = calendar.date(byAdding: .month, value: 1, to: selectedMonth) ?? selectedMonth
                        }
                    }) {
                        Image(systemName: "chevron.right")
                            .foregroundColor(.primary)
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 12)
                
                // Weekday headers
                HStack(spacing: 0) {
                    ForEach(calendar.shortWeekdaySymbols, id: \.self) { weekday in
                        Text(weekday)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity)
                    }
                }
                .padding(.horizontal)
                
                // Calendar grid
                ScrollView {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 8) {
                        ForEach(daysInMonth(selectedMonth), id: \.self) { date in
                            UnifiedDayView(
                                date: date,
                                habits: habits,
                                viewModel: viewModel,
                                isCurrentMonth: calendar.isDate(date, equalTo: selectedMonth, toGranularity: .month),
                                isToday: calendar.isDateInToday(date),
                                onTap: {
                                    selectedDate = date
                                }
                            )
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)
                }
                
                // Legend
                HStack(spacing: 20) {
                    LegendItem(color: logoGreen, text: "Completed")
                    LegendItem(color: logoGreen.opacity(0.5), text: "Active Streak")
                    LegendItem(color: .gray.opacity(0.3), text: "Today")
                }
                .font(.caption)
                .padding(.vertical, 12)
            }
            .navigationTitle("Calendar")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(item: Binding(
                get: { 
                    if let date = selectedDate {
                        return DateWrapper(date: date)
                    }
                    return nil
                },
                set: { selectedDate = $0?.date }
            )) { wrapper in
                DayDetailView(date: wrapper.date, habits: habits, viewModel: viewModel)
            }
            .onAppear {
                viewModel.setModelContext(modelContext)
            }
        }
    }
    
    private func daysInMonth(_ date: Date) -> [Date] {
        guard let firstDayOfMonth = calendar.dateInterval(of: .month, for: date)?.start else {
            return []
        }
        
        let firstWeekday = calendar.component(.weekday, from: firstDayOfMonth)
        let daysFromSunday = (firstWeekday - 1)
        
        var days: [Date] = []
        
        // Add padding days from previous month
        for i in 0..<daysFromSunday {
            if let date = calendar.date(byAdding: .day, value: -i - 1, to: firstDayOfMonth) {
                days.insert(date, at: 0)
            }
        }
        
        // Add all days of the current month
        var currentDate = firstDayOfMonth
        while calendar.isDate(currentDate, equalTo: date, toGranularity: .month) {
            days.append(currentDate)
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate) ?? currentDate
        }
        
        // Add padding days to fill the last week
        let remainingDays = (7 - (days.count % 7)) % 7
        for i in 0..<remainingDays {
            if let date = calendar.date(byAdding: .day, value: i + 1, to: days.last ?? firstDayOfMonth) {
                days.append(date)
            }
        }
        
        return days
    }
    
    private func monthYearString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: date)
    }
}

// Helper to make Date Identifiable for sheet
struct DateWrapper: Identifiable {
    let id: UUID = UUID()
    let date: Date
}

struct UnifiedDayView: View {
    let date: Date
    let habits: [Habit]
    let viewModel: HabitViewModel
    let isCurrentMonth: Bool
    let isToday: Bool
    let onTap: () -> Void
    
    private let logoGreen = Color(red: 0.298, green: 0.686, blue: 0.314) // #4CAF50
    private let calendar = Calendar.current
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 2) {
                // Day number
                Text("\(calendar.component(.day, from: date))")
                    .font(.caption)
                    .fontWeight(isToday ? .bold : .regular)
                    .foregroundColor(
                        isCurrentMonth ? .primary : .secondary
                    )
                
                // Completion indicators (dots)
                HStack(spacing: 2) {
                    ForEach(completedHabitsForDate.prefix(3), id: \.id) { _ in
                        Circle()
                            .fill(logoGreen)
                            .frame(width: 4, height: 4)
                    }
                    
                    if completedHabitsForDate.count > 3 {
                        Text("+\(completedHabitsForDate.count - 3)")
                            .font(.system(size: 8))
                            .foregroundColor(.secondary)
                    }
                }
                
                // Streak indicator
                if hasActiveStreak {
                    Circle()
                        .fill(logoGreen.opacity(0.5))
                        .frame(width: 6, height: 6)
                }
            }
            .frame(width: 44, height: 50)
            .background(
                Group {
                    if isToday {
                        Circle()
                            .strokeBorder(.gray.opacity(0.5), lineWidth: 1)
                    } else if hasCompletions {
                        Circle()
                            .fill(logoGreen.opacity(0.1))
                    }
                }
            )
        }
        .buttonStyle(.plain)
    }
    
    private var completedHabitsForDate: [Habit] {
        habits.filter { habit in
            habit.completions.contains { completion in
                completion.completed && calendar.isDate(completion.date, inSameDayAs: date)
            }
        }
    }
    
    private var hasCompletions: Bool {
        !completedHabitsForDate.isEmpty
    }
    
    private var hasActiveStreak: Bool {
        // Check if any habit has an active streak on this date
        for habit in habits {
            let streak = viewModel.getCurrentStreak(for: habit)
            if streak > 0 {
                // Check if this date is part of the streak
                let sortedCompletions = habit.completions
                    .filter { $0.completed }
                    .sorted { $0.date > $1.date }
                
                guard !sortedCompletions.isEmpty else { continue }
                
                var currentDate = calendar.startOfDay(for: Date())
                for completion in sortedCompletions {
                    if calendar.isDate(completion.date, inSameDayAs: currentDate) {
                        if calendar.isDate(completion.date, inSameDayAs: date) {
                            return true
                        }
                        currentDate = calendar.date(byAdding: .day, value: -1, to: currentDate) ?? currentDate
                    } else {
                        break
                    }
                }
            }
        }
        return false
    }
}


#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Habit.self, Completion.self, configurations: config)
    
    return UnifiedCalendarView()
        .modelContainer(container)
}

