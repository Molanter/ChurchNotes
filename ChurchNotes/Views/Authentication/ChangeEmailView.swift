//
//  ChangeEmailView.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 12/8/23.
//

import SwiftUI
import FirebaseAuth
import SwiftData

struct ChangeEmailView: View {
    @EnvironmentObject var viewModel: AppViewModel

    @Query var strings: [StringDataModel]

    @FocusState var focus: FocusedField?
    
    @State var pass = ""
    @State var email = ""
    @State var showPass = false
    @State private var emailLabel = String("email@example.com")
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
                            if !showPass{
                                SecureField("••••••••", text: $pass)
                                    .submitLabel(.next)
                                    .focused($focus, equals: .pass)
                                    .disableAutocorrection(true)
                                    .textInputAutocapitalization(.never)
                                    .textContentType(.newPassword)
                            }else{
                                TextField("current-password", text: $pass)
                                    .submitLabel(.next)
                                    .disableAutocorrection(true)
                                    .textInputAutocapitalization(.never)
                                    .textContentType(.newPassword)
                            }
                        }
                        Spacer()
                        Image(systemName: showPass ? "eye.slash.fill" : "eye.fill")
                            .symbolEffect(.bounce, value: showPass)
                            .onTapGesture {
                                self.showPass.toggle()
                            }
                    }
                }
                .listRowBackground(
                    GlassListRow()
                )
                Section(header: Text("new-email")){
                    HStack{
                        TextField(emailLabel, text: $email)
                            .submitLabel(.done)
                            .focused($focus, equals: .email)
                            .disableAutocorrection(true)
                            .textInputAutocapitalization(.never)
                            .keyboardType(.emailAddress)
                            .textContentType(.emailAddress)
                        Spacer()
                        Image(systemName: "envelope.fill")
                            .onTapGesture {
                                if !email.contains("@"){
                                    email += "@gmail.com"
                                }
                            }
                    }
                }
                .listRowBackground(
                    GlassListRow()
                )
                Section{
                    Text("change")
                        .foregroundStyle(!pass.isEmpty && !email.isEmpty && email != auth.currentUser?.email ?? "" ? Color.white : Color.black)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(!pass.isEmpty && !email.isEmpty && email != auth.currentUser?.email ?? "" ? K.Colors.mainColor : Color.secondary)
                        .cornerRadius(10)
                        .onTapGesture {
                            if !pass.isEmpty, !email.isEmpty, email != auth.currentUser?.email ?? ""{
                                viewModel.changeEmail(currentPassword: pass, newEmail: email)
                            }else if email == auth.currentUser?.email ?? ""{
                                viewModel.err = String(localized: "new-email-can-not-equal-to-old")
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
                case .pass:
                    focus = .email
                case .email:
                    if pass != "" && email != "" && email != auth.currentUser?.email ?? ""{
                        viewModel.changeEmail(currentPassword: pass, newEmail: email)
                    }else if email == auth.currentUser?.email ?? ""{
                        viewModel.err = String(localized: "new-email-can-not-equal-to-old")
                    }else{
                        viewModel.err = fieldsEmty
                    }
                default:
                    break
                }
            }
        }
        .navigationTitle("change-email-for")
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color(K.Colors.listBg))
    }
    enum FocusedField:Hashable{
        case email, pass
    }
}

//#Preview {
//    ChangeEmailView()
//}
