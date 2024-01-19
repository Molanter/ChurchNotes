//
//  ChangeEmailView.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 12/8/23.
//

import SwiftUI
import FirebaseAuth

struct ChangeEmailView: View {
    @FocusState var focus: FocusedField?

    @State var pass = ""
    @State var email = ""
    @State var showPass = false
    @State var fieldsEmty = "some-fields-are-emty"
    let auth = Auth.auth()
    
    @EnvironmentObject var viewModel: AppViewModel
    var body: some View {
        VStack{
            Text("change-email-for")
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
                            if pass.isEmpty{
                                Text("current-password")
                                    .padding(.leading)
                                    .foregroundStyle(.secondary)
                            }
                            HStack{
                                Group{
                                    if !showPass{
                                        SecureField("", text: $pass)
                                            .submitLabel(.next)
                                            .focused($focus, equals: .pass)
                                            .disableAutocorrection(true)
                                            .textInputAutocapitalization(.never)
                                            .padding(0)
                                            .textContentType(.newPassword)
                                            .padding(.leading)
                                    }else{
                                        TextField("", text: $pass)
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
                                    self.showPass.toggle()
                                }){
                                    Image(systemName: showPass ? "eye.slash.fill" : "eye.fill")
                                        .foregroundStyle(Color(K.Colors.lightGray))
                                        .symbolEffect(.bounce, value: showPass)
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
                    Text("new-email")
                        .fontWeight(.medium)
                        .font(.system(size: 18))
                    HStack(alignment: .center, spacing: 0.0){
                        
                        ZStack(alignment: .leading){
                            if email.isEmpty {
                                Text(verbatim: "j.marin@example.com")
                                    .padding(.leading)
                                    .foregroundStyle(.secondary)
                            }
                            TextField("", text: $email)
                                .submitLabel(.done)
                                .focused($focus, equals: .email)
                                .padding(.leading)
                                .foregroundColor(Color(K.Colors.lightGray))
                                .disableAutocorrection(true)
                                .textInputAutocapitalization(.never)
                                .opacity(0.75)
                                .padding(0)
                                .keyboardType(.emailAddress)
                                .textContentType(.emailAddress)
                        }
                        .frame(height: 45)
                        Spacer()
                        Button(action: {
                            if !email.contains("@"){
                                email += "@gmail.com"
                            }
                        }){
                            Image(systemName: "envelope.fill")
                                .foregroundStyle(Color(K.Colors.lightGray))
                                .padding(.trailing)
                        }
                    }
                    .overlay(
                        RoundedRectangle(cornerSize: .init(width: 7, height: 7))
                            .stroke(Color(K.Colors.justLightGray).opacity(0.5), lineWidth: 1)
                    )
                    .ignoresSafeArea(.keyboard, edges: .bottom)
                    
                }
                Button(action: {
                    if pass != "" && email != "" && email != auth.currentUser?.email ?? ""{
                        viewModel.changeEmail(currentPassword: pass, newEmail: email)
                    }else if email == auth.currentUser?.email ?? ""{
                        viewModel.err = "new-email-can-not-equal-to-old"
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
                        case .pass:
                            focus = .email
                        case .email:
                            if pass != "" && email != "" && email != auth.currentUser?.email ?? ""{
                                viewModel.changeEmail(currentPassword: pass, newEmail: email)
                            }else if email == auth.currentUser?.email ?? ""{
                                viewModel.err = "new-email-can-not-equal-to-old"
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
        case email, pass
        }
}

//#Preview {
//    ChangeEmailView()
//}
