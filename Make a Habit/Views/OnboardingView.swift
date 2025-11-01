//
//  OnboardingView.swift
//  Make a Habit
//
//  Created by Or Elkabetz on 01/11/2025.
//

import SwiftUI

struct OnboardingView: View {
    @Binding var showOnboarding: Bool
    @State private var currentPage = 0
    
    var body: some View {
        TabView(selection: $currentPage) {
            OnboardingPage1(currentPage: $currentPage)
                .tag(0)
            
            OnboardingPage2(showOnboarding: $showOnboarding)
                .tag(1)
        }
        .tabViewStyle(.page)
        .indexViewStyle(.page(backgroundDisplayMode: .always))
    }
}

struct OnboardingPage1: View {
    @Binding var currentPage: Int
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            // Logo and Title
            VStack(spacing: 24) {
                AppLogo(size: 150)
                
                Text("Make a Habit")
                    .font(.largeTitle)
                    .fontWeight(.bold)
            }
            
            // Subtitle
            Text("Let's create good habits today")
                .font(.title3)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Spacer()
            
            // Start Button
            Button(action: {
                withAnimation {
                    currentPage = 1
                }
            }) {
                Text("Start")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(red: 0.298, green: 0.686, blue: 0.314)) // #4CAF50
                    .cornerRadius(12)
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 60)
        }
        .padding()
    }
}

struct OnboardingPage2: View {
    @Binding var showOnboarding: Bool
    @State private var dot1Position = CGPoint(x: 0, y: 0)
    @State private var dot2Position = CGPoint(x: 0, y: 0)
    @State private var dot3Position = CGPoint(x: 0, y: 0)
    @State private var dot1Velocity = CGSize(width: 0, height: 0)
    @State private var dot2Velocity = CGSize(width: 0, height: 0)
    @State private var dot3Velocity = CGSize(width: 0, height: 0)
    @State private var dot1TargetVelocity = CGSize.zero
    @State private var dot2TargetVelocity = CGSize.zero
    @State private var dot3TargetVelocity = CGSize.zero
    @State private var screenSize = CGSize.zero
    
    private let logoGreen = Color(red: 0.298, green: 0.686, blue: 0.314) // #4CAF50
    private let dotSize: CGFloat = 56
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Floating dots in the background
                FloatingDotsView(
                    dot1Position: $dot1Position,
                    dot2Position: $dot2Position,
                    dot3Position: $dot3Position,
                    logoGreen: logoGreen,
                    screenSize: geometry.size,
                    dotSize: dotSize
                )
                .onAppear {
                    screenSize = geometry.size
                }
                
