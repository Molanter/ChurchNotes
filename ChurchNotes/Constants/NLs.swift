//
//  SettingsNLs.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 8/13/24.
//

import SwiftUI

struct SettingsNLs {
    @EnvironmentObject var viewModel: AppViewModel
    
    func deviceImage(_ name: String) -> String{
        var device = ""
        if name.contains("iPad") || name.contains("iPadOS") {
            device = "ipad"
        }else if name.contains("iPhone") || name.contains("iOS") {
            device = "iphone"
        }
        return device
    }
    
    var settingsNLsSectio1: [SettingsNLModel<AnyView>] {
        return [
            SettingsNLModel(name: "profile-info", info: "info-email-username", systemImage: "person", leading: false, destination: AnyView(CurrentPersonView())),
            SettingsNLModel(name: "account-settings", info: "change-password-email", systemImage: "gearshape", leading: false, destination: AnyView(AccountSettingsView())),
            SettingsNLModel(name: "devices", info: "devices-sessions-info", systemImage: deviceImage(K.deviceName), leading: true, destination: AnyView(DevicesView()))
        ]
    }
     var settingsNLsSectio2: [SettingsNLModel<AnyView>] {
        return [
            SettingsNLModel(name: "people", info: "all-people-favourite-deleted", systemImage: "person.3", leading: false, destination: AnyView(SettingsPeopleView())),
            SettingsNLModel(name: "notifications-title", info: "list-of-notifications", systemImage: /*viewModel.notificationArray.isEmpty ? "bell.badge" : */"bell", leading: true, destination: AnyView(NotificationsView())),
            SettingsNLModel(name: "achievements", info: "your-achievements-score", systemImage: "medal", leading: true, destination: AnyView(AchievementsMainView()))
        ]
    }
    var settingsNLsSectio3: [SettingsNLModel<AnyView>] {
        return [
            SettingsNLModel(name: "reminders", info: "reminders-link-info", systemImage: "calendar.badge.clock", leading: true, destination: AnyView(RemindersView())),
            SettingsNLModel(name: "appearance", info: "theme-color", systemImage: "paintbrush", leading: true, destination: AnyView(AppearanceView())),
            SettingsNLModel(name: "app-secure", info: "app-secure-info", systemImage: "lock", leading: true, destination: AnyView(AppSecureView()))
        ]
    }
    var settingsNLsSectio4: [SettingsNLModel<AnyView>] {
        return [
            SettingsNLModel(name: "aapp-support", info: "support-reports-questions", systemImage: "wrench.and.screwdriver", leading: true, destination: AnyView(SupportMainView())),
            SettingsNLModel(name: "app-privacy", info: "app-privacy-info", systemImage: "lock.shield", leading: true, destination: AnyView(WebView(urlString: "https://prayer-navigator.notion.site/App-Privacy-58bbd4fc83dd404f9f0999df6a587efa"))),
            SettingsNLModel(name: "app-information", info: "app-info-support", systemImage: "info.circle", leading: true, destination: AnyView(AppInfo())),
            SettingsNLModel(name: "nonprofit-support", info: "nonprofit-support-info", systemImage: "dollarsign.circle", leading: true, destination: AnyView(NonProfitSupport()))
        ]
    }
    
    var nlArray: [[SettingsNLModel<AnyView>]] {
        return [settingsNLsSectio1, settingsNLsSectio2, settingsNLsSectio3, settingsNLsSectio4]
    }
}
