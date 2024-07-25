//
//  BlockUserView.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 12/24/23.
//

import SwiftUI

struct BlockUserView: View {
    @EnvironmentObject var published: PublishedVariebles
    @EnvironmentObject var viewModel: AppViewModel
    
    @State var email = ""
    @State var uid = ""
    @State var picked = 2
    
    var body: some View {
        List{
            Section{
                Text("block-user")
                    .font(.title)
                    .bold()
                    .listRowBackground(Color.clear)
                    .listRowInsets(EdgeInsets())
                    .listRowSeparator(.hidden)
                HStack{
                    Text("rreason")
                    Spacer()
                    Picker(selection: $picked, label: Text("picker")) {
                        Text("aabuse").tag(0)
                        Text("iimages").tag(1)
                        Text("to-many-signings").tag(2)
                        Text("sspam").tag(3)
                        Text("to-many-accounts").tag(4)
                        Text("oother").tag(5)
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
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
            }
            Text("bblock")
                .padding(10)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .background(K.Colors.mainColor)
                .cornerRadius(10)
                .listRowBackground(Color.clear)
                .listRowInsets(EdgeInsets())
                .listRowSeparator(.hidden)
                .onTapGesture {
                    let reason = String(localized: "your-account-was-blocked-for '\(picked == 0 ? String(localized: "aabuse") : (picked == 1 ? String(localized: "images-that-you-can-not-use-in-app") : (picked == 2 ? String(localized:"to-many-signings") : ( (picked == 3 ? String(localized: "sspam") : (picked == 4 ? String(localized: "to-many-accounts") : String(localized: "unknown reason")))))))'")
                    print(published.findUserId ?? "")
                    viewModel.getuserIdByEmail(email: email) { userId in
                        if !userId.isEmpty {
                            viewModel.updateStatus(status: "block", uid: userId, reason : reason)
                        } else {
                            print("Failed to get userId.")
                        }
                    }
                    viewModel.getFcmByEmail(email: email, messageText: reason, subtitle: String(localized: "your-account-is-blocked"), title: String(localized: "account-block"), imageURL: "", link: "", badgeCount: 5)
                    self.uid = published.findUserId ?? ""
                }
        }
    }
}

//#Preview {
//    BlockUserView()
//}
