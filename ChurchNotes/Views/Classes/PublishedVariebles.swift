//
//  PublishedVariebles.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 11/29/23.
//

import SwiftUI
import FirebaseAuth

class PublishedVariebles: ObservableObject{
    @Published var currentProfileMainView: Int?
    @Published var currentSettingsNavigationLink: String?
    @Published var currentPeopleNavigationLink: String?
    @Published var currentItem: Person?
    @Published var supportPersonChat: Users?
    @Published var currentBadge: Badge?
    @Published var findUserId: String?
        
    @Published var uid = Auth.auth().currentUser?.uid
    
    @Published var searchText = ""
    @Published var createPersonName = ""
    @Published var tabsAreHidden = false
    @Published var minute = 60
    @Published var sended = false
    @Published var fcm = ""
    @Published var showEditProfileSheet = false
    @Published var nowStage = 0
    @Published var currentTabView = 0
    @Published var deletePeopleArray = Set<Person.ID>()
    @Published var deleteCanceled = false
    @Published var isEditing = false
    @Published var currentTab = 0
}
