//
//  HabitViewModel.swift
//  Make a Habit
//
//  Created by Or Elkabetz on 01/11/2025.
//

import Foundation
import SwiftData

@MainActor
class HabitViewModel: ObservableObject {
    var modelContext: ModelContext?
    
    func setModelContext(_ context: ModelContext) {
        self.modelContext = context
    }
    
    func markHabitComplete(_ habit: Habit, for date: Date = Date()) {
        let calendar = Calendar.current
        let normalizedDate = calendar.startOfDay(for: date)
        
        // Find existing completion for this date
        if let existingCompletion = habit.completions.first(where: { 
            calendar.isDate($0.date, inSameDayAs: normalizedDate) && $0.completed 
        }) {
            // Already completed - toggle off (unmark)
            if let index = habit.completions.firstIndex(where: { $0 === existingCompletion }) {
                habit.completions.remove(at: index)
                modelContext?.delete(existingCompletion)
            }
        } else {
            // Not completed - add completion
            let completion = Completion(date: normalizedDate, completed: true)
            habit.completions.append(completion)
            
            // Check milestones only when marking complete (not when unmarking)
            checkMilestones(for: habit)
        }
        
        // Save context
        try? modelContext?.save()
    }
    
    func checkMilestones(for habit: Habit) {
        let calendar = Calendar.current
        let now = Date()
        
        // Get sorted completions
        let sortedCompletions = habit.completions
            .filter { $0.completed }
            .sorted { $0.date < $1.date }
        
        guard !sortedCompletions.isEmpty else { return }
        
        let startDate = habit.createdAt
        let daysSinceStart = calendar.dateComponents([.day], from: calendar.startOfDay(for: startDate), to: calendar.startOfDay(for: now)).day ?? 0
        
        switch habit.period {
        case .daily:
            // Count consecutive days from start
            var consecutiveDays = 0
            var currentDate = calendar.startOfDay(for: startDate)
            
            while currentDate <= calendar.startOfDay(for: now) {
                if sortedCompletions.contains(where: { calendar.isDate($0.date, inSameDayAs: currentDate) }) {
                    consecutiveDays += 1
                    currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate) ?? currentDate
                } else {
                    break // Streak broken
                }
            }
            
            // Check milestones
            if consecutiveDays >= 3 && !habit.milestones.first.reached {
                habit.milestones.first.reached = true
                habit.milestones.first.date = now
                try? modelContext?.save()
                NotificationManager.shared.sendMilestoneCelebration(for: habit, milestone: 1)
            }
            
            let weeks = consecutiveDays / 7
            if weeks >= 3 && !habit.milestones.second.reached {
                habit.milestones.second.reached = true
                habit.milestones.second.date = now
                try? modelContext?.save()
                NotificationManager.shared.sendMilestoneCelebration(for: habit, milestone: 2)
            }
            
            let months = daysSinceStart / 30
            if months >= 3 && !habit.milestones.third.reached {
                habit.milestones.third.reached = true
                habit.milestones.third.date = now
                try? modelContext?.save()
                NotificationManager.shared.sendMilestoneCelebration(for: habit, milestone: 3)
            }
            
        case .weekly:
            // Weekly tracking - for MVP we'll implement basic logic
            let weeks = daysSinceStart / 7
            if weeks >= 3 && !habit.milestones.first.reached {
                habit.milestones.first.reached = true
                habit.milestones.first.date = now
                try? modelContext?.save()
                NotificationManager.shared.sendMilestoneCelebration(for: habit, milestone: 1)
            }
            
        case .monthly:
            // Monthly tracking - for MVP we'll implement basic logic
            let months = daysSinceStart / 30
            if months >= 3 && !habit.milestones.first.reached {
                habit.milestones.first.reached = true
                habit.milestones.first.date = now
                try? modelContext?.save()
                NotificationManager.shared.sendMilestoneCelebration(for: habit, milestone: 1)
            }
        }
    }
    
    func getCurrentStreak(for habit: Habit) -> Int {
        let calendar = Calendar.current
        let sortedCompletions = habit.completions
            .filter { $0.completed }
            .sorted { $0.date > $1.date } // Most recent first
        
        guard !sortedCompletions.isEmpty else { return 0 }
        
        var streak = 0
        var currentDate = calendar.startOfDay(for: Date())
        
        for completion in sortedCompletions {
            if calendar.isDate(completion.date, inSameDayAs: currentDate) {
                streak += 1
                currentDate = calendar.date(byAdding: .day, value: -1, to: currentDate) ?? currentDate
            } else {
                break
            }
        }
        
        return streak
    }
    
    func getMilestoneProgress(for habit: Habit) -> (first: Int, second: Int, third: Int, firstTarget: Int, secondTarget: Int, thirdTarget: Int) {
        let calendar = Calendar.current
        let now = Date()
        let startDate = habit.createdAt
        let daysSinceStart = calendar.dateComponents([.day], from: calendar.startOfDay(for: startDate), to: calendar.startOfDay(for: now)).day ?? 0
        
        switch habit.period {
        case .daily:
            // Count consecutive days
            var consecutiveDays = 0
            var currentDate = calendar.startOfDay(for: startDate)
            
            while currentDate <= calendar.startOfDay(for: now) {
                if habit.completions.contains(where: { $0.completed && calendar.isDate($0.date, inSameDayAs: currentDate) }) {
                    consecutiveDays += 1
                    currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate) ?? currentDate
                } else {
                    break
                }
            }
            
            let weeks = consecutiveDays / 7
            let months = daysSinceStart / 30
            
            return (
                first: min(consecutiveDays, 3),
                second: min(weeks, 3),
                third: min(months, 3),
                firstTarget: 3,
                secondTarget: 3,
                thirdTarget: 3
            )
            
        case .weekly:
            let weeks = daysSinceStart / 7
            return (0, 0, 0, 3, 3, 3)
            
        case .monthly:
            let months = daysSinceStart / 30
            return (0, 0, 0, 3, 3, 3)
        }
    }
}

