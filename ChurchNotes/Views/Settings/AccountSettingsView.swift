//
//  AccountSettingsView.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 11/13/23.
//

import SwiftUI

struct AccountSettingsView: View {
    //    @EnvironmentObject var published: PublishedVariebles
    @State var showEdit = false
    
    var body: some View {
        List{
                NavigationLink(destination: ChangePasswordView()){
                    HStack(spacing: 29){
                        Image(systemName: "lock.shield")
                            .font(.system(size: 29))
                            .fontWeight(.light)
                        VStack(alignment: .leading, spacing: 5){
                            Text("change-password")
                                .fontWeight(.semibold)
                                .font(.subheadline)
                                .foregroundStyle(.primary)
                            Text("old-password-new-password")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(.leading, 5)
                }
                NavigationLink(destination: ChangeEmailView()){
                    HStack(spacing: 29){
                        Image(systemName: "envelope.badge.shield.half.filled")
                            .font(.system(size: 29))
                            .fontWeight(.light)
                        VStack(alignment: .leading, spacing: 5){
                            Text("change-email")
                                .fontWeight(.semibold)
                                .font(.subheadline)
                                .foregroundStyle(.primary)
                            Text("current-password-new-email")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            NavigationLink(destination: EditProfileView(showingEditingProfile: $showEdit)){
                HStack(spacing: 29){
                    Image(systemName: "square.and.pencil")
                        .font(.system(size: 29))
                        .fontWeight(.light)
                    VStack(alignment: .leading, spacing: 5){
                        Text("edit-profile")
                            .fontWeight(.semibold)
                            .font(.subheadline)
                            .foregroundStyle(.primary)
                        Text("change-name-username-phone")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(.leading, 5)
            }
        }
        .accentColor(Color(K.Colors.lightGray))
    .navigationTitle("settings")
    }
}

//#Preview {
//    AccountSettingsView()
//}
