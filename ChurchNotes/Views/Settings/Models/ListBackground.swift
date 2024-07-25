//
//  ListBackground.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 6/23/24.
//

import SwiftUI
import SwiftData

struct ListBackground: View {
    @Environment(\.modelContext) var modelContext
    
    @Query var strings: [StringDataModel]

    var backgroundType: String {
        if let strModel = strings.first(where: { $0.name == "backgroundType" }) {
            return strModel.string
        }else {
            return "none"
        }
    }
    
    var body: some View {
        Group {
            if backgroundType == "" || backgroundType == "none" {
                Color(K.Colors.listBg)
            }else if backgroundType == "2Circles" {
                Circles2()
                    .background(Color(K.Colors.listBg))
            }else if backgroundType == "ColorSplash" {
                ColorSplash()
            }else if backgroundType == "SideGradient" {
                SideGradients()
            }
        }
    }
}

#Preview {
    ListBackground()
}
