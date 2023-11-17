//
//  SettingsView.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 11/13/23.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        ScrollView(.vertical){
            VStack(alignment: .leading, spacing: 20){
                VStack(alignment: .leading){
                    NavigationLink(destination: ChangePasswordView()){
                        HStack(spacing: 29){
                            Image(systemName: "lock.shield")
                                .font(.system(size: 29))
                                .fontWeight(.light)
                            VStack(alignment: .leading, spacing: 5){
                                Text("Change Password")
                                    .fontWeight(.semibold)
                                    .font(.system(size: 15))
                                    .foregroundStyle(.primary)
                                Text("Old password, new password")
                                    .font(.system(size: 11))
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                            Image(systemName: "chevron.forward")
                                .frame(width: 28)
                        }
                        .padding(.horizontal, 25)
                    }
                    Divider()
                }
            }
            .accentColor(Color(K.Colors.lightGray))
            
        }
        .navigationTitle("Settings")
    }
}

#Preview {
    SettingsView()
}
