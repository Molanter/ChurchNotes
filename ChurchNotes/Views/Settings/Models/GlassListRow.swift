//
//  GlassListRow.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 6/23/24.
//

import SwiftUI
import SwiftData

struct GlassListRow: View {
    @Environment(\.modelContext) var modelContext
    
    @Query var bools: [BoolDataModel]

    var people: Bool = false
    var blurListRow: Bool {
        if let boolModel = bools.first(where: { $0.name == "blurListRow" }) {
            return boolModel.bool
        }else {
            return false
        }
    }
    
    var body: some View {
        Group {
            if blurListRow {
                TransparentBlurView(removeAllFilters: true)
                    .blur(radius: 9, opaque: true)
                    .background(.textAppearance.opacity(0.2))
            }else {
                Color(K.Colors.rowBg)
            }
        }
    }
}

#Preview {
    GlassListRow()
}
