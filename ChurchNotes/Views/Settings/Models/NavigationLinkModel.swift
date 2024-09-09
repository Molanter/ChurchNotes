//
//  SettingsNavigationLink.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 6/3/24.
//

import SwiftUI
import SwiftData

struct NavigationLinkModel: View {
    @EnvironmentObject var published: PublishedVariebles
    @EnvironmentObject var viewModel: AppViewModel

    @Query var ints: [IntDataModel]

//    let destination: Destination
    let name: String
    let info: String
    let systemImageName: String
//    let currentSettingsNavigationLink: String
    let leading: Bool
    
    var color: Color {
        switch name {
        case "profile-info":
            return Color(K.Colors.pink)
        case "account-settings":
            return Color(K.Colors.orange)
        case "devices":
            return Color(K.Colors.yellow)
        case "people":
            return Color(K.Colors.bluePurple)
        case "notifications-title":
            return Color(K.Colors.red)
        case "achievements":
            return Color(K.Colors.darkBlue)
        case "reminders":
            return Color.cyan
        case "appearance":
            return Color.black
        case "app-secure":
            return Color(K.Colors.green)
        case "aapp-support":
            return Color(K.Colors.blue)
        case "app-privacy":
            return Color.brown
        case "app-information":
            return Color(K.Colors.lightBlue)
        case "nonprofit-support":
            return Color.black
        default:
            return Color.black
        }
    }
    
    var rowStyle: Int {
        if let intModel = ints.first(where: { $0.name == "rowStyle" }) {
            return intModel.int
        }else {
            return 0
        }
    }
    
    var body: some View {
        VStack{
//            NavigationLink(destination: destination
//                .onAppear(perform: {
//                    if published.device == .phone {
//                        published.tabsAreHidden = true
//                    }
//                })
//                    .navigationBarTitleDisplayMode(.inline),
//                           isActive: Binding(
//                             get: { published.currentSettingsNavigationLink == currentSettingsNavigationLink },
//                             set: { newValue in
//                                  published.currentSettingsNavigationLink = newValue ? currentSettingsNavigationLink : nil
//                              }
//                           )
//            ){
                if rowStyle == 1 {
                    AppleStyleNL(name: name, color: color, systemImageName: systemImageName)
                }else {
                    DefaultStyleNL(name: name, info: info, systemImageName: systemImageName)
                }
//            }
        }
    }
}


//#Preview {
//    NavigationLinkModel()
//}
