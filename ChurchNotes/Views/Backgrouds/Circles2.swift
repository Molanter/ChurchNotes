//
//  Circles2.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 6/23/24.
//

import SwiftUI
import SwiftData

struct Circles2: View {
    @Environment(\.modelContext) var modelContext
    
    @Query var colors: [ColorDataModel]
    
    @State var pickerColorL1 = Color.cyan
    @State var pickerColorL2 = Color.yellow
    @State var pickerColorR1 = Color.green
    @State var pickerColorR2 = Color.red

    var body: some View {
        GeometryReader { gr in
            let d = gr.size.width / 2.5
            
            ZStack {
                Circle()
                    .fill(
                        .linearGradient(colors: [
                            pickerColorL1,
                            pickerColorL2
                        ], startPoint: .top, endPoint: .bottom)
                    )
                    .frame(width: d, height: d)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                    .offset(x: -15, y: -55)
                
                Circle()
                    .fill(
                        .linearGradient(colors: [
                            pickerColorR1,
                            pickerColorR2
                        ], startPoint: .top, endPoint: .bottom)
                    )
                    .frame(width: d, height: d)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                    .offset(x: 15, y: 55)
            }
            .padding()
            .padding(.vertical, 50)
        }
        .onAppear {
            if let colorModel = colors.first(where: { $0.name == "backColorL" }) {
                pickerColorL1 = Color(red: colorModel.color1.red, green: colorModel.color1.green, blue: colorModel.color1.blue, opacity: colorModel.color1.alpha)
                pickerColorL2 = Color(red: colorModel.color2.red, green: colorModel.color2.green, blue: colorModel.color2.blue, opacity: colorModel.color2.alpha)
            }else {
                pickerColorL1 = Color.cyan
                pickerColorL2 = Color.yellow
            }
            if let colorModel = colors.first(where: { $0.name == "backColorR" }) {
                pickerColorR1 = Color(red: colorModel.color1.red, green: colorModel.color1.green, blue: colorModel.color1.blue, opacity: colorModel.color1.alpha)
                pickerColorR2 = Color(red: colorModel.color2.red, green: colorModel.color2.green, blue: colorModel.color2.blue, opacity: colorModel.color2.alpha)
            }else {
                pickerColorR1 = Color.green
                pickerColorR2 = Color.yellow
            }
        }
    }
}

//#Preview {
//    Circles2()
//}
