//
//  QuoteCardContainer.swift
//  Make a Habit
//
//  Created by Or Elkabetz on 01/11/2025.
//

import SwiftUI

struct QuoteCardContainer: View {
    let refreshTrigger: UUID
    
    var body: some View {
        VStack(spacing: 0) {
            // Quote card with background
            QuoteCardView(refreshTrigger: refreshTrigger)
                .padding(.horizontal, 16)
                .padding(.top, 16)
                .padding(.bottom, 24)
                .background(Color(UIColor.systemBackground))
        }
    }
}

#Preview {
    QuoteCardContainer(refreshTrigger: UUID())
}

