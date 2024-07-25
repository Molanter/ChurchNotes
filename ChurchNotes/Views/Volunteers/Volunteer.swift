//
//  Volunteer.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 12/24/23.
//

import SwiftUI

struct Volunteer: View {
    @EnvironmentObject var published: PublishedVariebles
    @EnvironmentObject var viewModel: AppViewModel
    @Environment(\.dismiss) private var dismiss
    @State var email = ""
    @State var uid = ""
    @State var picked = 1
    
    var body: some View {
        List{
            Section{
                Text("control-volunteer")
                    .font(.title)
                    .bold()
                    .listRowBackground(Color.clear)
                    .listRowInsets(EdgeInsets())
                    .listRowSeparator(.hidden)
                HStack{
                    Text("rrole")
                    Spacer()
                    Picker(selection: $picked, label: Text("picker")) {
                        Text("uuser").tag(0)
                        Text("vvolunteer").tag(1)
                        Text("ttester").tag(2)
                        Text("ddeveloper").tag(3)
                        Text("jjedai").tag(4)
                        
                    }
                    .accentColor(Color(K.Colors.lightGray))
                }
                .listRowBackground(Color.clear)
                .listRowInsets(EdgeInsets())
                .listRowSeparator(.hidden)
            }
            Section{
                TextField("eemail", text: $email)
                    .textCase(.lowercase)
                    .keyboardType(.emailAddress)
                    .textContentType(.emailAddress)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
            }
            .listSectionSpacing(10)
            if let error = published.findUserId {
                Text(error)
                    .foregroundStyle(.secondary)
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
            }
            Text("sset")
                .padding(10)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .background(K.Colors.mainColor)
                .cornerRadius(10)
                .listRowBackground(Color.clear)
                .listRowInsets(EdgeInsets())
                .listRowSeparator(.hidden)
                .onTapGesture {
                    viewModel.getuserIdByEmail(email: email) { userId in
                        if !userId.isEmpty {
                            
                            viewModel.updateRole(role: picked == 0 ? "user" : (picked == 1 ? "volunteer" : (picked == 2 ? "tester" : (picked == 3 ? "developer" : "jedai"))), uid: userId)
                            Toast.shared.present(
                                title: String(localized: "info-updated"),
                                symbol: "checkmark.icloud.fill",
                                isUserInteractionEnabled: true,
                                timing: .medium
                            )
                            self.dismiss()
                        } else {
                            print("Failed to get userId.")
                        }
                    }
                    self.uid = published.findUserId ?? ""
                }
        }
    }
}

#Preview {
    Volunteer()
}
