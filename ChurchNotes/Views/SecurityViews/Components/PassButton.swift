//
//  PassButton.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 5/21/24.
//

import SwiftUI

struct PassButton: View {
    let number: String
    let letters: String
    let width: CGFloat
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .center, spacing: 0) {
                Text(number)
                    .font(.largeTitle)
                Text(letters)
                    .font(.headline)
            }
            .foregroundStyle(Color(K.Colors.text))
            .frame(width: width, height: width, alignment: .top)
            .padding(10)
            .background {
                TransparentBlurView(removeAllFilters: true)
                    .blur(radius: 9, opaque: true)
                    .background(Color(K.Colors.text).opacity(0.1))
                    .cornerRadius(7)
            }
            .clipShape(Circle())
        }
    }
}
