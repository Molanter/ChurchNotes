//
//  CustomTabBarItem.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 11/15/23.
//

import SwiftUI

struct CustomTabBarItem: View {
    @EnvironmentObject var published: PublishedVariebles
    @EnvironmentObject var viewModel: AppViewModel
    
    let iconName: String
    let label: String
    let selection: Binding<Int> // 1
    let tag: Int // 2
    let doubleTag: Int // 2
    let settings: Bool
    
    @State private var backDegree = 0.0
    @State private var frontDegree = 0.0
    @State private var angle: Double = 0
    @State private var logoutAlert = false
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            ZStack{
                if settings{
                    if selection.wrappedValue == tag || selection.wrappedValue == doubleTag{
                        Image(systemName: "\(iconName).fill")
                            .rotation3DEffect(Angle(degrees: frontDegree), axis: (x: 0, y: 0, z: 1))
                            .frame(minWidth: 25, minHeight: 25)
                    }else{
                        Image(systemName: iconName)
                            .rotation3DEffect(Angle(degrees: backDegree), axis: (x: 0, y: 0, z: 1))
                            .frame(minWidth: 25, minHeight: 25)
                    }
                }else{
                    Image(systemName: selection.wrappedValue == tag  || selection.wrappedValue == doubleTag ? "\(iconName).fill" : iconName)
                        .frame(minWidth: 25, minHeight: 25)
                        .contentTransition(.symbolEffect(.replace.byLayer))
                }
            }
            .onChange(of: selection.wrappedValue){
                if settings{
                    withAnimation(.linear(duration: 0.3)){
                        backDegree = 90
                    }
                    if selection.wrappedValue == tag || selection.wrappedValue == doubleTag {
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
        //        .padding([.top], 5)
        .foregroundColor(fgColor())
        .frame(maxWidth: .infinity)
        .contentShape(Rectangle())
        .onTapGesture(count: 2, perform: {
                if tag == 0{
                    self.selection.wrappedValue = self.tag
                    published.currentTab = 0
                    published.nowStage = K.choosedStages == 0 ? 1 : 0
                    print("double tap")
                }else{
                    self.selection.wrappedValue = self.doubleTag
                    print("double tap")
                }
        })
        .onTapGesture(count: 1, perform: {
            self.selection.wrappedValue = self.tag
            print("single tap")
        })
        .contextMenu {
                if tag == 0{
                    Button{
                        published.currentTab = 0
                        K.choosedStages = 0
                        published.nowStage = 0
                        self.selection.wrappedValue = 0
                    }label: {
                        Text("app-stages")
                    }
                    Button{
                        published.currentTab = 0
                        K.choosedStages = 1
                        published.nowStage = 1
                        self.selection.wrappedValue = 0
                    }label: {
                        Text("my-stages")
                    }
                }
                if tag == 2{
                    Text(viewModel.currentUser?.email ?? "")
                    Button{
                        self.selection.wrappedValue = 3
                    }label: {
                        Label("settings", systemImage: "gearshape")
                    }
                    Button(role: .destructive) {
                        self.logoutAlert.toggle()
                    }label: {
                        Label("logout", systemImage: "rectangle.portrait.and.arrow.right")
                            .foregroundStyle(Color.red)
                    }
                }
        }//preview: {
        //            VStack {
        //                Image(systemName: "\(iconName).fill")
        //                    .frame(minWidth: 25, minHeight: 25)
        //                Text(label)
        //                    .font(.caption)
        //            }
        //        .foregroundStyle(K.Colors.mainColor)
        //        }
        .actionSheet(isPresented: $logoutAlert) {
            ActionSheet(title: Text("logout"),
                        message: Text("are-you-sure"),
                        buttons: [
                            .cancel(),
                            .destructive(
                                Text("yes")
                            ){
                                self.logoutAlert.toggle()
                                viewModel.logOut()
                                viewModel.deleteFcmToken(token: published.fcm)
                            }
                        ]
            )
        }
    }
    
    private func fgColor() -> Color {
        return selection.wrappedValue == tag || selection.wrappedValue == doubleTag ? K.Colors.mainColor : Color(K.Colors.gray)
    }
}
