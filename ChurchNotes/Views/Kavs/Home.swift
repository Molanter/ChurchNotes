//
//  Home.swift
//  ScrollableIndicators
//
//  Created by Balaji Venkatesh on 19/04/24.
//

import SwiftUI

struct Home: View {
    /// View Properties
    @State private var tabs: [TabSlideModel] = [
        .init(id: TabSlideModel.Tab.newFriend),
        .init(id: TabSlideModel.Tab.invited),
        .init(id: TabSlideModel.Tab.attanded),
        .init(id: TabSlideModel.Tab.aceptedChrist),
        .init(id: TabSlideModel.Tab.baptized),
        .init(id: TabSlideModel.Tab.serving),
        .init(id: TabSlideModel.Tab.joinedGroup)
    ]
    @State private var activeTab: TabSlideModel.Tab = .newFriend
    @State private var tabBarScrollState: TabSlideModel.Tab?
    @State private var mainViewScrollState: TabSlideModel.Tab?
    @State private var progress: CGFloat = .zero
    var body: some View {
        VStack(spacing: 0) {
            CustomTabBar()
            
            GeometryReader {
                let size = $0.size
                
                ScrollView(.horizontal) {
                    LazyHStack(spacing: 0) {
                        ForEach(tabs) { tab in
                            AppPeopleList(stage: 1)
                        }
                    }
                    
                    .scrollTargetLayout()
                    .rect { rect in
                        progress = -rect.minX / size.width
                    }
                }
                .scrollPosition(id: $mainViewScrollState)
                .scrollIndicators(.hidden)
                .scrollTargetBehavior(.paging)
                .onChange(of: mainViewScrollState) { oldValue, newValue in
                    if let newValue {
                        withAnimation(.snappy) {
                            tabBarScrollState = newValue
                            activeTab = newValue
                        }
                    }
                }
            }
        }
    }
    /// Dynamic Scrollable Tab Bar
    @ViewBuilder
    func CustomTabBar() -> some View {
        ScrollView(.horizontal) {
            HStack(spacing: 20) {
                ForEach($tabs) { $tab in
                    Button(action: {
                        withAnimation(.snappy) {
                            activeTab = tab.id
                            tabBarScrollState = tab.id
                            mainViewScrollState = tab.id
                        }
                    }) {
                        Text(LocalizedStringKey(tab.id.rawValue))
                            .font(.footnote)
                            .fontWeight(.regular)
                            .padding(.vertical, 12)
                            .foregroundStyle(activeTab == tab.id ? K.Colors.mainColor : K.Colors.mainColor.opacity(0.5))
                            .contentShape(.rect)
                    }
                    .buttonStyle(.plain)
                    .rect { rect in
                        tab.size = rect.size
                        tab.minX = rect.minX
                    }
                }
            }
            .scrollTargetLayout()
        }
        .scrollPosition(id: .init(get: {
            return tabBarScrollState
        }, set: { _ in
            
        }), anchor: .center)
        .overlay(alignment: .bottom) {
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(.gray.opacity(0.3))
                    .frame(height: 1)
                    .padding(.horizontal, -15)
                
                let inputRange = tabs.indices.compactMap { return CGFloat($0) }
                let ouputRange = tabs.compactMap { return $0.size.width }
                let outputPositionRange = tabs.compactMap { return $0.minX }
                let indicatorWidth = progress.interpolate(inputRange: inputRange, outputRange: ouputRange)
                let indicatorPosition = progress.interpolate(inputRange: inputRange, outputRange: outputPositionRange)
                
                Rectangle()
                    .fill(.primary)
                    .frame(width: indicatorWidth, height: 1.5)
                    .offset(x: indicatorPosition)
            }
        }
        .safeAreaPadding(.horizontal, 15)
        .scrollIndicators(.hidden)
    }
}

