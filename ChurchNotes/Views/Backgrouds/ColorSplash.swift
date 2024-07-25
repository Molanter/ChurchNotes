//
//  ColorSplash.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 7/1/24.
//

import SwiftUI

struct ColorSplash: View {
    var body: some View {
        GeometryReader { gr in
            let w = gr.size.width / 1.5
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Image("LogoPng")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: w)
                    Spacer()
                }
                Spacer()
            }
        }
        
    }
}

#Preview {
    ColorSplash()
}
