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
    
    @State var email = ""
    @State var uid = ""
    @State var picked = 1
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20){
            Text("control-volunteer")
                .font(.title)
                .bold()
            HStack{
                Text("rrole")
                    .font(.title2)
                    .bold()
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
                viewModel.getuserIdByEmail(email: email) { userId in
                    if !userId.isEmpty {
                        
                        viewModel.updateRole(role: picked == 0 ? "user" : (picked == 1 ? "volunteer" : (picked == 2 ? "tester" : (picked == 3 ? "developer" : "jedai"))), uid: userId)
                    } else {
                        print("Failed to get userId.")
                    }
                }
                
                    
                self.uid = published.findUserId ?? ""
            }, label: {
                Text("sset")
                    .padding()
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .background(K.Colors.mainColor)
                    .cornerRadius(7)
            })
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .padding(.horizontal, 15)
    }
}

#Preview {
    Volunteer()
}
