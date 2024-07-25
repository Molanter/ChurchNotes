//
//  LastMessageModel.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 7/24/24.
//

import Foundation
import FirebaseFirestore

struct LastMessageModel {
    let documentId: String
    var message, profileImage, name, type, uid: String
    var time: Date
    var image: Bool
    
    init(documentId: String, data: [String: Any]) {
        self.documentId = documentId
        self.message = data["message"] as? String ?? ""
        self.profileImage = data["profileImage"] as? String ?? ""
        self.name = data["name"] as? String ?? ""
        self.type = data["type"] as? String ?? ""
        self.uid = data["uid"] as? String ?? ""
        self.image = data["image"] as? Bool ?? false
        let tim = data["date"] as? Timestamp ?? Timestamp()
        self.time = tim.dateValue()
        
    }
}

extension LastMessageModel: Identifiable {
    var id: String { documentId }
}
