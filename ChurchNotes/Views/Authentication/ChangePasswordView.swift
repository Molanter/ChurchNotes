//
//  ChangePasswordView.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 11/13/23.
//

import SwiftUI
import FirebaseAuth

struct ChangePasswordView: View {
    @FocusState var focus: FocusedField?
    @State var oldPassword = ""
    @State var newPassword = ""
    @State var repeatPassword = ""
    @State var showOldPassword = false
    @State var showNewPassword = false
    @State var fieldsEmty = "some-fields-are-emty"
    let auth = Auth.auth()
    
    @EnvironmentObject var viewModel: AppViewModel

    var body: some View {
        VStack{
            Text("change-password-for")
                .font(.title2)
                .foregroundStyle(.primary)
            Text("'\(viewModel.currentUser?.email ?? auth.currentUser?.email ?? "")'")
                .font(.body)
                .foregroundStyle(.secondary)
            VStack(alignment: .leading, spacing: 15){
                VStack(alignment: .leading){
                    Text("current-password")
                        .fontWeight(.semibold)
                        .font(.system(size: 18))
                    HStack(alignment: .center, spacing: 0.0){
                        ZStack(alignment: .leading){
                            if oldPassword.isEmpty{
                                Text("current-password")
                                    .padding(.leading)
                                    .foregroundStyle(.secondary)
                            }
                            HStack{
                                Group{
                                    if !showOldPassword{
                                        SecureField("", text: $oldPassword)
                                            .submitLabel(.next)
                                            .disableAutocorrection(true)
                                            .textInputAutocapitalization(.never)
                                            .padding(0)
                                            .textContentType(.newPassword)
                                            .padding(.leading)
                                    }else{
                                        TextField("", text: $oldPassword)
                                            .submitLabel(.next)
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
                    Text("new-password")
                        .fontWeight(.medium)
                        .font(.system(size: 18))
                    HStack(alignment: .center, spacing: 0.0){
                        ZStack(alignment: .leading){
                            if newPassword.isEmpty{
                                Text("create-password")
                                    .padding(.leading)
                                    .foregroundStyle(.secondary)
                            }
                            HStack{
                                Group{
                                    if !showNewPassword{
                                        SecureField("", text: $newPassword)
                                            .submitLabel(.next)
                                            .disableAutocorrection(true)
                                            .textInputAutocapitalization(.never)
                                            .padding(0)
                                            .textContentType(.newPassword)
                                            .padding(.leading)
                                    }else{
                                        TextField("", text: $newPassword)
                                            .submitLabel(.next)
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
                                Text("repeat-password")
                                    .padding(.leading)
                                    .foregroundStyle(.secondary)
                            }
                            HStack{
                                Group{
                                    if !showNewPassword{
                                        SecureField("", text: $repeatPassword)
                                            .submitLabel(.next)
                                            .disableAutocorrection(true)
                                            .textInputAutocapitalization(.never)
                                            .padding(0)
                                            .textContentType(.newPassword)
                                            .padding(.leading)
                                    }else{
                                        TextField("", text: $repeatPassword)
                                            .submitLabel(.next)
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
                    Text("change")
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
            .onSubmit {
                        switch focus {
                        case .oldPass:
                            focus = .createPass
                        case .createPass:
                            focus = .repeatPass
                        case .repeatPass:
                            if oldPassword != "" && newPassword != "" && repeatPassword != ""{
                                viewModel.changePassword(currentPassword: oldPassword, newPassword: newPassword, confirmPassword: repeatPassword)
                            }else{
                                viewModel.err = fieldsEmty
                            }
                        default:
                            break
                        }
                    }
            .padding(.top, 10)
            Spacer()
        }
//        .navigationTitle("Change Password")
        .padding(.horizontal, 15)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
    enum FocusedField:Hashable{
        case oldPass, createPass, repeatPass
        }
}

#Preview {
    ChangePasswordView()
        .environmentObject(AppViewModel())
}
