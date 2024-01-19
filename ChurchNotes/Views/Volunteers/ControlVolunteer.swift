//
//  ControlVolunteer.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 12/24/23.
//

import SwiftUI

struct ControlVolunteer: View {
    @State var selection: Int = 0
    
    var body: some View {
        NavigationStack{
                VStack{
                    Picker(selection: $selection) {
                        Text("rroles").tag(0)
                        Text("bblock").tag(1)
                    } label: {
                        Text("vview")
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal, 15)
                    TabView(selection: $selection){
                        ScrollView{
                            Volunteer()
                        }.tag(0)
                        ScrollView{
                            BlockUserView()
                        }.tag(1)
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                }
            .navigationTitle(String(localized: "manage-users"))
        }
    }
}

#Preview {
    ControlVolunteer()
}
