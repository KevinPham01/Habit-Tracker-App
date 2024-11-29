import SwiftUI
import UserNotifications

struct SettingsView: View {
    @AppStorage("notificationsEnabled") private var notificationsEnabled: Bool = false
    @AppStorage("reminderTime") private var reminderTimeString: String = DateFormatter.localizedString(from: Date(), dateStyle: .none, timeStyle: .short)
    @AppStorage("isDarkMode") private var isDarkMode: Bool = true
    
    @State private var selectedReminderTime: Date = Date()
    
    var body: some View {
        Form {
            Toggle("Notifications", isOn: $notificationsEnabled)
                .onChange(of: notificationsEnabled) { value in
                    if value {
                        requestNotificationPermission()
                        scheduleNotification()
                    } else {
                        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                    }
                }
            
            VStack(alignment: .leading) {
                Text("Reminder Time")
                    .font(.headline)
                    .padding(.bottom, 5)
                
                DatePicker("", selection: $selectedReminderTime, displayedComponents: .hourAndMinute)
                    .labelsHidden()
                    .padding(.vertical)
                    .onChange(of: selectedReminderTime) { newValue in
                        let formatter = DateFormatter()
                        formatter.dateFormat = "hh:mm a"
                        reminderTimeString = formatter.string(from: newValue)
                        if notificationsEnabled {
                            scheduleNotification()
                        }
                    }
                    .datePickerStyle(WheelDatePickerStyle())
            }
            
            Picker("Theme", selection: $isDarkMode) {
                Text("Dark").tag(true)
                Text("Light").tag(false)
            }
            .pickerStyle(SegmentedPickerStyle())
        }
        .navigationTitle("Settings")
        .onAppear {
            let formatter = DateFormatter()
            formatter.dateFormat = "hh:mm a"
            selectedReminderTime = formatter.date(from: reminderTimeString) ?? Date()
        }
    }
    
    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
            if let error = error {
                print("Error requesting notification permission: \(error)")
            }
            if granted {
                print("Notification permission granted.")
            } else {
                print("Notification permission denied.")
            }
        }
    }
    
    private func scheduleNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Habit Reminder"
        content.body = "Don't forget to complete your habit!"
        content.sound = .default
        
        // Create a date components object for the reminder time
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: selectedReminderTime)
        
        // Create a trigger that fires at the specified time
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        
        // Create a request
        let request = UNNotificationRequest(identifier: "habitReminder", content: content, trigger: trigger)
        
        // Schedule the request
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            }
        }
    }
}
