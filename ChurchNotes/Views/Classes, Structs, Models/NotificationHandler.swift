//
//  NotificationHandler.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 8/14/23.
//

import Foundation
import UserNotifications

class NotificationHandler {
    var viewModel = AppViewModel() 
    
    func askPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {

            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func stopNotifying(type: String, name: String = ""){
        let center = UNUserNotificationCenter.current()

//        center.removeAllPendingNotificationRequests()
        if name == ""{
            center.removePendingNotificationRequests(withIdentifiers: [type])
        }else{
            center.removePendingNotificationRequests(withIdentifiers: [name + type])
        }
    }
    
    
    func scheduleNotifications(days: [Int], message: String, date: Date, count: Int) {
        let content = UNMutableNotificationContent()
        content.title = "Pray Reminder"
        content.body = message == "" ? "Time to pray, take you time." : message

        // Create a date component for a specific time (e.g., 8:00 AM)
        var dateComponents = Calendar.current.dateComponents([.hour, .minute], from: date)

        // Schedule for Monday and Wednesday (you can add more days)
        let daysOfWeek: [Int] = days // 1 is Sunday, 2 is Monday, 3 is Tuesday, and so on

        for dayOfWeek in daysOfWeek {
            dateComponents.weekday = dayOfWeek

            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

            let identifier = "com.yourapp.notification.\(message)\(count)"

            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print("Error scheduling notification: \(error)")
                } else {
                    print("Notification scheduled for \(dayOfWeek)")
                }
            }
        }
    }

    func stopNotifiing(message: String, count: Int){
        let center = UNUserNotificationCenter.current()
        let identifier = "com.yourapp.notification.\(message)\(count)"
        center.removePendingNotificationRequests(withIdentifiers: [identifier])

    }
    
    func sendNotification(date: Date, type: String, timeInterval: Double = 10, title: String, body: String, name: String = "") {
        var trigger: UNNotificationTrigger?
        var typE = ""
        // Create a trigger (either from date or time based)
        print(type)
        if type == "date" {
            typE = "date"
            let dateComponents = Calendar.current.dateComponents([.day, .month, .year, .hour, .minute], from: date)
            trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        } else if type == "time" {
            typE = "time"
            trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        } else if type == "everyDay"{
            print(type)
            typE = "everyDay"
            let dateComponents = Calendar.current.dateComponents([.hour, .minute], from: date)
            trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        }else if type == "birthday"{
            typE = "birthday"
            let dateComponents = Calendar.current.dateComponents([.day, .month], from: date)
            trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        }
        // Customise the content
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.default
        
        // Create the request
        if name == ""{
            let request = UNNotificationRequest(identifier: typE, content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request)
            print("Name:  -  ~~")
        }else{
            let request = UNNotificationRequest(identifier: name + typE, content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request)
            print("Name:  -   \(name)")
        }
    }
}
