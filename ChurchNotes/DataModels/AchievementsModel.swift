//
//  AchievementsModel.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 7/24/24.
//

import Foundation

struct Achievements {
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

extension Achievements: Identifiable {
    var id: String { documentId }
}
