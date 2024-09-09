//
//  SmallViewForSelecting.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 9/5/24.
//

import SwiftUI

struct SmallViewForSelecting<Content: View>: View {
    var view: Content
    @Binding var isSelected: Bool
    var size: Int = 0
    var body: some View {
        VStack {
            view
                .frame(width: size == 0 ? 75 : 400, height: size == 0 ? 150 : 400)
                .cornerRadius(10)
                .overlay {
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(isSelected ? K.Colors.mainColor : Color.white, lineWidth: 5)
                }
                .padding(5)
            
            Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
//                .symbolEffect(.bounce, value: isSelected)
                .foregroundStyle(isSelected ? K.Colors.mainColor : .white)
        }
    }
}

//#Preview {
//    SmallViewForSelecting()
//}
