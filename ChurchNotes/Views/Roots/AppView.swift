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
    @State var name = "name"
    @State var phone = "+1234567890"
    @State var email = "email@gmail.com"
    @State var cristian = true
    @State var showingEditingProfile = false
    @State var width = false
    @State var username = ""
    @State var country = ""
    @State var notes = ""
    @State var notificationTime = Date.now
    @State var notifications = false
    @State var image: UIImage?
    @State var profileImage = ""
    @State var timeStamp = Date.now
    @State var showImagePicker = false
    @State var errReg = ""
    @State var documentId = ""
    @State var logoutAlert = false
    @State var accentColor = false
    @State var firebaseError = false
    @State var firebaseErr = ""
    @State var bigPhoto = false
    var auth = Auth.auth()
    @State private var selection: Int = 0
    
    @StateObject var manager = NotificationsManager()
    
    @EnvironmentObject var published: PublishedVariebles
    @EnvironmentObject var viewModel: AppViewModel
    @EnvironmentObject var networkMonitor: NetworkMonitor
    
    var body: some View {
        ZStack(alignment: .bottom){
            TabView(selection: $published.currentTabView){
                
                RootView {
                    ItemView()
                        .searchable(text: $published.searchText,
                                    placement: .navigationBarDrawer(displayMode: .automatic),
                                    prompt: "search-name")
                        .tag(0)
                }
                //                    .tabItem {
                //                        Label(listStr, systemImage: "list.bullet.clipboard")
                //                    }
                RootView {
                    ProfileMainView()
                        .onAppear(perform: {
                            published.tabsAreHidden = false
                        })
                        .tag(1)
                }
                //                    .tabItem {
                //                        Label(settingsStr, systemImage: "gearshape")
                //                    }
            }
            .accentColor(accentColor ? Color.white : Color(K.Colors.mainColor))
            if !published.tabsAreHidden{
                HStack(alignment: .top) {
                    CustomTabBarItem(iconName: "list.bullet.clipboard",
                                     label: listStr,
                                     selection: $published.currentTabView,
                                     tag: 0, settings: false)
                    CustomTabBarItem(iconName: "gearshape",
                                     label: settingsStr,
                                     selection: $published.currentTabView,
                                     tag: 1, settings: true)
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
                .background(Color(K.Colors.background).opacity(0))
                .opacity(published.tabsAreHidden ? 0 : 1)
            }
        }
        
    }
    
    
}


#Preview {
    AppView()
}


