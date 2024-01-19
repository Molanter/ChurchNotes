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
        VStack(alignment: .leading, spacing: 20){
            Text("block-user")
                .font(.title)
                .bold()
            HStack{
                Text("rreason")
                    .font(.title2)
                    .bold()
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
            TextField(text: $email, prompt: Text("eemail")) {
                Text("eemail")
            }
            .textCase(.lowercase)
            .keyboardType(.emailAddress)
            .textContentType(.emailAddress)
            .textFieldStyle(.roundedBorder)
                Text(published.findUserId ?? "")
                    .foregroundStyle(.secondary)
            Button(action: {
                print(published.findUserId ?? "")
                viewModel.getuserIdByEmail(email: email) { userId in
                    if !userId.isEmpty {
                        viewModel.updateStatus(status: "block", uid: userId)
                    } else {
                        print("Failed to get userId.")
                    }
                }
                viewModel.getFcmByEmail(email: email, messageText: String(localized: "your-account-was-blocked-for '\(picked == 0 ? String(localized: "aabuse") : (picked == 1 ? String(localized: "images-that-you-can-not-use-in-app") : (picked == 2 ? String(localized:"to-many-signings") : ( (picked == 3 ? String(localized: "sspam") : (picked == 4 ? String(localized: "to-many-accounts") : String(localized: "non-usual-situation")))))))'"), subtitle: String(localized: "your-account-is-blocked"), title: String(localized: "account-block"), imageURL: "", link: "", badgeCount: 5)
                self.uid = published.findUserId ?? ""
            }, label: {
                Text(/*published.findUserId == nil ? "gget-uid" : */"bblock")
                    .padding()
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .background(Color(K.Colors.mainColor))
                    .cornerRadius(7)
            })
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .padding(.horizontal, 15)
    }
}

#Preview {
    BlockUserView()
}
