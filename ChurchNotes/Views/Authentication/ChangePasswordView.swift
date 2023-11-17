//
//  ChangePasswordView.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 11/13/23.
//

import SwiftUI
import FirebaseAuth

struct ChangePasswordView: View {
    @State var oldPassword = ""
    @State var newPassword = ""
    @State var repeatPassword = ""
    @State var showOldPassword = false
    @State var showNewPassword = false
    @State var fieldsEmty = "Some fields are emty, please fill them before submiting!"
    let auth = Auth.auth()
    
    @EnvironmentObject var viewModel: AppViewModel

    var body: some View {
        VStack{
            Text("Change password for:")
                .font(.title2)
                .foregroundStyle(.primary)
            Text("'\(viewModel.currentUser?.email ?? auth.currentUser?.email ?? "")'")
                .font(.body)
                .foregroundStyle(.secondary)
            VStack(alignment: .leading, spacing: 15){
                VStack(alignment: .leading){
                    Text("Current Password")
                        .fontWeight(.semibold)
                        .font(.system(size: 18))
                    HStack(alignment: .center, spacing: 0.0){
                        ZStack(alignment: .leading){
                            if oldPassword.isEmpty{
                                Text("Current Password")
                                    .padding(.leading)
                                    .foregroundColor(Color(K.Colors.lightGray))
                            }
                            HStack{
                                Group{
                                    if !showOldPassword{
                                        SecureField("", text: $oldPassword)
                                            .disableAutocorrection(true)
                                            .textInputAutocapitalization(.never)
                                            .padding(0)
                                            .textContentType(.newPassword)
                                            .padding(.leading)
                                    }else{
                                        TextField("", text: $oldPassword)
                                            .foregroundColor(Color(K.Colors.lightGray))
                                            .disableAutocorrection(true)
                                            .textInputAutocapitalization(.never)
                                            .padding(0)
                                            .textContentType(.newPassword)
                                            .padding(.leading)
                                    }
                                }
                                Spacer()
                                Button(action: {
                                    self.showOldPassword.toggle()
                                }){
                                    Image(systemName: showOldPassword ? "eye.slash.fill" : "eye.fill")
                                        .foregroundStyle(Color(K.Colors.lightGray))
                                        .symbolEffect(.bounce, value: showOldPassword)
                                        .padding(.trailing)
                                }
                            }
                        }
                    }
                    .frame(height: 50)
                    .overlay(
                        RoundedRectangle(cornerSize: .init(width: 7, height: 7))
                            .stroke(Color(K.Colors.justLightGray).opacity(0.5), lineWidth: 1)
                    )
                }
                VStack(alignment: .leading){
                    Text("New Password")
                        .fontWeight(.medium)
                        .font(.system(size: 18))
                    HStack(alignment: .center, spacing: 0.0){
                        ZStack(alignment: .leading){
                            if newPassword.isEmpty{
                                Text("Create Password")
                                    .padding(.leading)
                                    .foregroundColor(Color(K.Colors.lightGray))
                            }
                            HStack{
                                Group{
                                    if !showNewPassword{
                                        SecureField("", text: $newPassword)
                                            .disableAutocorrection(true)
                                            .textInputAutocapitalization(.never)
                                            .padding(0)
                                            .textContentType(.newPassword)
                                            .padding(.leading)
                                    }else{
                                        TextField("", text: $newPassword)
                                            .foregroundColor(Color(K.Colors.lightGray))
                                            .disableAutocorrection(true)
                                            .textInputAutocapitalization(.never)
                                            .padding(0)
                                            .textContentType(.newPassword)
                                            .padding(.leading)
                                    }
                                }
                                Spacer()
                                Button(action: {
                                    self.showNewPassword.toggle()
                                }){
                                    Image(systemName: showNewPassword ? "eye.slash.fill" : "eye.fill")
                                        .foregroundStyle(Color(K.Colors.lightGray))
                                        .symbolEffect(.bounce, value: showNewPassword)
                                        .padding(.trailing)
                                }
                            }
                        }
                    }
                    .frame(height: 50)
                    .overlay(
                        RoundedRectangle(cornerSize: .init(width: 7, height: 7))
                            .stroke(Color(K.Colors.justLightGray).opacity(0.5), lineWidth: 1)
                    )
                    HStack(alignment: .center, spacing: 0.0){
                        ZStack(alignment: .leading){
                            if repeatPassword.isEmpty{
                                Text("Repeat Password")
                                    .padding(.leading)
                                    .foregroundColor(Color(K.Colors.lightGray))
                            }
                            HStack{
                                Group{
                                    if !showNewPassword{
                                        SecureField("", text: $repeatPassword)
                                            .disableAutocorrection(true)
                                            .textInputAutocapitalization(.never)
                                            .padding(0)
                                            .textContentType(.newPassword)
                                            .padding(.leading)
                                    }else{
                                        TextField("", text: $repeatPassword)
                                            .foregroundColor(Color(K.Colors.lightGray))
                                            .disableAutocorrection(true)
                                            .textInputAutocapitalization(.never)
                                            .padding(0)
                                            .textContentType(.newPassword)
                                            .padding(.leading)
                                    }
                                }
                                Spacer()
                                Button(action: {
                                    self.showNewPassword.toggle()
                                }){
                                    Image(systemName: showNewPassword ? "eye.slash.fill" : "eye.fill")
                                        .foregroundStyle(Color(K.Colors.lightGray))
                                        .symbolEffect(.bounce, value: showNewPassword)
                                        .padding(.trailing)
                                }
                            }
                        }
                    }
                    .frame(height: 50)
                    .overlay(
                        RoundedRectangle(cornerSize: .init(width: 7, height: 7))
                            .stroke(Color(K.Colors.justLightGray).opacity(0.5), lineWidth: 1)
                    )
                }
                Button(action: {
                    if oldPassword != "" && newPassword != "" && repeatPassword != ""{
                        viewModel.changePassword(currentPassword: oldPassword, newPassword: newPassword, confirmPassword: repeatPassword)
                    }else{
                        viewModel.err = fieldsEmty
                    }
                }){
                    Text("Change")
                        .foregroundStyle(Color.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                }
                .background(Color(K.Colors.mainColor))
                .cornerRadius(7)
                .padding(.top, 10)
                Text(viewModel.err)
                    .foregroundStyle(.secondary)
                    .font(.title2)
                    .fontWeight(.bold)
            }
            .padding(.top, 10)
            Spacer()
        }
//        .navigationTitle("Change Password")
        .padding(.horizontal, 15)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
}

#Preview {
    ChangePasswordView()
        .environmentObject(AppViewModel())
}
