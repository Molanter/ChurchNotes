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

            Text("note-this")
                .font(.title2)
                .bold()
                .foregroundStyle(.primary)
                .padding(.horizontal, 15)
            List{
                Section{
                    Text("please-note-that-messages-is-only-for-device")
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
