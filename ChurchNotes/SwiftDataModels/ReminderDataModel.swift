//
//  ReminderDataModel.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 7/24/24.
//

import SwiftUI
import SwiftData

@Model
final class ReminderDataModel {
    var message: String
    var date: Date
    var sunday: Bool
    var monday: Bool
    var tuesday: Bool
    var wednsday: Bool
    var thursday: Bool
    var friday: Bool
    var saturday: Bool
    @Attribute(.unique) var orderIndex: Int
    init(message: String, date: Date, sunday: Bool, monday: Bool, tuesday: Bool, wednsday: Bool, thursday: Bool, friday: Bool, saturday: Bool, orderIndex: Int) {
        self.message = message
        self.date = date
        self.sunday = sunday
        self.monday = monday
        self.tuesday = tuesday
        self.wednsday = wednsday
        self.thursday = thursday
        self.friday = friday
        self.saturday = saturday
        self.orderIndex = orderIndex
    }
}
