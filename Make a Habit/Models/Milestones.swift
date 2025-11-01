//
//  Milestones.swift
//  Make a Habit
//
//  Created by Or Elkabetz on 01/11/2025.
//

import Foundation

struct Milestones: Codable {
    var first: Milestone = Milestone()
    var second: Milestone = Milestone()
    var third: Milestone = Milestone()
}

struct Milestone: Codable {
    var reached: Bool = false
    var date: Date?
}

