//
//  PublishedVariebles.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 11/29/23.
//

import Foundation

class PublishedVariebles: ObservableObject{
    @Published var currentTabView = 0
    @Published var currentProfileMainView: Int?
    @Published var currentSettingsNavigationLink: String?
    @Published var currentPeopleNavigationLink: String?

    @Published var searchText = ""
    @Published var createPersonName = ""
    @Published var tabsAreHidden = false
    @Published var currentItem: Person?
    @Published var minute = 60
    @Published var sended = false
    @Published var findUserId: String?
    @Published var fcm = ""
    @Published var showEditProfileSheet = false
    @Published var currentBadge: Badge?

}
