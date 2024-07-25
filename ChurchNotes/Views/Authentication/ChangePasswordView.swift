//
//  ChangePasswordView.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 11/13/23.
//

import SwiftUI
import FirebaseAuth
import SwiftData

struct ChangePasswordView: View {
    @EnvironmentObject var viewModel: AppViewModel

    @Query var strings: [StringDataModel]

    @FocusState var focus: FocusedField?
    
    @State var oldPassword = ""
    @State var newPassword = ""
    @State var repeatPassword = ""
    @State var showOldPassword = false
    @State var showNewPassword = false
    @State var fieldsEmty = String(localized: "some-fields-are-emty")
    let auth = Auth.auth()
    
    var backgroundType: String {
        if let strModel = strings.first(where: { $0.name == "backgroundType" }) {
            return strModel.string
        }else {
            return "none"
        }
    }
    
    var body: some View {
        NavigationStack{
            Text("'\(viewModel.currentUser?.email ?? auth.currentUser?.email ?? "")'")
                .font(.body)
                .foregroundStyle(.secondary)
            List{
                Section(header: Text("current-password")){
                    HStack{
                        Group{
                            if !showOldPassword{
                                SecureField("••••••••", text: $oldPassword)
                                    .submitLabel(.next)
                                    .disableAutocorrection(true)
                                    .textInputAutocapitalization(.never)
                                    .textContentType(.newPassword)
                            }else{
                                TextField("current-password", text: $oldPassword)
                                    .submitLabel(.next)
                                    .disableAutocorrection(true)
                                    .textInputAutocapitalization(.never)
                                    .textContentType(.newPassword)
                            }
                        }
                        Spacer()
                        Image(systemName: showOldPassword ? "eye.slash.fill" : "eye.fill")
                            .symbolEffect(.bounce, value: showOldPassword)
                            .onTapGesture {
                                self.showOldPassword.toggle()
                            }
                    }
                }
                .listRowBackground(
                    GlassListRow()
                )
                Section(header: Text("new-password")){
                    HStack{
                        Group{
                            if !showNewPassword{
                                SecureField("••••••••", text: $newPassword)
                                    .submitLabel(.next)
                                    .disableAutocorrection(true)
                                    .textInputAutocapitalization(.never)
                                    .textContentType(.newPassword)
                            }else{
                                TextField("create-password", text: $newPassword)
                                    .submitLabel(.next)
                                    .disableAutocorrection(true)
                                    .textInputAutocapitalization(.never)
                                    .textContentType(.newPassword)
                            }
                        }
                        Spacer()
                        Image(systemName: showNewPassword ? "eye.slash.fill" : "eye.fill")
                            .symbolEffect(.bounce, value: showNewPassword)
                            .onTapGesture {
                                self.showNewPassword.toggle()
                            }
                    }
                    if !newPassword.isEmpty {
                        PasswordRules(pass: $newPassword)
                    }
                    HStack{
                        Group{
                            if !showNewPassword{
                                SecureField("••••••••", text: $repeatPassword)
                                    .submitLabel(.next)
                                    .disableAutocorrection(true)
                                    .textInputAutocapitalization(.never)
                                    .textContentType(.newPassword)
                            }else{
                                TextField("repeat-password", text: $repeatPassword)
                                    .submitLabel(.next)
                                    .disableAutocorrection(true)
                                    .textInputAutocapitalization(.never)
                                    .textContentType(.newPassword)
                            }
                        }
                        Spacer()
                        Image(systemName: showNewPassword ? "eye.slash.fill" : "eye.fill")
                            .symbolEffect(.bounce, value: showNewPassword)
                            .onTapGesture {
                                self.showNewPassword.toggle()
                            }
                    }
                    if !newPassword.isEmpty, !repeatPassword.isEmpty {
                        Label("pass-match", systemImage: newPassword == repeatPassword ? "checkmark" : "xmark")
                            .foregroundStyle(newPassword == repeatPassword ? Color.green : Color.red)
                            .font(.caption)
                    }
                }
                .listRowBackground(
                    GlassListRow()
                )
                Section{
                    Text("change")
                        .foregroundStyle(!oldPassword.isEmpty && !newPassword.isEmpty && !repeatPassword.isEmpty ? Color.white : Color.black)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(!oldPassword.isEmpty && !newPassword.isEmpty && !repeatPassword.isEmpty ? K.Colors.mainColor : Color.secondary)
                        .cornerRadius(10)
                        .onTapGesture {
                            if !oldPassword.isEmpty, !newPassword.isEmpty, !repeatPassword.isEmpty {
                                viewModel.changePassword(currentPassword: oldPassword, newPassword: newPassword, confirmPassword: repeatPassword)
                            }else{
                                viewModel.err = fieldsEmty
                            }
                        }
                        .listRowInsets(EdgeInsets())
                }
                .listRowBackground(
                    GlassListRow()
                )
                
                if !viewModel.err.isEmpty{
                    Text(viewModel.err)
                        .foregroundStyle(.secondary)
                        .font(.title2)
                        .fontWeight(.bold)
                        .listRowBackground(
                            GlassListRow()
                        )
                }
            }
            .scrollContentBackground(backgroundType == "none" ? .visible : .hidden)
            .background {
                ListBackground()
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
            .navigationTitle("change-password-for")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color(K.Colors.listBg))
    }
    enum FocusedField:Hashable{
        case oldPass, createPass, repeatPass
    }
}

#Preview {
    ChangePasswordView()
        .environmentObject(AppViewModel())
}
