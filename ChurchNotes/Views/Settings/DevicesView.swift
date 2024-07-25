//
//  DevicesView.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 3/4/24.
//

import SwiftUI
import SwiftData

struct DevicesView: View {
    @EnvironmentObject var viewModel: AppViewModel
    @EnvironmentObject var published: PublishedVariebles

    @Query var strings: [StringDataModel]

    @State private var showActionLogOutAll = false
    
    var backgroundType: String {
        if let strModel = strings.first(where: { $0.name == "backgroundType" }) {
            return strModel.string
        }else {
            return "none"
        }
    }
    
    var body: some View {
        NavigationStack{
            List{
                Section{
                    Menu{
                        Text(K.deviceName)
                        Button(role: .destructive){
                            viewModel.logOut()
                        }label: {
                            Label("log-out", systemImage: "rectangle.portrait.and.arrow.right")
                        }
                    }label: {
                        HStack{
                            Text(K.deviceName)
                                .bold()
                                .multilineTextAlignment(.leading)
                            Spacer()
                            Image(systemName: published.deviceImage(K.deviceName))
                        }
                            .foregroundStyle(Color(K.Colors.text))
                    }
                }header: {
                    Text("current-device")
                }
                .listRowBackground(
                    GlassListRow()
                )
                Section{
                    ForEach(viewModel.currentUser?.devicesArray ?? [], id: \.self){ device in
                        Menu{
                            Text(device)
                            Button(role: .destructive){
                                if device == K.deviceName {
                                    viewModel.logOut()
                                }else {
                                    viewModel.removeDeviceFromUser(device: device)
                                }
                            }label: {
                                Label("log-out", systemImage: "rectangle.portrait.and.arrow.right")
                            }
                        }label: {
                            VStack(alignment: .leading){
                                    HStack{
                                        VStack(alignment: .leading){
                                            Text(device)
                                            if device == K.deviceName{
                                                Text("this-device")
                                                    .multilineTextAlignment(.leading)
                                                    .foregroundStyle(.secondary)
                                                    .foregroundStyle(K.Colors.mainColor)
                                            }
                                        }
                                        .multilineTextAlignment(.leading)
                                        Spacer()
                                        Image(systemName: published.deviceImage(device))
                                            .symbolRenderingMode(.monochrome)
                                    }
                                    .foregroundStyle(Color(K.Colors.text))
                                }
                            }
                    }
                }header: {
                    Text("other-sessions")
                }
                .listRowBackground(
                    GlassListRow()
                )
            }
            .scrollContentBackground(backgroundType == "none" ? .visible : .hidden)
            .background {
                ListBackground()
            }
            .refreshable {
//                viewModel.fetchUser()
            }
            .navigationTitle("device-sessions")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                        Label("logout-all-session", systemImage: "ipad.and.iphone.slash")
                        .foregroundStyle(K.Colors.mainColor)
                        .onTapGesture(perform: {
                            print("pressed")
                            self.showActionLogOutAll.toggle()
                        })
//                    .actionSheet(isPresented: $showActionLogOutAll) {
//                        ActionSheet(title: Text("Do you want to Logout all Your devices?"),
//                                    buttons: [
//                                        .cancel(),
//                                        .destructive(
//                                            Text("logout-all-session")
//                                        ){
//                                            logOutAll()
//                                        }
//                                    ]
//                        )
//                    }
                    .confirmationDialog("", isPresented: $showActionLogOutAll, titleVisibility: .hidden) {
                                     Button("logout-all-session", role: .destructive) {
                                         logOutAll()
                                     }
                                     Button("cancel", role: .cancel) {
                                     }
                                }
                }
            }
        }
    }
    
    private func logOutAll(){
        for device in viewModel.currentUser?.devicesArray ?? [] {
            if device == K.deviceName {
                viewModel.logOut()
            }else {
                viewModel.removeDeviceFromUser(device: device)
            }
        }
    }
}

//#Preview {
//    DevicesView()
//}
