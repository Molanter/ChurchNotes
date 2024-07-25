//
//  BoolDataModel.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 5/10/24.
//

import SwiftUI
import SwiftData

@Model
final class BoolDataModel {
    @Attribute(.unique) var name: String
    var bool: Bool
    init(name: String, bool: Bool) {
        self.name = name
        self.bool = bool
    }
}
