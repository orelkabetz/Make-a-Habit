//
//  Completion.swift
//  Make a Habit
//
//  Created by Or Elkabetz on 01/11/2025.
//

import Foundation
import SwiftData

@Model
final class Completion {
    var date: Date
    var completed: Bool
    
    init(date: Date, completed: Bool) {
        self.date = date
        self.completed = completed
    }
}

