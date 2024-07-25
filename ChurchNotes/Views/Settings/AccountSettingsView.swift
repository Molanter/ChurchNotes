//
//  AccountSettingsView.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 11/13/23.
//

import SwiftUI
import SwiftData

struct AccountSettingsView: View {
    @Query var strings: [StringDataModel]

    //    @EnvironmentObject var published: PublishedVariebles
    @State var showEdit = false
    
    var backgroundType: String {
        if let strModel = strings.first(where: { $0.name == "backgroundType" }) {
            return strModel.string
        }else {
            return "none"
        }
    }
    
    var body: some View {
        List{
            Section {
                AccountSettingsLink(destination: ChangePasswordView(), name: String(localized: "change-password"), info: "old-password-new-password", systemImageName: "lock.shield")
                AccountSettingsLink(destination: ChangeEmailView(), name: String(localized: "change-email"), info: "current-password-new-email", systemImageName: "envelope.badge.shield.half.filled")
                AccountSettingsLink(destination: EditProfileView(showingEditingProfile: $showEdit), name: String(localized: "edit-profile"), info: "change-name-username-phone", systemImageName: "square.and.pencil")
                AccountSettingsLink(destination: DeleteAccountView(), name: String(localized: "delete-account-view"), info: "delete-account-view-info", systemImageName: "person.crop.circle.badge.xmark")
            }
            .listRowBackground(
                GlassListRow()
            )
        }
        .scrollContentBackground(backgroundType == "none" ? .visible : .hidden)
        .background {
            ListBackground()
        }
        .accentColor(Color(K.Colors.lightGray))
    .navigationTitle("account-settings")
    .navigationBarTitleDisplayMode(.large)
    }
}

//#Preview {
//    AccountSettingsView()
//}
