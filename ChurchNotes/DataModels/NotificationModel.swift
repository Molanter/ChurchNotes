//
//  NotificationModel.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 10/9/23.
//

import SwiftUI
import FirebaseFirestore

struct NotificationModel: Identifiable {
    var id: String { documentId }
    let documentId: String
    var message, type, to, from: String
    var date: Date
    var people: [String]
    
    init(documentId: String, data: [String: Any]) {
        self.documentId = documentId
        self.message = data["message"] as? String ?? ""
        self.type = data["type"] as? String ?? ""
        self.to = data["to"] as? String ?? ""
        self.people = data["people"] as? [String] ?? []
        self.from = data["from"] as? String ?? ""
        let tim = data["date"] as? Timestamp ?? Timestamp()
        self.date = tim.dateValue()
        
    }
}
