//
//  NotificationManager.swift
//  Make a Habit
//
//  Created by Or Elkabetz on 01/11/2025.
//

import Foundation
import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()
    
    private init() {}
    
    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Notification authorization error: \(error)")
            }
        }
    }
    
    func scheduleReminder(for habit: Habit) {
        guard habit.reminderEnabled, let reminderTime = habit.reminderTime else { return }
        
        let content = UNMutableNotificationContent()
        content.title = "Habit Reminder"
        content.body = "Don't forget to complete: \(habit.name)"
        content.sound = .default
        content.categoryIdentifier = "HABIT_REMINDER"
        content.userInfo = ["habitId": habit.id.uuidString]
        
        // Add action to mark complete
        let markCompleteAction = UNNotificationAction(
            identifier: "MARK_COMPLETE",
            title: "Mark Complete",
            options: []
        )
        let category = UNNotificationCategory(
            identifier: "HABIT_REMINDER",
            actions: [markCompleteAction],
            intentIdentifiers: [],
            options: []
        )
        UNUserNotificationCenter.current().setNotificationCategories([category])
        
        // Schedule based on period
        var dateComponents = Calendar.current.dateComponents([.hour, .minute], from: reminderTime)
        
        if habit.period == .daily {
            // Daily reminder - schedule for each selected day
            // dayIndex: 0=Sunday, 1=Monday, ..., 6=Saturday
            // weekday: 1=Sunday, 2=Monday, ..., 7=Saturday
            let days = habit.reminderDays.isEmpty ? Array(0...6) : habit.reminderDays
            for day in days {
                dateComponents.weekday = day + 1 // Convert 0-6 to 1-7
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
                let request = UNNotificationRequest(
                    identifier: "\(habit.id.uuidString)-\(day)",
                    content: content,
                    trigger: trigger
                )
                UNUserNotificationCenter.current().add(request)
            }
        }
    }
    
    func cancelReminders(for habit: Habit) {
        let identifiers = habit.reminderDays.isEmpty 
            ? (0...6).map { "\(habit.id.uuidString)-\($0)" }
            : habit.reminderDays.map { "\(habit.id.uuidString)-\($0)" }
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
    }
    
    func sendMilestoneCelebration(for habit: Habit, milestone: Int) {
        let content = UNMutableNotificationContent()
        content.title = "🎉 Milestone Achieved!"
        
        let milestoneText: String
        switch milestone {
        case 1:
            milestoneText = habit.period == .daily ? "3 days" : habit.period == .weekly ? "3 weeks" : "3 months"
        case 2:
            milestoneText = habit.period == .daily ? "3 weeks" : habit.period == .weekly ? "3 months" : "3 quarters"
        case 3:
            milestoneText = habit.period == .daily ? "3 months" : habit.period == .weekly ? "3 quarters" : "3 years"
        default:
            milestoneText = "milestone"
        }
        
        content.body = "Congratulations! You've completed \(milestoneText) of \(habit.name)!"
        content.sound = .default
        
        let request = UNNotificationRequest(
            identifier: "milestone-\(habit.id.uuidString)-\(milestone)",
            content: content,
            trigger: nil
        )
        UNUserNotificationCenter.current().add(request)
    }
}

