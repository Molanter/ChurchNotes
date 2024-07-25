//
//  SettingsNavigationLink.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 6/3/24.
//

import SwiftUI
import SwiftData

struct NavigationLinkModel<Destination: View>: View {
    @EnvironmentObject var published: PublishedVariebles
    @EnvironmentObject var viewModel: AppViewModel

    @Query var ints: [IntDataModel]

    let destination: Destination
    let name: String
    let info: String
    let systemImageName: String
    let currentSettingsNavigationLink: String
    let leading: Bool
    
    var color: Color {
        switch name {
        case String(localized: "profile-info"):
            return Color(K.Colors.pink)
        case String(localized: "account-settings"):
            return Color(K.Colors.orange)
        case String(localized: "devices"):
            return Color(K.Colors.yellow)
        case String(localized: "people"):
            return Color(K.Colors.bluePurple)
        case String(localized: "notifications-title"):
            return Color(K.Colors.red)
        case String(localized: "achievements"):
            return Color(K.Colors.darkBlue)
        case String(localized: "reminders"):
            return Color.cyan
        case String(localized: "appearance"):
            return Color.black
        case String(localized: "app-secure"):
            return Color(K.Colors.green)
        case String(localized: "aapp-support"):
            return Color(K.Colors.blue)
        case String(localized: "app-privacy"):
            return Color.brown
        case String(localized: "app-information"):
            return Color(K.Colors.lightBlue)
        case String(localized: "nonprofit-support"):
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
            NavigationLink(destination: destination
                .onAppear(perform: {
                    if published.device == .phone {
                        published.tabsAreHidden = true
                    }
                })
                    .navigationBarTitleDisplayMode(.inline),
                           isActive: Binding(
                             get: { published.currentSettingsNavigationLink == currentSettingsNavigationLink },
                             set: { newValue in
                                  published.currentSettingsNavigationLink = newValue ? currentSettingsNavigationLink : nil
                              }
                           )
            ){
                if rowStyle == 1 {
                    HStack(spacing: 20) {
                        ZStack(alignment: .center) {
                            RoundedRectangle(cornerRadius: 5)
                                .fill(name == String(localized: "appearance") ? .linearGradient(colors: [
                                    .bluePurple,
                                    .yelloww
                                ], startPoint: .topLeading, endPoint: .bottomTrailing) : .linearGradient(colors: [
                                    color,
                                    color
                                ], startPoint: .top, endPoint: .bottom))
                                .frame(width: 30, height: 30)
                            Image(systemName: systemImageName)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .foregroundStyle(Color.white)
                                .frame(width: 20, height: 20)
                                .padding(.leading, currentSettingsNavigationLink == "reminders" ? 3 : 0)
                        }
                        Text(name)
                            .font(.body)
                    }
                    .badge(name == String(localized: "notifications-title") ? viewModel.notificationArray.count : 0)
                }else {
                    HStack(alignment: .top, spacing: currentSettingsNavigationLink == "people" ? 15 : 29){
                        if currentSettingsNavigationLink == "notifications" {
                            if viewModel.notificationArray.isEmpty {
                                Image(systemName: viewModel.notificationArray.isEmpty ? "bell.badge" : "bell")
                                    .overlay(viewModel.notificationArray.isEmpty ? nil : BadgeCount(count: viewModel.notificationArray.count).padding(.trailing, 8))
                                    .symbolRenderingMode(.palette)
                                    .foregroundStyle(Color(K.Colors.mainColor), Color(K.Colors.text))
                                    .font(.system(size: 29))
                                    .fontWeight(.light)
                            }else {
                                Image(systemName: systemImageName)
                                    .overlay(viewModel.notificationArray.isEmpty ? nil : BadgeCount(count: viewModel.notificationArray.count).padding(.trailing, 8))
                                    .symbolRenderingMode(.palette)
                                    .foregroundStyle(Color(K.Colors.text))
                                    .font(.system(size: 29))
                                    .fontWeight(.light)
                            }
                        }else if currentSettingsNavigationLink == "reminders" {
                            Image(systemName: systemImageName)
                                .symbolRenderingMode(.palette)
                                .foregroundStyle(published.currentSettingsNavigationLink == "reminders" ? Color(K.Colors.text) : K.Colors.mainColor, Color(K.Colors.text))
                                .font(.system(size: 29))
                                .fontWeight(.light)
                        }else if currentSettingsNavigationLink == "people" {
                            Image(systemName: systemImageName)
                                .font(.system(size: 25))
                                .fontWeight(.light)
                        }else {
                            Image(systemName: systemImageName)
                                .font(.system(size: 29))
                                .fontWeight(.light)
                        }
                        VStack(alignment: .leading, spacing: 5){
                            Text(name)
                                .fontWeight(.semibold)
                                .font(.subheadline)
                                .foregroundStyle(.primary)
                            Text(info)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(.leading, leading ? 4 : 0)
                }
            }
        }
    }
}


//#Preview {
//    NavigationLinkModel()
//}
