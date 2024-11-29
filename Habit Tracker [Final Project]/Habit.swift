import Foundation
import ParseSwift

// Habit Model
struct Habit: Identifiable, Codable {
    let id = UUID()
    var name: String
    var streak: Int
    var lastCompleted: Date?
    var isCompleted: Bool = false
    var category: String
    var frequency: String
    var reminderTime: Date?
}
