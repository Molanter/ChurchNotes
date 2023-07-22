//
//  BottomTabBar.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 7/19/23.
//

import Foundation
import SwiftUI

struct BottomBarView: View {
    @Binding var currentTab: Int
    var body: some View {
        HStack(spacing: 10) {
            Spacer()
            BottomBarItem(currentTab: $currentTab,
                          tabBarItemImage: "list.bullet.clipboard",
                          tabBarItemName: "Notes",
                          tab: 0)
            Spacer()
            BottomBarItem(currentTab: $currentTab,
                          tabBarItemImage: "gearshape",
                          tabBarItemName: "Settings",
                          tab: 1)
            .padding(.top, 5)
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(Color(K.Colors.background))
        .padding(.horizontal, 15)
    }
}

struct BottomBarItem: View {
    @Binding var currentTab: Int
    
    var tabBarItemImage: String
    var tabBarItemName: String
    var tab: Int
    
    var body: some View {
        Button {
            self.currentTab = tab
        } label: {
            VStack {
                Image(systemName: tab == currentTab ? "\(tabBarItemImage).fill" : tabBarItemImage)
                    .foregroundStyle(currentTab == tab ? Color(K.Colors.mainColor) : Color(K.Colors.lightGray))
                    .font(.system(size: 20))
                Text(tabBarItemName)
                    .font(.system(size: 15))
                    .fontWeight(.regular)
                    .foregroundStyle(currentTab == tab ? Color(K.Colors.mainColor) : Color(K.Colors.lightGray))
                    .padding(3)
                Spacer()
            }
            .padding(.top, 2)
            .animation(.spring(), value: self.currentTab)
        }
        .buttonStyle(.plain)
    }
}
