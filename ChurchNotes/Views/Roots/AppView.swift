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
    @State private var selection: Int = 0
    @State private var isShaked = false

    @StateObject var manager = NotificationsManager()
    
    @EnvironmentObject var published: PublishedVariebles
    @EnvironmentObject var viewModel: AppViewModel
    
    var body: some View {
        ZStack(alignment: .bottom){
            TabView(selection: $published.currentTabView){
                
                RootView {
                    ItemView()
                        .accentColor(K.Colors.mainColor)
                        .searchable(text: $published.searchText,
                                    placement: .navigationBarDrawer(displayMode: .automatic),
                                    prompt: "search-name")
                        .toolbar(published.tabsAreHidden ? .hidden : .visible, for: .tabBar)
                        .tag(0)
                }
                
                if viewModel.currentUser?.role == "volunteer" || viewModel.currentUser?.role == "developer" || viewModel.currentUser?.role == "jedai"{
                    RootView{
                        SupportVolunteerList()
                            .accentColor(K.Colors.mainColor)
                            .toolbar(published.tabsAreHidden ? .hidden : .visible, for: .tabBar)
                            .tag(1)
                    }
                }
                RootView {
                    ProfileMainView()
                        .accentColor(K.Colors.mainColor)
                        .onAppear(perform: {
                            published.tabsAreHidden = false
                        })
                        .toolbar(published.tabsAreHidden ? .hidden : .visible, for: .tabBar)
                        .tag(2)
                }
                if published.currentTabView == 3{
                    RootView{
                        SettingsView()
                            .accentColor(K.Colors.mainColor)
                            .toolbar(published.tabsAreHidden ? .hidden : .visible, for: .tabBar)
                            .tag(3)
                    }
                }
            }
            .accentColor(accentColor ? Color.white : K.Colors.mainColor)
            if !published.tabsAreHidden{
                HStack(alignment: .top) {
                    CustomTabBarItem(iconName: "list.bullet.clipboard",
                                     label: listStr,
                                     selection: $published.currentTabView,
                                     tag: 0, doubleTag: 0, settings: false)
                    if viewModel.currentUser?.role == "volunteer" || viewModel.currentUser?.role == "developer" || viewModel.currentUser?.role == "jedai"{
                        CustomTabBarItem(iconName: "questionmark.diamond",
                                         label: supportStr,
                                         selection: $published.currentTabView,
                                         tag: 1, doubleTag: 1, settings: false)
                    }
                    CustomTabBarItem(iconName: "gearshape",
                                     label: settingsStr,
                                     selection: $published.currentTabView,
                                     tag: 2, doubleTag: 3, settings: true)
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
                .background{
//                    Color(K.Colors.background).opacity(0)
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
                                Image(systemName: "xmark.circle")
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
