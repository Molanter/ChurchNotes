//
//  NotificationsInfo.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 11/22/23.
//

import SwiftUI

struct NotificationsInfo: View {
    var body: some View {
        VStack(alignment: .leading){
            Text("Note this!")
                .font(.title2)
                .bold()
                .foregroundStyle(.primary)
                .padding(.horizontal, 15)
            List{
                Section{
                    Text("Please **note** that messages is only workable for device on which they were made.")
                        .font(.body)
                        .foregroundStyle(.secondary)
                }
            }
            .listStyle(.grouped)
        }
        .padding(.top, 10)
    }
}

#Preview {
    NotificationsInfo()
}
