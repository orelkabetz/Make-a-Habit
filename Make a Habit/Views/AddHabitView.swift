//
//  AddHabitView.swift
//  Make a Habit
//
//  Created by Or Elkabetz on 01/11/2025.
//

import SwiftUI
import SwiftData

struct AddHabitView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var habitName = ""
    @State private var period: Habit.Period = .daily
    @State private var reminderEnabled = false
    @State private var reminderTime = Date()
    @State private var selectedDays: Set<Int> = []
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Habit Details") {
                    TextField("Habit Name", text: $habitName)
                        .textInputAutocapitalization(.words)
                }
                
                Section("Period") {
                    Picker("Period", selection: $period) {
                        Text("Daily").tag(Habit.Period.daily)
                        Text("Weekly").tag(Habit.Period.weekly)
                        Text("Monthly").tag(Habit.Period.monthly)
                    }
                    .pickerStyle(.segmented)
                }
                
                Section("Reminders") {
                    Toggle("Enable Reminders", isOn: $reminderEnabled)
                    
                    if reminderEnabled {
                        DatePicker("Reminder Time", selection: $reminderTime, displayedComponents: .hourAndMinute)
                        
                        if period == .daily || period == .weekly {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Days of Week")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                
                                HStack(spacing: 8) {
                                    ForEach(0..<7, id: \.self) { dayIndex in
                                        let dayName = Calendar.current.shortWeekdaySymbols[dayIndex]
                                        let isSelected = selectedDays.contains(dayIndex)
                                        
                                        Button(action: {
                                            withAnimation(.easeInOut(duration: 0.2)) {
                                                if selectedDays.contains(dayIndex) {
                                                    selectedDays.remove(dayIndex)
                                                } else {
                                                    selectedDays.insert(dayIndex)
                                                }
                                            }
                                        }) {
                                            Text(dayName)
                                                .font(.caption)
                                                .fontWeight(isSelected ? .semibold : .regular)
                                                .frame(maxWidth: .infinity)
                                                .frame(height: 44)
                                                .background(isSelected ? Color.blue : Color.gray.opacity(0.2))
                                                .foregroundColor(isSelected ? .white : .primary)
                                                .cornerRadius(8)
                                        }
                                        .buttonStyle(.plain)
                                    }
                                }
                            }
                            .padding(.vertical, 8)
                        }
                    }
                }
            }
            .navigationTitle("New Habit")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveHabit()
                    }
                    .disabled(habitName.isEmpty)
                }
            }
        }
    }
    
    private func saveHabit() {
        let habit = Habit(name: habitName, period: period, reminderEnabled: reminderEnabled)
        
        if reminderEnabled {
            habit.reminderTime = reminderTime
            habit.reminderDays = Array(selectedDays)
        }
        
        modelContext.insert(habit)
        
        do {
            try modelContext.save()
            
            // Schedule notifications if reminders enabled
            if reminderEnabled {
                NotificationManager.shared.scheduleReminder(for: habit)
            }
            
            dismiss()
        } catch {
            print("Error saving habit: \(error)")
        }
    }
}

#Preview {
    AddHabitView()
        .modelContainer(for: [Habit.self, Completion.self], inMemory: true)
}

