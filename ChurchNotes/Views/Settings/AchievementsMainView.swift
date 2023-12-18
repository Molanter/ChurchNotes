//
//  AchievementsMainView.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 11/28/23.
//

import SwiftUI

struct AchievementsMainView: View {
    @EnvironmentObject var viewModel: AppViewModel

    var body: some View {
        NavigationStack{
            List{
                Section(header: Text("next-stage"), footer: Text("achievement-for-next")) {
                    ScrollView(.horizontal){
                        HStack{
                            AchievementsItem(text: "", backgroundImage: "shield", image: "medal", imageSize: 40, score: "\(viewModel.currentUser?.next ?? 0)/5", imageColor: Color.brown)
                            AchievementsItem(text: "", backgroundImage: "shield", image: "medal", imageSize: 40, score: "\(viewModel.currentUser?.next ?? 0)/20", imageColor: Color.gray)
                                .opacity((viewModel.currentUser?.next ?? 0) >= 20 ? 1 : 0.3)
                            AchievementsItem(text: "", backgroundImage: "shield", image: "medal", imageSize: 40, score: "\(viewModel.currentUser?.next ?? 0)/50", imageColor: Color.yellow)
                                .opacity((viewModel.currentUser?.next ?? 0) >= 50 ? 1 : 0.3)
                        }
                    }
                }
                .onAppear(perform: {
                    print(viewModel.currentUser?.next ?? 0)
                })
                .listRowBackground(Color.clear)
                Section(header: Text("done"), footer: Text("achievement-for-last-stage")) {
                    ScrollView(.horizontal){
                        HStack{
                            AchievementsItem(text: "", backgroundImage: "shield.fill", image: "trophy", imageSize: 40, score: "\(viewModel.currentUser?.done ?? 0)/0", image2: "3")
                            AchievementsItem(text: "", backgroundImage: "shield.fill", image: "trophy", imageSize: 40, score: "\(viewModel.currentUser?.done ?? 0)/5", image2: "2")
                                .opacity((viewModel.currentUser?.done ?? 0) >= 5 ? 1 : 0.3)
                            AchievementsItem(text: "", backgroundImage: "shield.fill", image: "trophy", imageSize: 40, score: "\(viewModel.currentUser?.done ?? 0)/15", image2: "1")
                                .opacity((viewModel.currentUser?.done ?? 0) >= 15 ? 1 : 0.3)
                        }
                    }
                }
                .listRowBackground(Color.clear)
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
            .listStyle(.grouped)
            .navigationTitle("achievements")
        }
    }
}

#Preview {
    AchievementsMainView()
}
