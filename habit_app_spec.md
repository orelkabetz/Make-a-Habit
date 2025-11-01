# Make a Habit - iOS App Specification (Swift)

## Core Concept
An app based on the "Rule of 3" - helping users build habits by tracking completion over three milestones: 3 days, 3 weeks, and 3 months.

## Key Features

### 1. Home Screen
- Display all active habits in a list/card format
- Show progress for each habit (e.g., 1/3 days, 2/3 weeks, 3/3 months)
- Visual indicator for completion status
- Button to add new habit

### 2. Add New Habit
**Fields:**
- Habit name (text input)
- Period selection:
  - Daily (3 days → 3 weeks → 3 months)
  - Weekly (3 weeks → 3 months → 3 quarters)
  - Monthly (3 months → 3 quarters → 3 years)
- Reminder toggle (yes/no)
- If reminder enabled:
  - Time selection
  - Days of week (for daily/weekly habits)

### 3. Habit Tracking
- Users can manually check off completion
- Notification with quick action to mark as done
- Track streak and reset if missed
- Celebrate milestones:
  - First milestone (3 days/weeks/months)
  - Second milestone (3 weeks/months/quarters)
  - Third milestone (3 months/quarters/years)

### 4. Notifications
- Reminder notifications at scheduled time
- Milestone celebration notifications
- Quick action in notification to mark complete

## Technical Stack for iOS

### Native iOS (Swift + SwiftUI)
```
- Language: Swift 5.9+
- UI Framework: SwiftUI
- Architecture: MVVM
- Storage: SwiftData (iOS 17+) or Core Data
- Notifications: UNUserNotificationCenter
- Minimum iOS: 17.0 (for SwiftData) or 15.0 (for Core Data)
```

### Key Frameworks
- SwiftUI for UI
- SwiftData for persistence
- UserNotifications for local notifications
- WidgetKit (optional) for home screen widgets

## Data Structure

```swift
import SwiftData
import Foundation

@Model
class Habit {
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

@Model
class Completion {
    var date: Date
    var completed: Bool
    
    init(date: Date, completed: Bool) {
        self.date = date
        self.completed = completed
    }
}

struct Milestones: Codable {
    var first: Milestone = Milestone()
    var second: Milestone = Milestone()
    var third: Milestone = Milestone()
}

struct Milestone: Codable {
    var reached: Bool = false
    var date: Date?
}
```

## App Structure

### Views
1. **ContentView** - Main container with navigation
2. **HabitListView** - Home screen showing all habits
3. **AddHabitView** - Form to create new habit
4. **HabitDetailView** - View/edit individual habit
5. **HabitRowView** - Reusable habit card component

### ViewModels
1. **HabitViewModel** - Manages habit data and business logic
2. **NotificationManager** - Handles all notification scheduling

## Cursor AI Prompts for iOS Development

### 1. Initial Xcode Project Setup
```
Create a new iOS app in SwiftUI called "Make a Habit" with:
- ContentView as the main view
- SwiftData model container setup
- Minimum deployment target iOS 17.0
- App structure with MVVM architecture
```

### 2. SwiftData Models
```
Create SwiftData models for habit tracking:
- Habit model with properties: id, name, period, reminderEnabled, reminderTime, reminderDays, createdAt
- Completion model to track each completion date
- Milestones struct to track 3 milestone achievements
- Use proper relationships and cascade delete rules
```

### 3. Home Screen UI
```
Create a HabitListView in SwiftUI that:
- Uses @Query to fetch all habits from SwiftData
- Displays habits in a List or ScrollView with cards
- Shows habit name and progress for 3 milestones
- Has a + button in navigation bar to add new habit
- Shows empty state when no habits exist
```

### 4. Add Habit Form
```
Create an AddHabitView with:
- TextField for habit name
- Picker for period (daily, weekly, monthly)
- Toggle for enable/disable reminders
- DatePicker for reminder time (shown conditionally)
- Multi-selection for days of week
- Save button that creates new Habit in SwiftData
```

### 5. Notifications System
```
Create a NotificationManager class that:
- Requests notification permissions
- Schedules local notifications based on habit reminder settings
- Handles notification actions for marking habits complete
- Sends celebration notifications when milestones are reached
- Uses UNUserNotificationCenter
```

### 6. Habit Progress Logic
```
Implement habit tracking logic:
- Function to mark habit as complete for today
- Calculate current streak
- Determine milestone progress (3 days, 3 weeks, 3 months)
- Handle different period types (daily, weekly, monthly)
- Detect when milestones are reached
```

### 7. UI Components
```
Create SwiftUI components:
- HabitRowView with progress circles for 3 milestones
- Custom progress indicator showing current milestone
- Checkmark button to mark habit complete
- Celebration view/sheet for milestone achievements
- Use SF Symbols for icons
```

## Project Structure
```
MakeAHabit/
├── MakeAHabitApp.swift
├── Models/
│   ├── Habit.swift
│   ├── Completion.swift
│   └── Milestones.swift
├── Views/
│   ├── ContentView.swift
│   ├── HabitListView.swift
│   ├── AddHabitView.swift
│   ├── HabitDetailView.swift
│   └── Components/
│       ├── HabitRowView.swift
│       └── MilestoneProgressView.swift
├── ViewModels/
│   └── HabitViewModel.swift
├── Managers/
│   └── NotificationManager.swift
└── Resources/
    └── Assets.xcassets
```

## Info.plist Requirements
```xml
<key>NSUserNotificationsUsageDescription</key>
<string>We need permission to remind you about your habits</string>
```

## MVP Features (Build First)

1. ✅ SwiftData setup with Habit model
2. ✅ Home screen listing habits
3. ✅ Add habit screen (name + daily only)
4. ✅ Mark habit complete button
5. ✅ Basic milestone tracking (3 days, 3 weeks, 3 months)
6. ✅ Local notifications for reminders
7. ✅ Celebration alert when milestone reached

## Enhanced Features (Add Later)

- Edit/delete habits
- Habit history view
- Statistics and charts
- Widget for home screen
- Weekly/monthly period types
- Custom notification messages
- Dark mode optimization
- iCloud sync
- Streak recovery grace period
- Share achievements

## Getting Started with Cursor AI

1. **Create Xcode Project:**
   - Open Xcode
   - Create new iOS App project
   - Choose SwiftUI interface and SwiftData storage

2. **Open in Cursor AI:**
   - Open the project folder in Cursor AI
   - Start with the SwiftData models prompt

3. **Build Incrementally:**
   - Use the prompts above one at a time
   - Test each feature before moving to the next
   - Start with data models, then views, then notifications

4. **Key iOS-Specific Tips:**
   - Use `@Query` for fetching SwiftData
   - Use `@Environment(\.modelContext)` for saving
   - Test notifications on physical device (simulator has limitations)
   - Request notification permissions early in app lifecycle

## Design Guidelines

- Follow iOS Human Interface Guidelines
- Use native iOS components (List, NavigationStack, etc.)
- Use SF Symbols for icons
- Support both light and dark mode
- Use standard iOS animations and transitions
- Follow iOS navigation patterns

---

## How to Use This Document with Cursor AI

1. Save this file as `REQUIREMENTS.md` in your project root
2. Reference it when asking Cursor: "Based on REQUIREMENTS.md, create..."
3. Use the prompts section to guide your development step-by-step