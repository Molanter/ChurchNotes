//
//  SearchSlider.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 12/7/23.
//

import SwiftUI

struct SearchSlider: View {
    @State var stages = String(localized: "sstages")
    @State var people = String(localized: "people")
    @State var favourite = String(localized: "favourite")
    @State var notification = String(localized: "notifications")

    @Binding var currentTab: Int
    @Namespace var namespace

    var body: some View {
        ScrollView(.horizontal){
            HStack(spacing: 0){
//                SearchSliderItem(currentTab: $currentTab,
//                           namespace: namespace.self,
//                           tabBarItemName: stages,
//                           tab: 0)
//                .onTapGesture {
//                        withAnimation{
//                            currentTab = 0
//                        }
//                    }
                SearchSliderItem(currentTab: $currentTab,
                           namespace: namespace.self,
                           tabBarItemName: people,
                           tab: 1)
                .onTapGesture {
                        withAnimation{
                            currentTab = 1
                        }
                    }
                SearchSliderItem(currentTab: $currentTab,
                           namespace: namespace.self,
                           tabBarItemName: favourite,
                           tab: 2)
                .onTapGesture {
                        withAnimation{
                            currentTab = 2
                        }
                    }
                SearchSliderItem(currentTab: $currentTab,
                           namespace: namespace.self,
                           tabBarItemName: notification,
                           tab: 3)
                .onTapGesture {
                        withAnimation{
                            currentTab = 4
                        }
                    }
//                SearchSliderItem(currentTab: $currentTab,
//                           namespace: namespace.self,
//                           tabBarItemName: "Friends",
//                           tab: 3)
//                .onTapGesture {
//                        withAnimation{
//                            currentTab = 3
//                        }
//                    }
            }
        }
        .padding(.horizontal, 15)
        .frame(height: 40)
    }
}


struct SearchSliderItem: View {
    @Binding var currentTab: Int
    let namespace: Namespace.ID
    
    var tabBarItemName: String
    var tab: Int
    
    var body: some View {
        Button {
            withAnimation{
                self.currentTab = tab
            }
        } label: {
            VStack {
                Spacer()
                Text(tabBarItemName)
                    .font(.system(size: 13))
                    .fontWeight(.regular)
                    .foregroundStyle(currentTab == tab ? Color(K.Colors.mainColor) : .secondary)
                    .padding(.horizontal, 10)
                if currentTab == tab {
                    Color(K.Colors.mainColor)
                        .frame(height: 5)
                        .matchedGeometryEffect(id: "underline",
                                               in: namespace,
                                               properties: .frame)
                        .cornerRadius(.infinity)
                } else {
                    Color.clear
                        .opacity(0.5)
                        .frame(height: 5)
                }
            }
            .animation(.spring(), value: self.currentTab)
        }
        .buttonStyle(.plain)
    }
}
//#Preview {
//    SearchSlider()
//}
