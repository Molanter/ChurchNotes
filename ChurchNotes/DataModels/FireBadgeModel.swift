//
//  FireBadgeModel.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 7/24/24.
//

import Foundation

struct FireBadge {
    let name, image, string, color, strId, type: String
    
    init(documentId: String, data: [String: Any]) {
        self.name = data["name"] as? String ?? ""
        self.image = data["image"] as? String ?? ""
        self.string = data["string"] as? String ?? ""
        self.color = data["color"] as? String ?? ""
        self.strId = data["strId"] as? String ?? ""
        self.type = data["type"] as? String ?? ""
    }
}

extension FireBadge: Identifiable {
    var id: String { strId }
}
