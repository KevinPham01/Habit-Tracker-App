// Habit Tracker [Final Project]/AddEditHabitView.swift

import SwiftUI

struct AddEditHabitView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var habitName: String = ""
    @State private var frequency: String = "Daily"
    @State private var category: String = "Health"
    @State private var reminderTime: Date = Calendar.current.date(from: DateComponents(hour: 9, minute: 0))! // Default to 9:00 AM
    var onSave: ((Habit) -> Void)? // Closure to handle saving the habit
    
    var body: some View {
        Form {
            TextField("Habit Name", text: $habitName)
            Picker("Frequency", selection: $frequency) {
                Text("Daily").tag("Daily")
                Text("Weekly").tag("Weekly")
                Text("Monthly").tag("Monthly")
            }
            TextField("Category", text: $category)
            DatePicker("Reminder Time", selection: $reminderTime, displayedComponents: .hourAndMinute)
            
            HStack {
                Button("Clear") {
                    // Clear fields
                }
                .padding()
                
                Button("Save") {
                    let newHabit = Habit(
                        name: habitName,
                        streak: 0,
                        category: category,
                        frequency: frequency,
                        reminderTime: reminderTime
                    )
                    onSave?(newHabit) // Call the onSave closure
                    dismiss()
                }
                .padding()
            }
        }
        .navigationTitle("Add/Edit Habit")
    }
}
