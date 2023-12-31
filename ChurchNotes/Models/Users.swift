//
//  Users.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 10/9/23.
//

import Foundation
import SwiftUI
import FirebaseFirestore

struct Users: Identifiable{
    var id: String{uid}
    
    var uid,email, name, username, notes, country, profileImageUrl, phoneNumber, status: String
    var profileImage: UIImage?
    init(data: [String: Any]){
        self.uid = data["uid"] as? String ?? ""
        self.email = data["email"] as? String ?? ""
        self.name = data["name"] as? String ?? ""
        self.username = data["username"] as? String ?? ""
        self.notes = data["notes"] as? String ?? ""
        self.country = data["country"] as? String ?? ""
        self.profileImageUrl = data["profileImageUrl"] as? String ?? ""
        self.phoneNumber = data["phoneNumber"] as? String ?? ""
        self.status = data["status"] as? String ?? ""
    }
}




struct Person: Identifiable{
    var id: String { documentId}
    let documentId: String
    var userId, name, notes, email, title, phone, imageData: String
    var orderIndex: Int
    let isCheked, isLiked, isDone: Bool
    let birthDay, timestamp: Date
    init(documentId: String, data: [String: Any]){
        self.documentId = documentId
        self.userId = data["userId"] as? String ?? ""
        self.name = data["name"] as? String ?? ""
        self.notes = data["notes"] as? String ?? ""
        self.email = data["email"] as? String ?? ""
        self.title = data["title"] as? String ?? ""
        self.phone = data["phone"] as? String ?? ""
        self.imageData = data["imageData"] as? String ?? ""
        self.orderIndex = data["orderIndex"] as? Int ?? 0
        self.isCheked = data["isCheked"] as? Bool ?? false
        self.isLiked = data["isLiked"] as? Bool ?? false
        self.isDone = data["isDone"] as? Bool ?? false
        let bir = data["birthDay"] as? Timestamp ?? Timestamp()
        self.birthDay = bir.dateValue()
        let tim = data["timestamp"] as? Timestamp ?? Timestamp()
        self.timestamp = tim.dateValue()
    }
}



struct Stage: Identifiable {
    var id: String { documentId }
    let documentId: String
    let userId, name: String
    var orderIndex: Int
    
    init(documentId: String, data: [String: Any]) {
        self.documentId = documentId
        self.userId = data["userId"] as? String ?? ""
        self.name = data["name"] as? String ?? ""
        self.orderIndex = data["orderIndex"] as? Int ?? 0
    }
}

