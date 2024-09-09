//
//  PeopleSplitView.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 5/26/24.
//

import SwiftUI
import AVFoundation

struct PeopleSplitView: View {
    @EnvironmentObject var viewModel: AppViewModel
    @EnvironmentObject var published: PublishedVariebles

    @State var columns: NavigationSplitViewVisibility = .doubleColumn
    @State private var logoutAlert = false
    @State var showAddPersonView = false

    private var sortedAppStages: [AppStage]{
        return AppStages.stagesArray.sorted(by: { $0.orderIndex < $1.orderIndex })
    }
    private var sortedStages: [Stage]{
        return viewModel.stagesArray.sorted(by: { $0.orderIndex < $1.orderIndex })
    }
    private var itemTitles: String{
        return published.nowStage == 0 ? sortedAppStages[published.currentTab].title : (sortedStages.isEmpty ? "" : sortedStages[published.currentTab].name)
        
    }
    private var filteredItems: [Person] {
        return viewModel.peopleArray.filter { $0.title.contains(itemTitles) }.sorted(by: { $0.orderIndex < $1.orderIndex }).sorted(by: { $0.isLiked && !$1.isLiked })
    }
    
    @State private var preferredColumn =
    NavigationSplitViewColumn.content
    
    var body: some View {
        NavigationSplitView(columnVisibility: $columns, preferredCompactColumn: $preferredColumn) {
            List {
                Section{
                      Button {
                          published.currentTab = 0
                          K.choosedStages = 0
                          published.nowStage = 0
                          published.currentTabView = 0
                          preferredColumn =
                          NavigationSplitViewColumn.content
                      }label: {
                          Text("app-stages")
                              .foregroundStyle(K.Colors.mainColor)
                      }
                      Button{
                          published.currentTab = 0
                          K.choosedStages = 1
                          published.nowStage = 1
                          published.currentTabView = 0
                          preferredColumn =
                          NavigationSplitViewColumn.content
                      }label: {
                          Text("my-stages")
                              .foregroundStyle(K.Colors.mainColor)
                      }
                  } header: {
                    Text("People List")
                }
                Section {
                      Button{
                          published.currentTabView = 3
                          preferredColumn =
                          NavigationSplitViewColumn.content
                      }label: {
                          Label("settings", systemImage: "gearshape")
                              .foregroundStyle(K.Colors.mainColor)
                      }
                      Button(role: .destructive) {
                          self.logoutAlert.toggle()
                      }label: {
                          Label("logout", systemImage: "rectangle.portrait.and.arrow.right")
                              .foregroundStyle(Color.red)
                      }
                      .confirmationDialog("", isPresented: $logoutAlert, titleVisibility: .hidden) {
                                       Button("logout", role: .destructive) {
                                           self.logoutAlert.toggle()
                                           viewModel.logOut()
                                           viewModel.deleteFcmToken(token: published.fcm)
                                       }
                                       Button("cancel", role: .cancel) {
                                       }
                                  }
                  } header: {
                    Text("settings")
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("PrayerNavigator 🙏")
            .navigationBarTitleDisplayMode(.large)
        }content: {
            AppView()
                .navigationSplitViewColumnWidth(min: 500, ideal: 700, max: 900)
        } detail: {
            if let person = published.currentSplitItem {
                ItemPersonView(item: person, currentItem: $published.currentSplitItem)
            }else {
                Text("Select person")
            }
        }
        .navigationViewStyle(.automatic)
        .toolbar(removing: .sidebarToggle)
        .navigationSplitViewStyle(.balanced)
        .accentColor(Color(K.Colors.text))
    }
}

//#Preview {
//    PeopleSplitView()
//}
