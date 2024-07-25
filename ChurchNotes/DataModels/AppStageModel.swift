//
//  AppStageModel.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 7/24/24.
//

import Foundation

struct AppStage {
    var name, title: String
    var orderIndex: Int
    var size: CGSize = .zero
    var minX: CGFloat = .zero
    
    init(name: String, title: String, orderIndex: Int) {
        self.title = title
        self.name = name
        self.orderIndex = orderIndex
    }
}

extension AppStage: Identifiable {
    var id: String { String(orderIndex) }
}
