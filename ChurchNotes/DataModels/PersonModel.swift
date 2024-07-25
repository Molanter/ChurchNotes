//
//  PersonModel.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 7/24/24.
//

import Foundation
import FirebaseFirestore

struct Person: Hashable {
    let documentId: String
    var userId: [String]
    var name, notes, email, title, phone, imageData: String
    var orderIndex, titleNumber: Int
    var isCheked, isLiked, isDone: Bool
    var birthDay, timestamp: Date
    
    init(documentId: String, data: [String: Any], isLiked: Bool, orderIndex: Int, userId: [String]) {
        self.documentId = documentId
        self.isLiked = isLiked
        self.orderIndex = orderIndex
        self.userId = userId
        print(userId)
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

extension Person: Identifiable {
    var id: String { documentId }
}
