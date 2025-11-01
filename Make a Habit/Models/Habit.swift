//
//  Habit.swift
//  Make a Habit
//
//  Created by Or Elkabetz on 01/11/2025.
//

import Foundation
import SwiftData

@Model
final class Habit {
    @Attribute(.unique) var id: UUID
    var name: String
    var period: Period
    var reminderEnabled: Bool
    var reminderTime: Date?
    var reminderDays: [Int] // 0-6 for days of week
    var createdAt: Date
    @Relationship(deleteRule: .cascade) var completions: [Completion]
    var milestones: Milestones
    
    enum Period: String, Codable {
        case daily, weekly, monthly
    }
    
    init(name: String, period: Period, reminderEnabled: Bool) {
        self.id = UUID()
        self.name = name
        self.period = period
        self.reminderEnabled = reminderEnabled
        self.createdAt = Date()
        self.completions = []
        self.reminderDays = []
        self.milestones = Milestones()
    }
}

