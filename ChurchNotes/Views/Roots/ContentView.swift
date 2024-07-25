//
//  ContentView.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 6/28/23.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var published: PublishedVariebles
    @EnvironmentObject var viewModel: AppViewModel
    
    @StateObject var networkMonitor = NetworkMonitor()

    var body: some View {
//            NavigationStack {
                ZStack {
                    if published.device == .phone {
                        AppView()
                    }else {
                        PeopleSplitView()
                    }
                }
                    .blur(radius: (published.currentBadge != nil) ? 5 : 0)
                    .overlay(alignment: .center, content: {
                        if let badge = published.currentBadge, !viewModel.badgesArray.contains(where: { $0 == badge.id }) {
                            VStack(alignment: .center, spacing: 15){
                                HStack{
                                    Spacer()
                                    Image(systemName: "xmark")
                                        .foregroundStyle(K.Colors.mainColor)
                                    //                                        .offset(x: 10, y: 10)
                                        .frame(alignment: .topTrailing)
                                        .onTapGesture {
                                            withAnimation{
                                                published.currentBadge = nil
                                            }
                                        }
                                }
                                ZStack(alignment: .center){
                                    if badge.string != ""{
                                        Text(badge.string)
                                            .font(.system(size: 55))
                                            .fontWeight(.medium)
                                    }else{
                                        Image(systemName: badge.image)
                                            .font(.system(size: 55))
                                            .fontWeight(.medium)
                                    }
                                }
                                .padding(20)
                                .background(K.Colors.mainColor.opacity(0.35))
                                .cornerRadius(7)
                                .shadow(radius: 10)
                                .padding(.bottom, 45)
                                Divider()
                                    .foregroundStyle(Color(K.Colors.text))
                                Text(badge.name)
                                    .bold()
                                    .font(.title)
                                Text("congratulations-new-badge")
                                    .font(.title2)
                                    .frame(alignment: .center)
                                    .multilineTextAlignment(.center)
                            }
                            //                        .padding(.vertical, 30)
                            .padding(30)
                            .background(.whiteGray)
                            .cornerRadius(15)
                            .padding(.horizontal, 30)
                            .shadow(color: Color(red: 0.2, green: 0.2, blue: 0.28).opacity(0.08), radius: 16, x: 0, y: 24)
                            .shadow(color: Color(red: 0.2, green: 0.2, blue: 0.28).opacity(0.08), radius: 8, x: 0, y: 16)
                        }
                        
                    })
                    .onAppear{
                        viewModel.checkDeviceForUser() { containsDevice, error in
                            if let error = error {
                                print("Error checking for device: \(error.localizedDescription)")
                            } else {
                                print("Does the user's devices array contain the device? \(containsDevice)")
                                if !containsDevice{
                                    viewModel.logOut()
                                }
                            }
                        }
                        
                        viewModel.fetchStages()
                        viewModel.fetchPeople()
                        viewModel.fetchUser()
                        viewModel.fetchNotifications()
                        viewModel.fetchBadges()
                    }
                    .accentColor(published.device == .phone ? K.Colors.mainColor : Color(K.Colors.text))
                    .environmentObject(networkMonitor)
//            }
    }
}

//#Preview {
//    ContentView()
//}
