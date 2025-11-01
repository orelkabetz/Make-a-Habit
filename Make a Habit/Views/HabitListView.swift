//
//  HabitListView.swift
//  Make a Habit
//
//  Created by Or Elkabetz on 01/11/2025.
//

import SwiftUI
import SwiftData

struct HabitListView: View {
    @Query private var habits: [Habit]
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel = HabitViewModel()
    @State private var showAddHabit = false
    @State private var showCalendar = false
    @State private var showSettings = false
    @State private var quoteRefreshTrigger = UUID()
    
    var body: some View {
        Group {
            if habits.isEmpty {
                emptyStateView
            } else {
                habitListView
            }
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                HStack(spacing: 12) {
                    AppLogo(size: 30)
                    Text("My Habits")
                        .font(.headline)
                }
            }
            
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button(action: {
                    showSettings = true
                }) {
                    Image(systemName: "gearshape")
                }
                
                Button(action: {
                    showCalendar = true
                }) {
                    Image(systemName: "calendar")
                }
                
                Button(action: {
                    showAddHabit = true
                }) {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showAddHabit) {
            AddHabitView()
        }
        .sheet(isPresented: $showCalendar) {
            UnifiedCalendarView()
        }
        .sheet(isPresented: $showSettings) {
            SettingsView()
        }
        .onAppear {
            viewModel.setModelContext(modelContext)
            NotificationManager.shared.requestAuthorization()
        }
    }
    
    private var habitListView: some View {
        VStack(spacing: 0) {
            // Scrollable list of habits
            List {
                // Instruction text above cards
                Text("Press if you made it today")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 16)
                    .padding(.top, 4)
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                
                ForEach(habits) { habit in
                    HabitRowView(habit: habit, viewModel: viewModel)
                        .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                            Button(role: .destructive) {
                                deleteHabit(habit)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                }
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .refreshable {
                // Force quote to change on pull-to-refresh
                quoteRefreshTrigger = UUID()
            }
            
            // Fixed quote card at the bottom (outside scrollable area)
            QuoteCardContainer(refreshTrigger: quoteRefreshTrigger)
        }
    }
    
    private func deleteHabit(_ habit: Habit) {
        // Cancel any scheduled notifications for this habit
        NotificationManager.shared.cancelReminders(for: habit)
        
        // Delete the habit from SwiftData
        modelContext.delete(habit)
        
        do {
            try modelContext.save()
        } catch {
            print("Error deleting habit: \(error)")
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            AppLogo(size: 120)
            
            Text("No Habits Yet")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Start building your habits by adding your first one!")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Button(action: {
                showAddHabit = true
            }) {
                HStack {
                    Image(systemName: "plus.circle.fill")
                    Text("Add Your First Habit")
                }
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .background(Color.blue)
                .cornerRadius(10)
            }
            .padding(.top, 8)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    NavigationStack {
        HabitListView()
            .modelContainer(for: [Habit.self, Completion.self], inMemory: true)
    }
}

