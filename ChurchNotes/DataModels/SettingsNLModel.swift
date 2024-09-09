//
//  SettingsNLModel.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 8/13/24.
//

import SwiftUI

struct SettingsNLModel<Destination: View>: Hashable {
    let name, info, systemImage: String
    let leading: Bool
    let destination: Destination
    
    init(name: String, info: String, systemImage: String, leading: Bool, destination: Destination) {
        self.name = name
        self.info = info
        self.systemImage = systemImage
        self.leading = leading
        self.destination = destination
    }

    // Custom hash function that excludes `destination`
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(info)
        hasher.combine(systemImage)
        hasher.combine(leading)
    }

    static func == (lhs: SettingsNLModel<Destination>, rhs: SettingsNLModel<Destination>) -> Bool {
        return lhs.name == rhs.name &&
               lhs.info == rhs.info &&
               lhs.systemImage == rhs.systemImage &&
               lhs.leading == rhs.leading
    }
}
