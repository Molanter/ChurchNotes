//
//  IntDataModel.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 7/24/24.
//

import SwiftUI
import SwiftData

@Model
final class IntDataModel {
    @Attribute(.unique) var name: String
    var int: Int
    init(name: String, int: Int) {
        self.name = name
        self.int = int
    }
}
