//
//  HabitCalendarView.swift
//  Make a Habit
//
//  Created by Or Elkabetz on 01/11/2025.
//

import SwiftUI
import SwiftData

struct HabitCalendarView: View {
    @Bindable var habit: Habit
    @State private var selectedMonth: Date = Date()
    
    private let logoGreen = Color(red: 0.298, green: 0.686, blue: 0.314) // #4CAF50
    private let calendar = Calendar.current
    
    var body: some View {
        VStack(spacing: 16) {
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
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 8) {
                ForEach(daysInMonth(selectedMonth), id: \.self) { date in
                    DayView(
                        date: date,
                        isStartDate: calendar.isDate(date, inSameDayAs: habit.createdAt),
                        isCompletionDate: isCompletionDate(date),
                        isCurrentMonth: calendar.isDate(date, equalTo: selectedMonth, toGranularity: .month),
                        isToday: calendar.isDateInToday(date)
                    )
                }
            }
            .padding(.horizontal)
            
            // Legend
            HStack(spacing: 20) {
                LegendItem(color: logoGreen.opacity(0.3), text: "Start Date")
                LegendItem(color: logoGreen, text: "Completed")
                LegendItem(color: .gray.opacity(0.3), text: "Today")
            }
            .font(.caption)
            .padding(.top, 8)
        }
        .padding(.vertical)
    }
    
    private func daysInMonth(_ date: Date) -> [Date] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: date),
              let firstDayOfMonth = calendar.dateInterval(of: .month, for: date)?.start else {
            return []
        }
        
        // Find the first day of the week for this month (adjust for week starting on Sunday)
        let firstWeekday = calendar.component(.weekday, from: firstDayOfMonth)
        let daysFromSunday = (firstWeekday - 1) // Convert 1-7 (Sunday-Saturday) to 0-6
        
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
        
        // Add padding days to fill the last week (to make a 7-day grid)
        let remainingDays = (7 - (days.count % 7)) % 7
        for i in 0..<remainingDays {
            if let date = calendar.date(byAdding: .day, value: i + 1, to: days.last ?? firstDayOfMonth) {
                days.append(date)
            }
        }
        
        return days
    }
    
    private func isCompletionDate(_ date: Date) -> Bool {
        return habit.completions.contains { completion in
            completion.completed && calendar.isDate(completion.date, inSameDayAs: date)
        }
    }
    
    private func monthYearString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: date)
    }
}

struct DayView: View {
    let date: Date
    let isStartDate: Bool
    let isCompletionDate: Bool
    let isCurrentMonth: Bool
    let isToday: Bool
    
    private let logoGreen = Color(red: 0.298, green: 0.686, blue: 0.314) // #4CAF50
    private let calendar = Calendar.current
    
    var body: some View {
        ZStack {
            // Background circle
            if isStartDate {
                Circle()
                    .fill(logoGreen.opacity(0.3))
                    .frame(width: 32, height: 32)
            } else if isCompletionDate {
                Circle()
                    .fill(logoGreen)
                    .frame(width: 32, height: 32)
            } else if isToday {
                Circle()
                    .strokeBorder(.gray.opacity(0.5), lineWidth: 1)
                    .frame(width: 32, height: 32)
            }
            
            // Day number
            Text("\(calendar.component(.day, from: date))")
                .font(.caption)
                .fontWeight(isToday ? .bold : .regular)
                .foregroundColor(
                    isCurrentMonth ? 
                        (isStartDate || isCompletionDate ? .white : .primary) :
                        .secondary
                )
        }
        .frame(height: 40)
    }
}

struct LegendItem: View {
    let color: Color
    let text: String
    
    var body: some View {
        HStack(spacing: 6) {
            Circle()
                .fill(color)
                .frame(width: 12, height: 12)
            Text(text)
                .foregroundColor(.secondary)
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Habit.self, Completion.self, configurations: config)
    let habit = Habit(name: "Exercise", period: .daily, reminderEnabled: false)
    
    // Add some sample completions
    let calendar = Calendar.current
    for i in 0..<10 {
        if let date = calendar.date(byAdding: .day, value: -i, to: Date()) {
            let completion = Completion(date: date, completed: true)
            habit.completions.append(completion)
        }
    }
    
    return HabitCalendarView(habit: habit)
        .modelContainer(container)
        .padding()
}

