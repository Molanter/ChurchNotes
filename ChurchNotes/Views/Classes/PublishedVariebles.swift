//
//  PublishedVariebles.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 11/29/23.
//

import Foundation

class PublishedVariebles: ObservableObject{
    @Published var searchText = ""
    @Published var createPersonName = ""
    @Published var tabsAreHidden = false
    @Published var currentItem: Person?
}
