//
//  InstructionView.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 7/21/24.
//

import SwiftUI

struct InstructionView: View {
    var body: some View {
        TabView {
            Text("1")
            Text("2")
            Text("3")
        }
        .tabViewStyle(.page(indexDisplayMode: .always))
        .indexViewStyle(.page(backgroundDisplayMode: .always))
        .foregroundStyle(K.Colors.mainColor)
    }
}

#Preview {
    InstructionView()
}
