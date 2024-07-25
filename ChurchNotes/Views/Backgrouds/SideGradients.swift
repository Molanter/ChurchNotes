//
//  SideGradients.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 7/1/24.
//

import SwiftUI
import SwiftData

struct SideGradients: View {
    @Environment(\.modelContext) var modelContext
    
    @Query var colors: [ColorDataModel]
    
    @State var pickerColorL1 = Color.cyan
    @State var pickerColorL2 = Color.yellow
    @State var pickerColorR1 = Color.green
    @State var pickerColorR2 = Color.red
    var body: some View {
        ZStack {
            LeftSidePath()
                .fill(
                    .linearGradient(colors: [
                        pickerColorL1,
                        pickerColorL2
                    ], startPoint: .top, endPoint: .bottom)
                )
//                .frame(width: 140, height: 140)
//                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
//                .offset(x: -25, y: -55)
            
            RightSidePath()
                .fill(
                    .linearGradient(colors: [
                        pickerColorR1,
                        pickerColorR2
                    ], startPoint: .top, endPoint: .bottom)
                )
//                .frame(width: 140, height: 140)
//                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
//                .offset(x: 25, y: 55)
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
                pickerColorR2 = Color.red
            }
        }
    }
}

//#Preview {
//    SideGradients()
//}
