//
//  GifCacheModel.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 7/24/24.
//

import SwiftUI
import SwiftData

@Model
final class GifCacheModel {
    @Attribute(.unique) var name: String
    var data: Data
    init(name: String, data: Data) {
        self.name = name
        self.data = data
    }
}
