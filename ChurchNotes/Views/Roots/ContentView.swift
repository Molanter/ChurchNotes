//
//  ContentView.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 6/28/23.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @EnvironmentObject var published: PublishedVariebles
    
    var body: some View {
        NavigationView {
            ItemView()
                .searchable(text: $published.searchText,
                            placement: .navigationBarDrawer(displayMode: .automatic),
                            prompt: "Search Name")
        }
    }
}

//#Preview {
//    ContentView()
//}
