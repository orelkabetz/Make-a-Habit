//
//  MilestoneProgressView.swift
//  Make a Habit
//
//  Created by Or Elkabetz on 01/11/2025.
//

import SwiftUI

struct MilestoneProgressView: View {
    let progress: Int
    let target: Int
    let isReached: Bool
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(isReached ? Color.green : Color.gray.opacity(0.3), lineWidth: 3)
                .frame(width: 40, height: 40)
            
            if isReached {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
                    .font(.title3)
            } else {
                Text("\(min(progress, target))")
                    .font(.caption)
                    .fontWeight(.bold)
            }
        }
    }
}

#Preview {
    HStack {
        MilestoneProgressView(progress: 2, target: 3, isReached: false)
        MilestoneProgressView(progress: 3, target: 3, isReached: true)
        MilestoneProgressView(progress: 1, target: 3, isReached: false)
    }
    .padding()
}

