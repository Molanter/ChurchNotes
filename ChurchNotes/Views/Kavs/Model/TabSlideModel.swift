//
//  TabModel.swift
//  ScrollableIndicators
//
//  Created by Balaji Venkatesh on 19/04/24.
//

import SwiftUI

struct TabSlideModel: Identifiable {
    private(set) var id: Tab
    var size: CGSize = .zero
    var minX: CGFloat = .zero
    
    enum Tab: String, CaseIterable {
        case newFriend = "new-friend"
        case invited = "iinvited"
        case attanded = "aattanded"
        case aceptedChrist = "aacepted-cchrist"
        case baptized = "bbaptized"
        case serving = "sserving"
        case joinedGroup = "jjoined-ggroup"
    }
}
