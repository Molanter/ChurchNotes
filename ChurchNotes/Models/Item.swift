//
//  Item.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 6/27/23.
//

import SwiftUI
import SwiftData

@Model
final class Items{
    var name: String
    var timestamp: Date
    var isCheked: Bool
    var isLiked: Bool
    var notes: String
    var imageData: Data?
    var email: String
    var birthDay: Date?
    var title: String
    var phone: String
    
    init(name: String, isLiked: Bool, isCheked: Bool, notes: String, imageData: Data? = nil, email: String, birthDay: Date?, title: String, phone: String) {
        self.timestamp = .now
        self.name = name
        self.isLiked = isLiked
        self.isCheked = isCheked
        self.notes = notes
        self.imageData = imageData
        self.email = email
        self.birthDay = birthDay
        self.title = title
        self.phone = phone
    }
    
    
}

@Model
final class ItemsTitle{
    @Attribute(.unique) var name: String
    var timeStamp: Date
    
    init(name: String, timeStamp: Date = Date.now) {
        self.name = name
        self.timeStamp = timeStamp
    }
    @Relationship(deleteRule: .cascade) var items: [Items]?
}

@Model
final class UserProfile {
    var cristian: Bool
    var name: String
    var phone: String
    var email: String
    var country: String
    var notes: String
    var profileImage: String
    var username: String
    var timeStamp: Date
    
    init(name: String, phoneNumber: String, email: String, cristian: Bool, notes: String, country: String, profileImage: String, username: String, timeStamp: Date) {
        self.name = name
        self.phone = phoneNumber
        self.email = email
        self.cristian = cristian
        self.notes = notes
        self.country = country
        self.profileImage = profileImage
        self.username = username
        self.timeStamp = timeStamp
    }
}


