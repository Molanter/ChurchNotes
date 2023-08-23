//
//  NotificationHandler.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 8/14/23.
//

import Foundation
import UserNotifications

class NotificationHandler {
    func askPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {

            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func stopNotifying(type: String){
        let center = UNUserNotificationCenter.current()

//        center.removeAllPendingNotificationRequests()
        center.removePendingNotificationRequests(withIdentifiers: [type])
    }
    
    func sendNotification(date: Date, type: String, timeInterval: Double = 10, title: String, body: String) {
        var trigger: UNNotificationTrigger?
        var type = ""
        // Create a trigger (either from date or time based)
        if type == "date" {
            type = "date"
            let dateComponents = Calendar.current.dateComponents([.day, .month, .year, .hour, .minute], from: date)
            trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        } else if type == "time" {
            type = "time"
            trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        } else if type == "everyDay"{
            type = "everyDay"
            let dateComponents = Calendar.current.dateComponents([.hour, .minute], from: date)
            trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        }
        // Customise the content
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.default
        
        // Create the request
        let request = UNNotificationRequest(identifier: type, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
}
