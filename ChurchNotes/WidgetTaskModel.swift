//
//  WidgetTaskModel.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 7/1/23.
//

import SwiftUI
import SwiftData

struct ChurchDataModel: Identifiable{
    var id: ObjectIdentifier
    
    @Environment(\.modelContext) var modelContext
    @Query var items: [ItemsTitle]
    
    
}
