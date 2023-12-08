//
//  CustomTabBarItem.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 11/15/23.
//

import SwiftUI

struct CustomTabBarItem: View {
    let iconName: String
    let label: String
    let selection: Binding<Int> // 1
    let tag: Int // 2
    let settings: Bool
    @State var backDegree = 0.0
    @State var frontDegree = 0.0
    @State private var angle: Double = 0
    
    var body: some View {
        VStack(alignment: .center) {
            ZStack{
                if settings{
                    if selection.wrappedValue == tag{
                        Image(systemName: "\(iconName).fill")
                            .rotation3DEffect(Angle(degrees: frontDegree), axis: (x: 0, y: 0, z: 1))
                            .frame(minWidth: 25, minHeight: 25)
                    }else{
                        Image(systemName: iconName)
                            .rotation3DEffect(Angle(degrees: backDegree), axis: (x: 0, y: 0, z: 1))
                            .frame(minWidth: 25, minHeight: 25)
                    }
                }else{
                    Image(systemName: selection.wrappedValue == tag ? "\(iconName).fill" : iconName)
                        .frame(minWidth: 25, minHeight: 25)
                        .contentTransition(.symbolEffect(.replace))
                }
            }
            .onChange(of: selection.wrappedValue){
                if settings{
                    withAnimation(.linear(duration: 0.3)){
                        backDegree = 90
                    }
                    if selection.wrappedValue == tag {
                        withAnimation(.linear(duration: 0.3)/*.delay(0.3)*/){
                            frontDegree = 90
                        }
                    } else {
                        withAnimation(.linear(duration: 0.3)) {
                            frontDegree = 0
                        }
                        withAnimation(.linear(duration: 0.3)/*.delay(0.3)*/){
                            backDegree = 0
                        }
                    }
                }else{
                    
                }
            }
            Text(label)
                .font(.caption)
        }
        .padding([.top], 5)
        .foregroundColor(fgColor()) // 4
        .frame(maxWidth: .infinity)
        .contentShape(Rectangle())
        .onTapGesture {
            self.selection.wrappedValue = self.tag // 3
        }
    }
    
    private func fgColor() -> Color {
        return selection.wrappedValue == tag ? Color(K.Colors.mainColor) : Color(K.Colors.gray)
    }
}
