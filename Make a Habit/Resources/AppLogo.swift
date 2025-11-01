//
//  AppLogo.swift
//  Make a Habit
//
//  Created by Or Elkabetz on 01/11/2025.
//

import SwiftUI

struct AppLogo: View {
    var size: CGFloat = 200
    
    // Based on SVG: viewBox="0 0 200 200"
    // Background: r="90" (diameter 180)
    // Dots: r="18" (diameter 36)
    // Positions: cy="60", cy="100", cy="140" (centered at 100)
    
    private var logoGreen: Color {
        Color(red: 0.298, green: 0.686, blue: 0.314) // #4CAF50
    }
    
    var body: some View {
        ZStack {
            // Background circle - r=90 means diameter is 180 in 200 viewBox
            Circle()
                .fill(logoGreen.opacity(0.1))
                .frame(width: size * 0.9, height: size * 0.9)
            
            // Three dots positioned exactly like SVG
            // In SVG: cy positions are 60, 100, 140 (relative to 200x200, center at 100)
            // So offsets from center: -40, 0, +40
            
            // Top dot at cy=60 (40 units above center)
            Circle()
                .fill(logoGreen.opacity(0.3))
                .frame(width: size * 0.18, height: size * 0.18)
                .offset(y: -size * 0.2)
            
            // Middle dot at cy=100 (at center)
            Circle()
                .fill(logoGreen.opacity(0.6))
                .frame(width: size * 0.18, height: size * 0.18)
            
            // Bottom dot at cy=140 (40 units below center)
            Circle()
                .fill(logoGreen)
                .frame(width: size * 0.18, height: size * 0.18)
                .offset(y: size * 0.2)
        }
        .frame(width: size, height: size)
    }
}

#Preview {
    VStack(spacing: 40) {
        AppLogo(size: 100)
        AppLogo(size: 200)
        AppLogo(size: 60)
    }
    .padding()
}

