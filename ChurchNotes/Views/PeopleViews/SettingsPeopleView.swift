//
//  SettingsPeopleView.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 8/30/23.
//

import SwiftUI
import SwiftData

struct SettingsPeopleView: View {
    @EnvironmentObject var viewModel: AppViewModel
    @EnvironmentObject var published: PublishedVariebles
    
    @Query var strings: [StringDataModel]

    @State private var searchText = ""
    @State private var currentItem: Person?
    @State private var lastItem: Person?
    
    let notify = ReminderHandler()
    
    var backgroundType: String {
        if let strModel = strings.first(where: { $0.name == "backgroundType" }) {
            return strModel.string
        }else {
            return "none"
        }
    }
    
    var body: some View{
        NavigationStack{
            List{
                Section {
                    PeopleLink(destination: AllPeopleView(), name: String(localized: "all-people"), info: "list-of-all-people", systemImageName: "person.2", currentPeopleNavigationLink: "allpeople-view", leading: false)
                    PeopleLink(destination: AllStagesView(), name: String(localized: "all-your-stages"), info: "list-of-all-stages", systemImageName: "folder", currentPeopleNavigationLink: "allstages-view", leading: true)
                    if viewModel.peopleArray.filter({ $0.isDone}).count > 0{
                        PeopleLink(destination: DonePeople(), name: String(localized: "done-people"), info: "list-of-people-that-joined-group", systemImageName: "person.fill.checkmark", currentPeopleNavigationLink: "donepeople-view", leading: true)
                    }
                    PeopleLink(destination: LikedPeopleView(), name: String(localized: "favourite-people"), info: "list-of-favourite-people", systemImageName: "\(K.favouriteSign)", currentPeopleNavigationLink: "likedpeople-view", leading: true)
                }
                .listRowBackground(
                    GlassListRow()
                )
            }
            .scrollContentBackground(backgroundType == "none" ? .visible : .hidden)
            .background {
                ListBackground()
            }
            .accentColor(Color(K.Colors.lightGray))
            .navigationTitle("people")
            .navigationBarTitleDisplayMode(.large)
        }
        .background(
            Color(K.Colors.listBg)
        )
    }
}

#Preview {
    SettingsPeopleView()
}
