//
//  NonProfitSupport.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 5/20/24.
//

import SwiftUI
import SwiftData

struct NonProfitSupport: View {
    @Query var strings: [StringDataModel]

    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    let paypalString: String = "[PayPal](https://www.paypal.me/PrayerNavigatorApp)"
    let buymeacoffeeString = "[PrayerNavigator team](https://buymeacoffee.com/prayernavigatorteam)"

    @State var copiedBitcoin = false
    @State var copiedEthereum = false
    @State private var progress = 0
    
    private var prog: Float {
        return Float(progress) / 100
    }
    
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
                    VStack(spacing: 10) {
                        HStack {
                            Text("Donors collected this month")
                                .font(.title2)
                                .bold()
                            Spacer()
                        }
                        ProgressView(value: prog)
                            .accentColor(K.Colors.mainColor)
                        HStack {
                            Text("\(progress)%")
                                .foregroundStyle(.secondary)
                            Spacer()
                            Text("goal 25$")
                                .foregroundStyle(.secondary)
                        }
                        Label("Be a Donor", systemImage: "dollarsign.circle")
                            .foregroundStyle(Color.white)
                            .padding(10)
                            .frame(maxWidth: .infinity)
                            .background(K.Colors.mainColor)
                            .cornerRadius(10)
                            .onTapGesture {
                                if let url = URL(string: "https://www.paypal.me/PrayerNavigatorApp") {
                                            UIApplication.shared.open(url)
                                        }
                            }
                    }
                }header: {
                    Text("This month support")
                }
                .listRowBackground(
                    GlassListRow()
                )
                Section {
                    Text("**PrayerNavigator** is more than just an app; it's a community-driven platform dedicated to fostering spiritual connection and support. Developed by a sole developer with a passion for aiding others on their spiritual journey, PrayerNavigator is completely nonprofit and offered to users free of charge. Behind the scenes, we utilize Firebase database technology, which we independently fund, and maintain an Apple Developer account to ensure seamless integration with iOS devices. Every feature and update is crafted with the intention of enriching your prayer experience, guided by our commitment to accessibility and inclusivity.")
                }header: {
                    Text("aabout-support")
                }
                .listRowBackground(
                    GlassListRow()
                )
                Section {
                    Text("• Firebase (database)")
                    Text("• Apple Developer account (publish app)")
                    Text("• Site Hosting")
                }header: {
                    Text("App Spendings")
                }footer: {
                    Text("The PrayerNavigator app team consists of a small group of 1-10 people who volunteer their time and effort to work on the app for free.")
                }
                .listRowBackground(
                    GlassListRow()
                )
                Section {
                    Text(try! AttributedString(markdown: paypalString))
                }header: {
                    Text("Links")
                }footer: {
                    Text("We are very grateful for your support of our app!")
                }
                .listRowBackground(
                    GlassListRow()
                )
                Section {
                    Text(try! AttributedString(markdown: buymeacoffeeString))
                }header: {
                    Text("BuyMeACoffee")
                        .textCase(.none)
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
//                Section {
//                    VStack(alignment: .leading) {
//                        HStack(spacing: 5) {
//                            Text("Bitcoin:")
//                                .bold()
//                            Spacer()
//                            Text(copiedBitcoin ? "copied!" : "copy")
//                        }
//                        Text("bc1qpzm25xmmsu8xa63kufft3urysazhqh0wyxy5a2")
//                            .multilineTextAlignment(.leading)
//                            .lineLimit(1)
//                    }
//                    .onTapGesture {
//                        UIPasteboard.general.string = "bc1qpzm25xmmsu8xa63kufft3urysazhqh0wyxy5a2"
//                        withAnimation {
//                            copiedBitcoin = true
//                            copiedEthereum = false
//                        }
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
//                            withAnimation { copiedBitcoin = false }
//                        }
//                    }
//                    VStack(alignment: .leading) {
//                        HStack(spacing: 5) {
//                            Text("Ethereum:")
//                                .bold()
//                            Spacer()
//                            Text(copiedEthereum ? "copied!" : "copy")
//                        }
//                        Text("0x7Cd155894a801DE0153B014724b67B5a57c107C9")
//                            .multilineTextAlignment(.leading)
//                            .lineLimit(1)
//                    }
//                    .onTapGesture {
//                        UIPasteboard.general.string = "0x7Cd155894a801DE0153B014724b67B5a57c107C9"
//                        withAnimation {
//                            copiedEthereum = true
//                            copiedBitcoin = false
//                        }
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
//                            withAnimation { copiedEthereum = false }
//                        }
//                    }
//                }header: {
//                    Text("Crypto")
//                }
            }
            .scrollContentBackground(backgroundType == "none" ? .visible : .hidden)
            .background {
                ListBackground()
            }
            .navigationTitle("app-nonprofit-support")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

#Preview {
    NonProfitSupport()
}
