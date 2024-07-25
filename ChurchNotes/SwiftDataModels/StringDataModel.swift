//
//  StringDataModel.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 7/24/24.
//

import SwiftUI
import SwiftData

@Model
final class StringDataModel {
    @Attribute(.unique) var name: String
    var string: String
    init(name: String, string: String) {
        self.name = name
        self.string = string
    }
}
