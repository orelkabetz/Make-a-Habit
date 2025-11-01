//
//  QuoteCardView.swift
//  Make a Habit
//
//  Created by Or Elkabetz on 01/11/2025.
//

import SwiftUI

struct QuoteCardView: View {
    @State private var currentQuoteIndex = 0
    let refreshTrigger: UUID
    
    private let quotes = [
        ("Success is the sum of small efforts repeated day in and day out.", Color(red: 1.0, green: 0.84, blue: 0.0)), // Golden Yellow
        ("The only bad workout is the one that didn't happen.", Color(red: 0.48, green: 0.98, blue: 0.58)), // Light Green
        ("You don't have to be great to start, but you have to start to be great.", Color(red: 0.98, green: 0.75, blue: 0.85)), // Pink
        ("Progress, not perfection.", Color(red: 0.68, green: 0.85, blue: 1.0)), // Sky Blue
        ("Every accomplishment starts with the decision to try.", Color(red: 1.0, green: 0.92, blue: 0.73)), // Light Yellow
        ("Small steps every day lead to big results.", Color(red: 0.93, green: 0.69, blue: 0.94)), // Lavender
        ("Consistency is the mother of mastery.", Color(red: 0.69, green: 0.93, blue: 0.93)), // Turquoise
        ("You are what you repeatedly do. Excellence, then, is not an act, but a habit.", Color(red: 1.0, green: 0.82, blue: 0.64)), // Peach
    ]
    
    var body: some View {
        let quote = quotes[currentQuoteIndex]
        
        VStack(spacing: 10) {
            Image(systemName: "quote.opening")
                .font(.title3)
                .foregroundColor(.white.opacity(0.9))
            
            Text(quote.0)
                .font(.body)
                .fontWeight(.medium)
                .italic()
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .lineSpacing(4)
            
            Image(systemName: "quote.closing")
                .font(.title3)
                .foregroundColor(.white.opacity(0.9))
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 24)
        .frame(maxWidth: .infinity)
        .background(
            LinearGradient(
                colors: [
                    quote.1.opacity(0.8),
                    quote.1.opacity(0.6)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(16)
        .onAppear {
            // Rotate to a random quote on appear
            currentQuoteIndex = Int.random(in: 0..<quotes.count)
        }
        .onChange(of: refreshTrigger) { _, _ in
            // Change quote when refresh trigger changes
            withAnimation(.easeInOut(duration: 0.3)) {
                var newIndex = currentQuoteIndex
                while newIndex == currentQuoteIndex {
                    newIndex = Int.random(in: 0..<quotes.count)
                }
                currentQuoteIndex = newIndex
            }
        }
        .onTapGesture {
            // Change quote on tap
            withAnimation(.easeInOut(duration: 0.3)) {
                var newIndex = currentQuoteIndex
                while newIndex == currentQuoteIndex {
                    newIndex = Int.random(in: 0..<quotes.count)
                }
                currentQuoteIndex = newIndex
            }
        }
    }
}

#Preview {
    QuoteCardView(refreshTrigger: UUID())
        .padding()
}

