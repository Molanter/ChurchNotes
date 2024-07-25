//
//  ReminderHandler.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 8/14/23.
//

import SwiftUI
import UserNotifications

class ReminderHandler {
    // Consider passing the viewModel as a parameter when needed
    // var viewModel: AppViewModel

    // Init method if needed
    // init(viewModel: AppViewModel) {
    //     self.viewModel = viewModel
    // }

    func removeAllNotifications(){
        let center = UNUserNotificationCenter.current()

        center.removeAllPendingNotificationRequests()
    }
    
    func askPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                // Handle successful permission if needed
                print("Notification permission granted")
            } else if let error = error {
                print("Error requesting notification permission: \(error.localizedDescription)")
            }
        }
    }

    func scheduleNotifications(days: [Int], message: String, date: Date, count: Int) {
        let content = UNMutableNotificationContent()
        content.title = String(localized: "pray-reminder")
        content.body = message.isEmpty ? String(localized: "time-to-pray-take-your-time") : message

        var dateComponents = Calendar.current.dateComponents([.hour, .minute], from: date)

        let daysOfWeek: [Int] = days

        for dayOfWeek in daysOfWeek {
            dateComponents.weekday = dayOfWeek

            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

            let identifier = "com.yourapp.notification.\(dayOfWeek)\(count)"
            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print("Error scheduling notification: \(error.localizedDescription)")
                } else {
                    print("Notification scheduled for \(dayOfWeek)")
                }
            }
        }
    }

    func stopNotifying(day: Int, count: Int) {
        let center = UNUserNotificationCenter.current()
        let identifier = "com.yourapp.notification.\(day)\(count)"
        center.removePendingNotificationRequests(withIdentifiers: [identifier])
    }
}
