//
//  AchievementsMainView.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 11/28/23.
//

import SwiftUI

struct AchievementsMainView: View {
    @EnvironmentObject var viewModel: AppViewModel
    
    var badgesArray: [Badge] {
        var array: [Badge] = []
        let badgesInstance = K.Badges()
        for name in viewModel.badgesArray {
            if let badge = badgesInstance.getBadgeArray()[name] as? Badge {
                array.append(badge)
            }
        }
        return array
    }


    var body: some View {
        NavigationStack{
            List{
                Section(header: Text("bbadges"), footer: Text("list-of-your-badges")) {
                    ScrollView(.horizontal) {
                        HStack(alignment: .center) {
                            
                            ForEach(badgesArray) { badge in
                                
                                Menu{
                                    Button {
                                        viewModel.setBadge(name: badge.strId)
                                        viewModel.currentUser?.badge = badge.strId
                                    } label: {
                                        Label(String(localized: "sset-bbadge"), systemImage: badge.image)
                                    }
                                } label: {
                                    VStack(spacing: 15){
                                        ZStack(alignment: .center) {
                                            if badge.string != "" {
                                                Text(badge.string)
                                                    .font(.system(size: 45))
                                                    .fontWeight(.medium)
                                            } else {
                                                Image(systemName: String(badge.image))
                                                    .font(.system(size: 45))
                                                    .fontWeight(.medium)
//                                                .foregroundStyle(Color(badge.color))
                                            }
                                        }
                                        Divider()
                                            .foregroundStyle(Color(K.Colors.text))
                                            .padding(.top, 5)
                                        Text(badge.name)
                                            .bold()
                                            .font(.title2)
                                    }
                                    .foregroundStyle(Color(K.Colors.text))
                                    .padding(5)
                                    .padding(.horizontal, 10)
                                    .frame(width: 120, height: 150)
                                    .background(Color(K.Colors.whiteGray))
                                    .cornerRadius(10)
                                    .shadow(color: Color(red: 0.2, green: 0.2, blue: 0.28).opacity(0.08), radius: 14, x: 0, y: 22)
                                    .shadow(color: Color(red: 0.2, green: 0.2, blue: 0.28).opacity(0.08), radius: 6, x: 0, y: 14)
                                    .padding(.horizontal, 5)
                                }
                                Divider()
                            }
                        }
                        .padding(.vertical, 10)
                    }
                }
//                .listRowBackground(Color.clear)
                Section(header: Text("next-stage"), footer: Text("achievement-for-next")) {
                    ScrollView(.horizontal){
                        HStack{
                            AchievementsItem(text: "", backgroundImage: "shield", image: "medal", imageSize: 40, score: "\(viewModel.currentUser?.next ?? 0)/5", imageColor: Color.brown)
                            Divider()
                            AchievementsItem(text: "", backgroundImage: "shield", image: "medal", imageSize: 40, score: "\(viewModel.currentUser?.next ?? 0)/20", imageColor: Color.gray)
                                .opacity((viewModel.currentUser?.next ?? 0) >= 5 ? 1 : 0.3)
                            Divider()
                            AchievementsItem(text: "", backgroundImage: "shield", image: "medal", imageSize: 40, score: "\(viewModel.currentUser?.next ?? 0)/50", imageColor: Color.yellow)
                                .opacity((viewModel.currentUser?.next ?? 0) >= 20 ? 1 : 0.3)
                        }
                    }
                }
                .onAppear(perform: {
                    print(viewModel.currentUser?.next ?? 0)
                })
//                .listRowBackground(Color.clear)
                Section(header: Text("done"), footer: Text("achievement-for-last-stage")) {
                    ScrollView(.horizontal){
                        HStack{
                            AchievementsItem(text: "", backgroundImage: "shield.fill", image: "trophy", imageSize: 40, score: "\(viewModel.currentUser?.done ?? 0)/1", image2: "3")
                            Divider()
                            AchievementsItem(text: "", backgroundImage: "shield.fill", image: "trophy", imageSize: 40, score: "\(viewModel.currentUser?.done ?? 0)/5", image2: "2")
                                .opacity((viewModel.currentUser?.done ?? 0) >= 1 ? 1 : 0.3)
                            Divider()
                            AchievementsItem(text: "", backgroundImage: "shield.fill", image: "trophy", imageSize: 40, score: "\(viewModel.currentUser?.done ?? 0)/15", image2: "1")
                                .opacity((viewModel.currentUser?.done ?? 0) >= 5 ? 1 : 0.3)
                        }
                    }
                }
//                .listRowBackground(Color.clear)
//                Section(header: Text("Bloger"), footer: Text("Achievement for recording and sending videos for people.")) {
//                    ScrollView(.horizontal){
//                        HStack{
//                            AchievementsItem(text: "", backgroundImage: "shield.fill", image: "video", imageSize: 40, score: "\(viewModel.currentUser?.bloger ?? 0)/5")
//                            AchievementsItem(text: "", backgroundImage: "shield.fill", image: "video.badge.waveform.fill", imageSize: 40, score: "\(viewModel.currentUser?.bloger ?? 0)/20")
//                                .opacity((viewModel.currentUser?.bloger ?? 0) >= 20 ? 1 : 0.3)
//                            AchievementsItem(text: "", backgroundImage: "shield.fill", image: "video.bubble.left.fill", imageSize: 40, score: "\(viewModel.currentUser?.bloger ?? 0)/50")
//                                .opacity((viewModel.currentUser?.bloger ?? 0) >= 50 ? 1 : 0.3)
//                        }
//                    }
//                }
//                .listRowBackground(Color.clear)
            }
//            .listStyle(.grouped)
            .navigationTitle("achievements")
        }
    }
}

//#Preview {
//    AchievementsMainView()
//}
