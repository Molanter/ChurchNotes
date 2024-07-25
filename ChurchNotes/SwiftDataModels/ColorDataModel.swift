//
//  ColorDataModel.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 7/24/24.
//

import SwiftUI
import SwiftData

@Model
final class ColorDataModel {
    @Attribute(.unique) var name: String
    var color1: ColorModelRGBA
    var color2: ColorModelRGBA
    init(name: String, color1: ColorModelRGBA, color2: ColorModelRGBA) {
        self.name = name
        self.color1 = color1
        self.color2 = color2
    }
}
