//
//  IndexView.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 7/16/23.
//

import SwiftUI

struct IndexView: View {
    @EnvironmentObject var viewModel: AppViewModel
    @EnvironmentObject var published: PublishedVariebles
    
    @StateObject var networkMonitor = NetworkMonitor()
    var utilities = Utilities()
    
    var body: some View {
        ZStack{
            if viewModel.signedIn{
                ZStack{
                    AppView()
                        .blur(radius: (published.currentBadge != nil) ? 5 : 0)
                    if let badge = published.currentBadge{
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
                            }
//                        .padding(.vertical, 30)
                        .padding(30)
                        .background(.whiteGray)
                        .cornerRadius(15)
                        .padding(.horizontal, 30)
                        .shadow(color: Color(red: 0.2, green: 0.2, blue: 0.28).opacity(0.08), radius: 16, x: 0, y: 24)
                        .shadow(color: Color(red: 0.2, green: 0.2, blue: 0.28).opacity(0.08), radius: 8, x: 0, y: 16)
                    }
                    
                }
                .toolbar(published.tabsAreHidden ? .hidden : .visible, for: .tabBar)
                .onAppear{
                    viewModel.peopleArray.removeAll()
                    viewModel.stagesArray.removeAll()
                    viewModel.fetchStages()
                    viewModel.fetchPeople()
                    viewModel.fetchUser()
                    viewModel.fetchBadges()
                }
                .accentColor(K.Colors.mainColor)
                .environmentObject(networkMonitor)
            }else{
                LoginPage()
                    .accentColor(K.Colors.mainColor)
            }
        }
//        .fullScreenCover(isPresented: Binding(
//            get: { viewModel.currentUser?.status == "block" },
//            set: { _ in }
//        )) {
//            ZStack(alignment: .center) {
//                Rectangle()
//                    .fill(Color(K.Colors.blackAndWhite))
//                VStack(alignment: .center, spacing: 20){
//                    Text("your-ack-is-blocked")
//                        .font(.title2)
//                    Button{
//                        
//                    } label: {
//                        Text("ggot-iit")
//        .foregroundStyle(K.Colors.mainColor)
//                    }
//                }
//            }
//            .frame(maxWidth: .infinity, maxHeight: .infinity)
//        }
        .onAppear{
            utilities.overrideDisplayMode()
            print("apeaaarssss")
            viewModel.signedIn = viewModel.isSignedIn
        }
}
    
    
}

//#Preview {
//        IndexView()
//            .environmentObject(AppViewModel())
//            .environmentObject(PublishedVariebles())
//
//}