                // Main content
                VStack(spacing: 40) {
                    Spacer()
                    
                    // Title
                    Text("The Rule of 3")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    // Body text
                    VStack(spacing: 16) {
                        Text("Once is a good start. Twice shows commitment. Three times makes it stick.")
                            .font(.body)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.primary)
                        
                        Text("Complete a habit 3 times and you're on your way to making it part of your life.")
                            .font(.body)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.primary)
                    }
                    .padding(.horizontal, 40)
                    .zIndex(1) // Keep text above floating dots
                    
                    Spacer()
                    
                    // Let's Go Button
                    Button(action: {
                        withAnimation {
                            showOnboarding = false
                        }
                    }) {
                        Text("Let's Go")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(logoGreen)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal, 40)
                    .padding(.bottom, 60)
                    .zIndex(1) // Keep button above floating dots
                }
                .padding()
            }
        }
        .onAppear {
            startRandomAnimation()
        }
    }
    
    private func startRandomAnimation() {
        // Initialize with random positions and smooth initial velocities
        dot1Position = CGPoint(x: 150, y: 200)
        dot2Position = CGPoint(x: 250, y: 400)
        dot3Position = CGPoint(x: 100, y: 600)
        
        // Start with smooth, flowing velocities
        dot1Velocity = CGSize(width: Double.random(in: 20...40), height: Double.random(in: -30...30))
        dot2Velocity = CGSize(width: Double.random(in: -35...35), height: Double.random(in: 25...45))
        dot3Velocity = CGSize(width: Double.random(in: -40...25), height: Double.random(in: -35...35))
        
        // Set initial target velocities
        dot1TargetVelocity = dot1Velocity
        dot2TargetVelocity = dot2Velocity
        dot3TargetVelocity = dot3Velocity
        
        // Start continuous animation loop
        Timer.scheduledTimer(withTimeInterval: 0.016, repeats: true) { _ in
            updateDotPositions()
            smoothlyInterpolateVelocities()
        }
        
        // Change target velocities less frequently for smoother flow (8-15 seconds)
        scheduleTargetVelocityChange(dot: 1, interval: 8...15)
        scheduleTargetVelocityChange(dot: 2, interval: 10...18)
        scheduleTargetVelocityChange(dot: 3, interval: 7...14)
    }
    
    private func scheduleTargetVelocityChange(dot: Int, interval: ClosedRange<Double>) {
        Timer.scheduledTimer(withTimeInterval: Double.random(in: interval), repeats: true) { _ in
            let newTarget = CGSize(
                width: Double.random(in: -35...35),
                height: Double.random(in: -35...35)
            )
            
            switch dot {
            case 1:
                dot1TargetVelocity = newTarget
            case 2:
                dot2TargetVelocity = newTarget
            case 3:
                dot3TargetVelocity = newTarget
            default:
                break
            }
            
            // Schedule next change
            scheduleTargetVelocityChange(dot: dot, interval: interval)
        }
    }
    
    private func smoothlyInterpolateVelocities() {
        DispatchQueue.main.async {
            // Smoothly interpolate current velocity toward target velocity
            // Using linear interpolation with a small step size for smooth transitions
            let interpolationSpeed: Double = 0.015 // How fast velocity changes
            
            // Interpolate dot 1
            let diff1 = CGSize(
                width: self.dot1TargetVelocity.width - self.dot1Velocity.width,
                height: self.dot1TargetVelocity.height - self.dot1Velocity.height
            )
            self.dot1Velocity = CGSize(
                width: self.dot1Velocity.width + diff1.width * interpolationSpeed,
                height: self.dot1Velocity.height + diff1.height * interpolationSpeed
            )
            
            // Interpolate dot 2
            let diff2 = CGSize(
                width: self.dot2TargetVelocity.width - self.dot2Velocity.width,
                height: self.dot2TargetVelocity.height - self.dot2Velocity.height
            )
            self.dot2Velocity = CGSize(
                width: self.dot2Velocity.width + diff2.width * interpolationSpeed,
                height: self.dot2Velocity.height + diff2.height * interpolationSpeed
            )
            
            // Interpolate dot 3
            let diff3 = CGSize(
                width: self.dot3TargetVelocity.width - self.dot3Velocity.width,
                height: self.dot3TargetVelocity.height - self.dot3Velocity.height
            )
            self.dot3Velocity = CGSize(
                width: self.dot3Velocity.width + diff3.width * interpolationSpeed,
                height: self.dot3Velocity.height + diff3.height * interpolationSpeed
            )
        }
    }
    
    private func updateDotPositions() {
        DispatchQueue.main.async {
            // Update positions
            var pos1 = self.dot1Position
            var pos2 = self.dot2Position
            var pos3 = self.dot3Position
            
            pos1.x += self.dot1Velocity.width * 0.016
            pos1.y += self.dot1Velocity.height * 0.016
            
            pos2.x += self.dot2Velocity.width * 0.016
            pos2.y += self.dot2Velocity.height * 0.016
            
            pos3.x += self.dot3Velocity.width * 0.016
            pos3.y += self.dot3Velocity.height * 0.016
            
            // Wrap around screen boundaries
            self.wrapPosition(&pos1)
            self.wrapPosition(&pos2)
            self.wrapPosition(&pos3)
            
            // Update state with animation
            withAnimation(.linear(duration: 0.016)) {
                self.dot1Position = pos1
                self.dot2Position = pos2
                self.dot3Position = pos3
            }
        }
    }
    
    private func wrapPosition(_ position: inout CGPoint) {
        // Wrap horizontally
        if position.x < -dotSize {
            position.x = screenSize.width + dotSize
        } else if position.x > screenSize.width + dotSize {
            position.x = -dotSize
        }
        
        // Wrap vertically
        if position.y < -dotSize {
            position.y = screenSize.height + dotSize
        } else if position.y > screenSize.height + dotSize {
            position.y = -dotSize
        }
    }
}

struct FloatingDotsView: View {
    @Binding var dot1Position: CGPoint
    @Binding var dot2Position: CGPoint
    @Binding var dot3Position: CGPoint
    let logoGreen: Color
    let screenSize: CGSize
    let dotSize: CGFloat
    
    var body: some View {
        ZStack {
            // Top dot (lightest) - floating with wrap-around
            Circle()
                .fill(logoGreen.opacity(0.3))
                .frame(width: dotSize, height: dotSize)
                .position(dot1Position)
            
            // Middle dot (medium) - floating with wrap-around
            Circle()
                .fill(logoGreen.opacity(0.6))
                .frame(width: dotSize, height: dotSize)
                .position(dot2Position)
            
            // Bottom dot (full opacity) - floating with wrap-around
            Circle()
                .fill(logoGreen)
                .frame(width: dotSize, height: dotSize)
                .position(dot3Position)
        }
        .allowsHitTesting(false) // Don't interfere with taps
    }
}

#Preview {
    OnboardingView(showOnboarding: .constant(true))
}

