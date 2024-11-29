import SwiftUI

struct HabitDetailView: View {
    @Binding var habits: [Habit] // Binding to the habits array
    @Binding var completedHabits: [Bool] // Add this line
    var habit: Habit
    
    var body: some View {
        VStack {
            Text("Habit: \(habit.name)")
                .font(.largeTitle)
            Text("Streak: \(habit.streak) \(getFrequencyUnit(habit.frequency))")
                .font(.title)
            Text("Category: \(habit.category)")
                .font(.title)
            Text("Frequency: \(habit.frequency)")
                .font(.title)
            Text("Reminder: \(formatTime(habit.reminderTime))")
                .font(.title)
            
            
            HStack {
                NavigationLink(destination: AddEditHabitView(onSave: { updatedHabit in
                    if let index = habits.firstIndex(where: { $0.id == habit.id }) {
                        habits[index] = updatedHabit
                        completedHabits[index] = false // Reset the checkbox
                    }
                })) {
                    Text("Edit Habit")
                }
                .padding()
                
                Button("Delete") {
                    if let index = habits.firstIndex(where: { $0.id == habit.id }) {
                        habits.remove(at: index) // Remove the habit from the list
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Habit Detail")
    }
    
    private func formatTime(_ date: Date?) -> String {
        guard let date = date else { return "Not set" }
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    private func getFrequencyUnit(_ frequency: String) -> String {
        switch frequency {
            case "Daily": return "days"
            case "Weekly": return "weeks"
            case "Monthly": return "months"
            default: return "days"
        }
    }
}
