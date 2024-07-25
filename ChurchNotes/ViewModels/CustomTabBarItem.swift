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
    let selection: Binding<Int>
    let tag: Int
    let doubleTag: [Int]
    let settings: Bool
    
    @State private var backDegree = 0.0
    @State private var frontDegree = 0.0
    @State private var angle: Double = 0
    @State private var logoutAlert = false
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            if published.device != .phone {
                Spacer()
            }
            ZStack{
                if settings{
                    if selection.wrappedValue == tag || doubleTag.contains(selection.wrappedValue) {
                        Image(systemName: "\(iconName).fill")
                            .rotation3DEffect(Angle(degrees: frontDegree), axis: (x: 0, y: 0, z: 1))
                            .aspectRatio(contentMode: .fit)
                            .frame(minWidth: 30, minHeight: 30)
                            .overlay(viewModel.notificationArray.isEmpty ? nil : BadgeCount(count: viewModel.notificationArray.count).padding(.trailing, 6).padding(.top, 3))
                    }else{
                        Image(systemName: iconName)
                            .rotation3DEffect(Angle(degrees: backDegree), axis: (x: 0, y: 0, z: 1))
                            .aspectRatio(contentMode: .fit)
                            .frame(minWidth: 30, minHeight: 30)
                            .overlay(viewModel.notificationArray.isEmpty ? nil : BadgeCount(count: viewModel.notificationArray.count).padding(.trailing, 6).padding(.top, 3))
                    }
                }else{
                    Image(systemName: selection.wrappedValue == tag  || doubleTag.contains(selection.wrappedValue) ? "\(iconName).fill" : iconName)
                        .aspectRatio(contentMode: .fit)
                        .frame(minWidth: 30, minHeight: 30)
                        .contentTransition(.symbolEffect(.replace.byLayer))
                }
            }
            .onChange(of: selection.wrappedValue){
                if settings{
                    withAnimation(.linear(duration: 0.3)){
                        backDegree = 90
                    }
                    if selection.wrappedValue == tag || doubleTag.contains(selection.wrappedValue) {
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
                .font(published.device != .phone ? .caption : .footnote)
        }
        .foregroundColor(fgColor())
        .padding(5)
        .contentShape(RoundedRectangle(cornerRadius: 10))
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
                if tag == 3{
                    Text(viewModel.currentUser?.email ?? "")
                    Section {
                        Button{
                            self.selection.wrappedValue = 4
                            published.currentSettingsNavigationLink = nil
                        }label: {
                            Label("notifications-title", systemImage: "bell")
                        }
                        Button{
                            self.selection.wrappedValue = 3
                            published.currentSettingsNavigationLink = nil
                        }label: {
                            Label("settings", systemImage: "gearshape")
                        }
                    }
                    Button(role: .destructive) {
                        self.logoutAlert.toggle()
                    }label: {
                        Label("logout", systemImage: "rectangle.portrait.and.arrow.right")
                            .foregroundStyle(Color.red)
                    }
                }
        }
        .frame(maxWidth: .infinity)
//        .onTapGesture(count: 2, perform: {
//                if tag == 0{
//                    self.selection.wrappedValue = self.tag
//                    published.currentTab = 0
//                    published.nowStage = K.choosedStages == 0 ? 1 : 0
//                    print("double tap")
//                }else{
//                    self.selection.wrappedValue = self.doubleTag.first ?? self.tag
//                    print("double tap")
//                }
//        })
        .onTapGesture(count: 1, perform: {
            self.selection.wrappedValue = self.tag
            published.currentSettingsNavigationLink = nil
        })
        .confirmationDialog("", isPresented: $logoutAlert, titleVisibility: .hidden) {
                         Button("logout", role: .destructive) {
                             self.logoutAlert.toggle()
                             viewModel.logOut()
                             viewModel.deleteFcmToken(token: published.fcm)
                         }
                         Button("cancel", role: .cancel) {
                         }
                    }
    }
    
    private func fgColor() -> Color {
        return selection.wrappedValue == tag || doubleTag.contains(selection.wrappedValue) ? K.Colors.mainColor : Color.secondary
    }
}
