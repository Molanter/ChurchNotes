//
//  BadgeModel.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 7/24/24.
//

import Foundation

struct Badge {
    let name, image, string, color, strId, type: String
    
    init(name: String, image: String, string: String, color: String, strId: String, type: String) {
        self.name = name
        self.image = image
        self.string = string
        self.color = color
        self.strId = strId
        self.type = type
    }
}

extension Badge: Identifiable {
    var id: String { name }
}
