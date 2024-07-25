//
//  StageModel.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 7/24/24.
//

import Foundation

struct Stage {
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

extension Stage: Identifiable {
    var id: String { documentId }
}
