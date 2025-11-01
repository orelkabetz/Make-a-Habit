//
//  WelcomeBackView.swift
//  Make a Habit
//
//  Created by Or Elkabetz on 01/11/2025.
//

import SwiftUI
import Contacts

struct WelcomeBackView: View {
    @Binding var showWelcomeBack: Bool
    @State private var userName: String = "there"
    
    private let logoGreen = Color(red: 0.298, green: 0.686, blue: 0.314) // #4CAF50
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            // Welcome message
            Text("Welcome Back \(userName)!")
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            
            // Logo
            AppLogo(size: 150)
            
            // Motivational text
            Text("Let's continue making habits")
                .font(.title3)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Spacer()
            
            // Continue Button
            Button(action: {
                withAnimation {
                    showWelcomeBack = false
                }
            }) {
                Text("Continue")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(logoGreen)
                    .cornerRadius(12)
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 60)
        }
        .padding()
        .onAppear {
            fetchUserName()
        }
    }
    
    private func fetchUserName() {
        // First, try to extract name from device name (e.g., "Or's iPhone" -> "Or")
        let deviceName = UIDevice.current.name
        
        // Try to extract name from patterns like "Name's iPhone", "Name iPhone", etc.
        if let nameFromDevice = extractNameFromDevice(deviceName) {
            DispatchQueue.main.async {
                self.userName = nameFromDevice
            }
        }
        
        // Then try to get from Contacts "me" card (more accurate if available)
        let store = CNContactStore()
        store.requestAccess(for: .contacts) { granted, error in
            if granted {
                do {
                    let keys = [CNContactGivenNameKey, CNContactFamilyNameKey] as [CNKeyDescriptor]
                    // Try to get unified contacts
                    let predicate = CNContact.predicateForContacts(matchingName: "")
                    let contacts = try store.unifiedContacts(matching: predicate, keysToFetch: keys)
                    
                    // Look for a contact that might be "me" - usually it's marked or in favorites
                    // For now, we'll use the first contact with a name, but ideally check for "me" marker
                    for contact in contacts {
                        let fullName = "\(contact.givenName) \(contact.familyName)".trimmingCharacters(in: .whitespaces)
                        if !fullName.isEmpty && !contact.givenName.isEmpty {
                            DispatchQueue.main.async {
                                // Prefer first name only for more personal greeting
                                self.userName = contact.givenName
                            }
                            return
                        }
                    }
                } catch {
                    print("Error fetching contacts: \(error)")
                }
            }
        }
    }
    
    private func extractNameFromDevice(_ deviceName: String) -> String? {
        // Patterns to extract name:
        // "Or's iPhone" -> "Or"
        // "Or iPhone" -> "Or"
        // "John's iPad" -> "John"
        
        // Try "'s" pattern first
        if let name = deviceName.components(separatedBy: "'s").first, 
           !name.isEmpty && name != deviceName {
            return name.trimmingCharacters(in: .whitespaces)
        }
        
        // Try "iPhone", "iPad", "iPod" as separators
        let deviceTypes = ["iPhone", "iPad", "iPod", "Apple Watch"]
        for deviceType in deviceTypes {
            if deviceName.contains(deviceType) {
                let components = deviceName.components(separatedBy: deviceType)
                if let name = components.first, !name.isEmpty {
                    let trimmed = name.trimmingCharacters(in: .whitespaces)
                    if !trimmed.isEmpty && trimmed.count < 50 { // Reasonable name length
                        return trimmed
                    }
                }
            }
        }
        
        return nil
    }
}

#Preview {
    WelcomeBackView(showWelcomeBack: .constant(true))
}

