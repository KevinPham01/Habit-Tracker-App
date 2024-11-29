//  Habit_Tracker__Final_Project_App.swift
//  Habit Tracker [Final Project]
//
//  Created by Kevin Pham on 11/28/24.
//

import SwiftUI
import ParseSwift // TODO: Import Parse Swift

@main
struct HabitTrackerApp: App {
    @AppStorage("isDarkMode") private var isDarkMode: Bool = true

    init() {
        requestNotificationPermission()
        initializeParse() // Initialize Parse SDK
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(isDarkMode ? .dark : .light)
        }
    }

    private func requestNotificationPermission() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { granted, error in
            if let error = error {
                print("Error requesting notification permission: \(error)")
            }
            // Handle granted or denied permission
        }
    }

    private func initializeParse() {
        // TODO: Initialize Parse SDK
        ParseSwift.initialize(applicationId: "VmRP3sgH4VaDjpI0HhFkQhKBaoFtCMxKjxmoS2NV",
                              clientKey: "bWc8sRmqtYZqVMoHihngKpQJpS6QrUiVAWt7xEke",
                              serverURL: URL(string: "https://parseapi.back4app.com")!)
    }


}

// Create your own value type `ParseObject`.
struct GameScore: ParseObject {
    // These are required by ParseObject
    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
    var ACL: ParseACL?
    var originalData: Data?

    // Your own custom properties.
    var playerName: String?
    var points: Int?
}


