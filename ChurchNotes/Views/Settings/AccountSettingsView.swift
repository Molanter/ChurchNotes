//
//  AccountSettingsView.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 11/13/23.
//

import SwiftUI

struct AccountSettingsView: View {
    //    @EnvironmentObject var published: PublishedVariebles
    
    var body: some View {
        //        ScrollView(.vertical){
        List{
            //            VStack(alignment: .leading, spacing: 20){
            VStack(alignment: .leading){
                NavigationLink(destination: ChangePasswordView()){
                    HStack(spacing: 29){
                        Image(systemName: "lock.shield")
                            .font(.system(size: 29))
                            .fontWeight(.light)
                        VStack(alignment: .leading, spacing: 5){
                            Text("change-password")
                                .fontWeight(.semibold)
                                .font(.system(size: 15))
                                .foregroundStyle(.primary)
                            Text("old-password-new-password")
                                .font(.system(size: 11))
                                .foregroundStyle(.secondary)
                        }
//                        Spacer()
//                        Image(systemName: "chevron.forward")
//                            .frame(width: 28)
                    }
//                    .padding(.horizontal, 25)
                }
            }
            VStack(alignment: .leading){
                NavigationLink(destination: ChangeEmailView()){
                    HStack(spacing: 29){
                        Image(systemName: "envelope.badge.shield.half.filled")
                            .font(.system(size: 29))
                            .fontWeight(.light)
                        VStack(alignment: .leading, spacing: 5){
                            Text("change-email")
                                .fontWeight(.semibold)
                                .font(.system(size: 15))
                                .foregroundStyle(.primary)
                            Text("current-password-new-email")
                                .font(.system(size: 11))
                                .foregroundStyle(.secondary)
                        }
//                        Spacer()
//                        Image(systemName: "chevron.forward")
//                            .frame(width: 28)
                    }
//                    .padding(.horizontal, 25)
                }
            }
            //            }
        }
        .accentColor(Color(K.Colors.lightGray))
        
        //        }
        
        
        .navigationTitle("settings")
    }
}

#Preview {
    AccountSettingsView()
}
