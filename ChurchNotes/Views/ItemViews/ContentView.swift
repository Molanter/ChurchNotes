//
//  ContentView.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 6/28/23.
//

import SwiftUI
import SwiftData

//struct ContentView: View {
//    @Query (sort: \ItemsTitle.timeStamp, order: .forward, animation: .spring) var itemTitles: [ItemsTitle]
//    @State var currentTab: Int = 0
//    var body: some View {
//        VStack (spacing: 0){
//            TopBarView(currentTab: self.$currentTab)
//
//            TabView(selection: self.$currentTab) {
//
//                ItemView(itemTitles: itemTitles[currentTab]).tag(currentTab)
//            }
//            .tabViewStyle(.page(indexDisplayMode: .never))
//        }
//    }
//}
//
//#Preview {
//    ContentView()
//        .environmentObject(AppViewModel())
//        .modelContainer(for: [UserProfile.self, Items.self, ItemsTitle.self])
//}
