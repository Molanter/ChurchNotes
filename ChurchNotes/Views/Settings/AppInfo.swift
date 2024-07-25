//
//  AppInfo.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 5/20/24.
//

import SwiftUI
import SwiftData

struct AppInfo: View {
    @Query var strings: [StringDataModel]

    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    let paypalString: String = "[PayPal](https://www.paypal.me/PrayerNavigatorApp)"
    let buymeacoffeeString = "[Buy Coffee for PrayerNavigator team](https://buymeacoffee.com/prayernavigatorcommand)"
    let siteString = "[Site](https://prayer-navigator.notion.site/36bd5a8fe75e411b911e6b123de23359?v=1ab709b38a0c4c2dbe960bd1265eaf1b&pvs=4)"

    var backgroundType: String {
        if let strModel = strings.first(where: { $0.name == "backgroundType" }) {
            return strModel.string
        }else {
            return "none"
        }
    }
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    VStack(alignment: .leading) {
                        Text("App icon:")
                            .font(.caption)
                        AppIcon()
                            .frame(width: 50, height: 50)
                            .cornerRadius(8)
                    }
                    VStack(alignment: .leading) {
                        Text("App name:")
                            .font(.caption)
                        Text("PrayerNavigator")
                            .bold()
                    }
                    VStack(alignment: .leading) {
                        Text("App version:")
                            .font(.caption)
                        Text(appVersion ?? "")
                            .bold()
                    }
                    VStack(alignment: .leading) {
                        Text("Audience:")
                            .font(.caption)
                        Text("Christians")
                            .bold()
                    }
                    VStack(alignment: .leading) {
                        Text("Age category:")
                            .font(.caption)
                        Text("4+")
                            .bold()
                    }
                    VStack(alignment: .leading) {
                        Text("App languages:")
                            .font(.caption)
                        Text("English, Ukrainian")
                            .bold()
                    }
                    VStack(alignment: .leading) {
                        Text("Copyright:")
                            .font(.caption)
                        Text("2024 © molanter Inc")
                            .bold()
                    }
                }header: {
                    Text("App Information")
                }
                .listRowBackground(
                    GlassListRow()
                )
                Section {
                    Text("The app reminds Christians to pray for people for their salvation.")
                    Text("PrayerNavigator empowers Christians to navigate their prayer journey, making it a purposeful and organized experience.")
                }header: {
                    Text("Main idea")
                }
                .listRowBackground(
                    GlassListRow()
                )
                Section {
                    Text("PrayerNavigator is a dedicated app for Christians, designed to guide and remind them to pray for the salvation of individuals. Organize your prayers with customizable lists and stages, ensuring daily commitment to intercessory prayer.")
                } header: {
                    Text("App Statement")
                }
                .listRowBackground(
                    GlassListRow()
                )
                Section {
                    Text(try! AttributedString(markdown: siteString))
                }header: {
                    Text("Links")
                }
                .listRowBackground(
                    GlassListRow()
                )
                Section {
                    Text("**PrayerNavigator** is more than just an app; it's a community-driven platform dedicated to fostering spiritual connection and support. Developed by a sole developer with a passion for aiding others on their spiritual journey, PrayerNavigator is completely nonprofit and offered to users free of charge. Behind the scenes, we utilize Firebase database technology, which we independently fund, and maintain an Apple Developer account to ensure seamless integration with iOS devices. Every feature and update is crafted with the intention of enriching your prayer experience, guided by our commitment to accessibility and inclusivity.")
//                    Text(try! AttributedString(markdown: paypalString))
//                    Text(try! AttributedString(markdown: buymeacoffeeString))
//                    NavigationLink(destination: NonProfitSupport()) {
//                        Text("mmore")
//                    }
                }header: {
//                    Text("app-nonprofit-support")
                }footer: {
                    if let appVersion = appVersion {
                        HStack {
                            Spacer()
                            Text("version \(appVersion) 2024 © molanter Inc")
                            Spacer()
                        }
                    }
                }
                .listRowBackground(
                    GlassListRow()
                )
            }
            .scrollContentBackground(backgroundType == "none" ? .visible : .hidden)
            .background {
                ListBackground()
            }
            .navigationTitle("app-information")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

#Preview {
    AppInfo()
}
