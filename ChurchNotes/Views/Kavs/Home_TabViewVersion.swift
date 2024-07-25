//
//  Home_TabViewVersion.swift
//  ScrollableIndicators
//
//  Created by Balaji Venkatesh on 19/04/24.
//

import SwiftUI

struct Home_TabViewVersion: View {
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
    @State private var progress: CGFloat = .zero
    @State private var isDragging: Bool = false
    @State private var delayTask: DispatchWorkItem?
    var body: some View {
        VStack(spacing: 0) {
            CustomTabBar()
            
            /// Main View
            GeometryReader {
                let size = $0.size
                
                TabView(selection: $activeTab) {
//                    ForEach{
                        Text("Hello")
                            .tag(TabSlideModel.Tab.newFriend)
                            /// It's Must to set the view with the size
                            .frame(width: size.width, height: size.height)
                            .rect { tabProgress(.newFriend, rect: $0, size: size) }
//                    }
                    
//                    Text("Deployment")
//                        .tag(TabSlideModel.Tab.deployment)
//                        .frame(width: size.width, height: size.height)
//                        .rect { tabProgress(.deployment, rect: $0, size: size) }
//                    
//                    Text("Analytics")
//                        .tag(TabSlideModel.Tab.analytics)
//                        .frame(width: size.width, height: size.height)
//                        .rect { tabProgress(.analytics, rect: $0, size: size) }
//                    
//                    Text("Audience")
//                        .tag(TabSlideModel.Tab.audience)
//                        .frame(width: size.width, height: size.height)
//                        .rect { tabProgress(.audience, rect: $0, size: size) }
//                    
//                    Text("Privacy")
//                        .tag(TabSlideModel.Tab.privacy)
//                        .frame(width: size.width, height: size.height)
//                        .rect { tabProgress(.privacy, rect: $0, size: size) }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .allowsHitTesting(!isDragging)
                .onChange(of: activeTab) { oldValue, newValue in
                    guard tabBarScrollState != newValue else { return }
                    withAnimation(.snappy) {
                        tabBarScrollState = newValue
                    }
                }
            }
        }
    }
    
    func tabProgress(_ tab: TabSlideModel.Tab, rect: CGRect, size: CGSize) {
        if let index = tabs.firstIndex(where: { $0.id == activeTab }), activeTab == tab, !isDragging {
            let offsetX = rect.minX - (size.width * CGFloat(index))
            progress = -offsetX / size.width
        }
    }
    /// Dynamic Scrollable Tab Bar
    @ViewBuilder
    func CustomTabBar() -> some View {
        ScrollView(.horizontal) {
            HStack(spacing: 20) {
                ForEach($tabs) { $tab in
                    Button(action: {
                        delayTask?.cancel()
                        delayTask = nil
                        
                        isDragging = true
                        
                        withAnimation(.easeInOut(duration: 0.3)) {
                            activeTab = tab.id
                            tabBarScrollState = tab.id
                            progress = CGFloat(tabs.firstIndex(where: { $0.id == tab.id }) ?? 0)
                        }
                        
                        delayTask = .init { isDragging = false }
                        
                        if let delayTask { DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: delayTask) }
                    }) {
                        Text(tab.id.rawValue)
                            .fontWeight(.medium)
                            .padding(.vertical, 12)
                            .foregroundStyle(activeTab == tab.id ? Color.primary : .gray)
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

