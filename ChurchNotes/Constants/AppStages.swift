//
//  AppStages.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 8/13/24.
//

import SwiftUI

struct AppStages{
    static let stagesArray: [AppStage] = [
        AppStage(name: String(localized: "nnew-friend"), title: "New Friend", orderIndex: 0),
        AppStage(name: String(localized: "iinvited"), title: "Invited", orderIndex: 1),
        AppStage(name: String(localized: "aattanded"), title: "Attended", orderIndex: 2),
        AppStage(name: String(localized: "aacepted-cchrist"), title: "Acepted Christ", orderIndex: 3),
        AppStage(name: String(localized: "bbaptized"), title: "Baptized", orderIndex: 4),
        AppStage(name: String(localized: "sserving"), title: "Serving", orderIndex: 5),
        AppStage(name: String(localized: "jjoined-ggroup"), title: "Joined Group", orderIndex: 6)
    ]
}
