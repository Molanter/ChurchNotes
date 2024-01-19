//
//  Models.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 10/9/23.
//

import Foundation
import SwiftUI
import FirebaseFirestore

struct Users: Identifiable{
    var id: String{uid}
    var next, done, bloger: Int
    var uid,email, name, username, notes, country, profileImageUrl, phoneNumber, status, role, badge: String
    var profileImage: UIImage?
    init(data: [String: Any]){
        self.uid = data["uid"] as? String ?? ""
        self.email = data["email"] as? String ?? ""
        self.name = data["name"] as? String ?? ""
        self.username = data["username"] as? String ?? ""
        self.role = data["role"] as? String ?? ""
        self.notes = data["notes"] as? String ?? ""
        self.country = data["country"] as? String ?? ""
        self.profileImageUrl = data["profileImageUrl"] as? String ?? ""
        self.phoneNumber = data["phoneNumber"] as? String ?? ""
        self.status = data["status"] as? String ?? ""
        self.next = data["next"] as? Int ?? 0
        self.done = data["done"] as? Int ?? 0
        self.bloger = data["bloger"] as? Int ?? 0
        self.badge = data["badge"] as? String ?? ""
    }
}




struct Person: Identifiable {
    var id: String { documentId }
    let documentId: String
    var userId: [String]
    var name, notes, email, title, phone, imageData: String
    var orderIndex, titleNumber: Int
    let isCheked, isLiked, isDone: Bool
    let birthDay, timestamp: Date
    
    init(documentId: String, data: [String: Any], isLiked: Bool, orderIndex: Int) {
        self.documentId = documentId
        self.isLiked = isLiked
        self.orderIndex = orderIndex
        self.userId = data["userId"] as? [String] ?? []
        self.name = data["name"] as? String ?? ""
        self.notes = data["notes"] as? String ?? ""
        self.email = data["email"] as? String ?? ""
        self.title = data["title"] as? String ?? ""
        self.phone = data["phone"] as? String ?? ""
        self.imageData = data["imageData"] as? String ?? ""
        self.titleNumber = data["titleNumber"] as? Int ?? 0
        self.isCheked = data["isCheked"] as? Bool ?? false
        self.isDone = data["isDone"] as? Bool ?? false
        let bir = data["birthDay"] as? Timestamp ?? Timestamp()
        self.birthDay = bir.dateValue()
        let tim = data["timeStamp"] as? Timestamp ?? Timestamp()
        self.timestamp = tim.dateValue()
    }
}



struct Stage: Identifiable {
    var id: String { documentId }
    let documentId: String
    let userId, name, createBy: String
    var orderIndex: Int
    
    init(documentId: String, data: [String: Any]) {
        self.documentId = documentId
        self.userId = data["userId"] as? String ?? ""
        self.name = data["name"] as? String ?? ""
        self.orderIndex = data["orderIndex"] as? Int ?? 0
        self.createBy = data["createBy"] as? String ?? ""
    }
}

struct AppStage: Identifiable {
    var id: String { String(orderIndex) }
    var name, title: String
    var orderIndex: Int
    
    init(name: String, title: String, orderIndex: Int) {
        self.title = title
        self.name = name
        self.orderIndex = orderIndex
    }
}

struct Achievements: Identifiable {
    var id: String { documentId }
    let documentId: String
    let userId, name: String
    var int: Int
    
    init(documentId: String, data: [String: Any]) {
        self.documentId = documentId
        self.userId = data["userId"] as? String ?? ""
        self.name = data["name"] as? String ?? ""
        self.int = data["int"] as? Int ?? 0
    }
}

struct Notifics: Identifiable {
    var id: String { documentId }
    let documentId: String
    let userId, message: String
    var date: Date
    var sunday, monday, tuesday, wednsday, thursday, friday, saturday: Bool
    var orderIndex: Int
    
    init(documentId: String, data: [String: Any]) {
        self.documentId = documentId
        self.userId = data["userId"] as? String ?? ""
        self.message = data["message"] as? String ?? ""
        let tim = data["date"] as? Timestamp ?? Timestamp()
        self.date = tim.dateValue()
        self.sunday = data["sunday"] as? Bool ?? false
        self.monday = data["monday"] as? Bool ?? false
        self.tuesday = data["tuesday"] as? Bool ?? false
        self.wednsday = data["wednsday"] as? Bool ?? false
        self.thursday = data["thursday"] as? Bool ?? false
        self.friday = data["friday"] as? Bool ?? false
        self.saturday = data["saturday"] as? Bool ?? false
        self.orderIndex = data["orderIndex"] as? Int ?? 0
    }
}


struct AppLanguage: Identifiable {
    var id: String { String(orderIndex) }
    var name, short, image: String
    var orderIndex: Int
    
    init(name: String, short: String, image: String, orderIndex: Int) {
        self.name = name
        self.short = short
        self.image = image
        self.orderIndex = orderIndex
    }
}


struct SearchStages: Identifiable{
    var id: String { String(orderIndex) }
    var name: String
    var orderIndex: Int
    var people: [Person]
    
    init(name: String, orderIndex: Int, people: [Person]) {
        self.name = name
        self.orderIndex = orderIndex
        self.people = people
    }
}


struct Badge: Identifiable {
    var id: String { name }
    let name, image, string, color, strId: String
    
    init(name: String, image: String, string: String, color: String, strId: String) {
        self.name = name
        self.image = image
        self.string = string
        self.color = color
        self.strId = strId
    }
}

