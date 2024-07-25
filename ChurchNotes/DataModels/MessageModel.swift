//
//  MessageModel.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 7/24/24.
//

import Foundation
import FirebaseFirestore

struct MessageModel {
    let documentId: String
    let from, to, type, image, message: String
    var time: Date
    var reviewed: Bool
    
    init(documentId: String, data: [String: Any]) {
        self.documentId = documentId
        self.from = data["from"] as? String ?? ""
        self.message = data["message"] as? String ?? ""
        self.to = data["to"] as? String ?? ""
        self.type = data["type"] as? String ?? ""
        self.image = data["image"] as? String ?? ""
        self.reviewed = data["reviewed"] as? Bool ?? false
        let tim = data["date"] as? Timestamp ?? Timestamp()
        self.time = tim.dateValue()
        
    }
}

extension MessageModel: Identifiable {
    var id: String { documentId }
}
