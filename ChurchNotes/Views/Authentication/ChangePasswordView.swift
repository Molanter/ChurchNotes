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
    @State var fieldsEmty = String(localized: "some-fields-are-emty")
    let auth = Auth.auth()
    
    @EnvironmentObject var viewModel: AppViewModel
    
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
                                SecureField("∙∙∙∙∙∙∙∙", text: $oldPassword)
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
                Section(header: Text("new-password")){
                    HStack{
                        Group{
                            if !showNewPassword{
                                SecureField("∙∙∙∙∙∙∙∙", text: $newPassword)
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
                    HStack{
                        Group{
                            if !showNewPassword{
                                SecureField("∙∙∙∙∙∙∙∙", text: $repeatPassword)
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
                }
                Section{
                    Text("change")
                        .foregroundStyle(Color.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(K.Colors.mainColor)
                        .cornerRadius(10)
                        .onTapGesture {
                            if oldPassword != "" && newPassword != "" && repeatPassword != ""{
                                viewModel.changePassword(currentPassword: oldPassword, newPassword: newPassword, confirmPassword: repeatPassword)
                            }else{
                                viewModel.err = fieldsEmty
                            }
                        }
                        .listRowInsets(EdgeInsets())
                }
                
                if !viewModel.err.isEmpty{
                    Text(viewModel.err)
                        .foregroundStyle(.secondary)
                        .font(.title2)
                        .fontWeight(.bold)
                }
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
