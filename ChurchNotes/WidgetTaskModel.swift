//
//  WidgetTaskModel.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 7/1/23.
//

import SwiftUI
import SwiftData

class ChurchDataModel {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [InviteToChurchItem]
    
    
}
