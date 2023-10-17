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
    
    func stopNotifying(type: String, name: String = ""){
        let center = UNUserNotificationCenter.current()

//        center.removeAllPendingNotificationRequests()
        if name == ""{
            center.removePendingNotificationRequests(withIdentifiers: [type])
        }else{
            center.removePendingNotificationRequests(withIdentifiers: [name + type])
        }
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
