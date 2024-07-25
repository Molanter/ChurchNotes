//
//  AppView.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 6/28/23.
//

import SwiftUI
import FirebaseAuth

struct AppView: View {
    @State var listStr = String(localized: "list")
    @State var settingsStr = String(localized: "settings")
    @State var supportStr = String(localized: "ssupport")
    @State var accentColor = false
    @State private var isShaked = false

    @StateObject var manager = ReminderManager()
    
    @EnvironmentObject var published: PublishedVariebles
    @EnvironmentObject var viewModel: AppViewModel
    
    var body: some View {
        ZStack(alignment: .bottom){
            if published.device != .phone {
                ZStack {
                    if published.currentTabView == 0 {
                        RootView {
                                ItemView()
                                    .accentColor(K.Colors.mainColor)
                                    .searchable(text: $published.searchText,
                                                placement: .navigationBarDrawer(displayMode: .automatic),
                                                prompt: "search-name")
                                    .toolbar(published.tabsAreHidden ? .hidden : .visible, for: .tabBar)
                                    .tag(0)
                            }
                    }
                    
                    if 9 == 0 {
                        if viewModel.currentUser?.role == "volunteer" || viewModel.currentUser?.role == "developer" || viewModel.currentUser?.role == "jedai"{
                            RootView{
                                SupportVolunteerList()
                                    .accentColor(K.Colors.mainColor)
                                    .toolbar(published.tabsAreHidden ? .hidden : .visible, for: .tabBar)
                                    .tag(1)
                            }
                        }
                    }
                    if 5 == 6 {
                        RootView {
                            ProfileMainView()
                                .accentColor(K.Colors.mainColor)
                                .onAppear(perform: {
                                    published.tabsAreHidden = false
                                })
                                .toolbar(published.tabsAreHidden ? .hidden : .visible, for: .tabBar)
                                .tag(2)
                        }
                    }
                        if published.currentTabView == 3 {
                            RootView{
                                SettingsView()
                                    .accentColor(K.Colors.mainColor)
                                    .toolbar(published.tabsAreHidden ? .hidden : .visible, for: .tabBar)
                                    .tag(3)
                            }
                        }
                    if published.currentTabView == 4 {
                        RootView{
                            NotificationsView()
                                .accentColor(K.Colors.mainColor)
                                .toolbar(published.tabsAreHidden ? .hidden : .visible, for: .tabBar)
                                .tag(4)
                        }
                    }
                }
                .accentColor(accentColor ? Color.white : K.Colors.mainColor)
            }else {
                TabView(selection: $published.currentTabView) {
                    if published.currentTabView == 0 {
                        RootView {
                                ItemView()
                                    .accentColor(K.Colors.mainColor)
                                    .searchable(text: $published.searchText,
                                                placement: .navigationBarDrawer(displayMode: .automatic),
                                                prompt: "search-name")
                                    .toolbar(published.tabsAreHidden ? .hidden : .visible, for: .tabBar)
                                    .tag(0)
                            }
                    }
                    
                    if 9 == 0 {
                        if viewModel.currentUser?.role == "volunteer" || viewModel.currentUser?.role == "developer" || viewModel.currentUser?.role == "jedai"{
                            RootView{
                                SupportVolunteerList()
                                    .accentColor(K.Colors.mainColor)
                                    .toolbar(published.tabsAreHidden ? .hidden : .visible, for: .tabBar)
                                    .tag(1)
                            }
                        }
                    }
                    if 5 == 6 {
                        RootView {
                            ProfileMainView()
                                .accentColor(K.Colors.mainColor)
                                .onAppear(perform: {
                                    published.tabsAreHidden = false
                                })
                                .toolbar(published.tabsAreHidden ? .hidden : .visible, for: .tabBar)
                                .tag(2)
                        }
                    }
                        if published.currentTabView == 3 {
                            RootView{
                                SettingsView()
                                    .accentColor(K.Colors.mainColor)
                                    .toolbar(published.tabsAreHidden ? .hidden : .visible, for: .tabBar)
                                    .tag(3)
                            }
                        }
                    if published.currentTabView == 4 {
                        RootView{
                            NotificationsView()
                                .accentColor(K.Colors.mainColor)
                                .toolbar(published.tabsAreHidden ? .hidden : .visible, for: .tabBar)
                                .tag(4)
                        }
                    }
                }
                .accentColor(accentColor ? Color.white : K.Colors.mainColor)
            }
            if !published.tabsAreHidden{
                HStack(alignment: published.device == .phone ? .top : .center) {
                    CustomTabBarItem(iconName: "list.bullet.clipboard",
                                     label: listStr,
                                     selection: $published.currentTabView,
                                     tag: 0, doubleTag: [0], settings: false)
                     if 9 == 0 {
                        if viewModel.currentUser?.role == "volunteer" || viewModel.currentUser?.role == "developer" || viewModel.currentUser?.role == "jedai"{
                            CustomTabBarItem(iconName: "questionmark.diamond",
                                             label: supportStr,
                                             selection: $published.currentTabView,
                                             tag: 1, doubleTag: [1], settings: false)
                        }
                    }
                    CustomTabBarItem(iconName: "gearshape",
                                     label: settingsStr,
                                     selection: $published.currentTabView,
                                     tag: 3, doubleTag: [4], settings: true)
                    //                    CustomTabBarItem(iconName: "person.crop.circle",
                    //                                     label: "Contacts",
                    //                                     selection: $published.currentTabView,
                    //                                     tag: 2, settings: false)
                    //                CustomTabBarItem(iconName: "circle.grid.3x3.fill",
                    //                                 label: "Keypad",
                    //                                 selection: $published.currentTabView,
                    //                                 tag: 3)
                    //                CustomTabBarItem(iconName: "recordingtape",
                    //                                 label: "Voicemail",
                    //                                 selection: $published.currentTabView,
                    //                                 tag: 4)
                }
                .frame(height: 50)
                .frame(maxWidth: .infinity)
                .ignoresSafeArea(edges: .bottom)
                .background{
                    if published.device != .phone {
                        TransparentBlurView(removeAllFilters: true)
                            .ignoresSafeArea(edges: .all)
                            .blur(radius: 9, opaque: true)
                            .background(Color(K.Colors.blackAndWhite).opacity(0.2))
                    }
                }
                .opacity(published.tabsAreHidden ? 0 : 1)
            }
        }
        .onShake{
            self.isShaked.toggle()
        }
        .sheet(isPresented: $isShaked, content: {
            NavigationStack{
                ShakeReportView()
                    .toolbar{
                        ToolbarItem(placement: .topBarLeading){
                            Button(action: {
                                self.isShaked = false
                            }){
                                Text("cancel")
                            }
                        }
                    }
            }
            .presentationDetents([.medium])
            .accentColor(K.Colors.mainColor)
        })
    }
    
    
}


//#Preview {
//    AppView()
//}
