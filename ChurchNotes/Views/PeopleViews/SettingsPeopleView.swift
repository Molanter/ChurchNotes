//
//  SettingsPeopleView.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 8/30/23.
//

import SwiftUI
import SwiftData

struct SettingsPeopleView: View {
    @State private var searchText = ""
    @State private var currentItem: Person?
    let notify = NotificationHandler()
    @State private var lastItem: Person?
    @EnvironmentObject var viewModel: AppViewModel
    
    var body: some View{
        ScrollView(.vertical){
            VStack(alignment: .leading, spacing: 20){
                VStack(alignment: .leading){
                    NavigationLink(destination: AllPeopleView()){
                        HStack(spacing: 29){
                            Image(systemName: "person.2")
                                .font(.system(size: 29))
                                .fontWeight(.light)
                            VStack(alignment: .leading, spacing: 5){
                                Text("All people")
                                    .fontWeight(.semibold)
                                    .font(.system(size: 15))
                                    .foregroundStyle(.primary)
                                Text("List of all people")
                                    .font(.system(size: 11))
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                            Image(systemName: "chevron.forward")
                                .frame(width: 28)
                        }
                        .padding(.horizontal, 25)
                    }
                    Divider()
                }
                VStack(alignment: .leading){
                    NavigationLink(destination: AllStagesView()){
                        HStack(spacing: 29){
                            Image(systemName: "folder")
                                .font(.system(size: 29))
                                .fontWeight(.light)
                            VStack(alignment: .leading, spacing: 5){
                                Text("All your stages")
                                    .fontWeight(.semibold)
                                    .font(.system(size: 15))
                                    .foregroundStyle(.primary)
                                Text("List of all stages")
                                    .font(.system(size: 11))
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                            Image(systemName: "chevron.forward")
                                .frame(width: 28)
                        }
                        .padding(.horizontal, 25)
                    }
                    Divider()
                }
                if viewModel.peopleArray.filter({ $0.isDone}).count > 0{
                    VStack(alignment: .leading){
                        NavigationLink(destination: DonePeople()){
                            HStack(spacing: 29){
                                ZStack(alignment: .center){
                                    Image(systemName: "checkmark")
                                        .offset(x: 20, y: -10)
                                        .foregroundStyle(Color(K.Colors.mainColor))
                                        .font(.system(size: 15))
                                        .fontWeight(.bold)
                                    Image(systemName: "person")
                                        .foregroundStyle(Color(K.Colors.lightGray))
                                        .font(.system(size: 29))
                                        .fontWeight(.light)
                                }
                                VStack(alignment: .leading, spacing: 5){
                                    Text("Done People")
                                        .fontWeight(.semibold)
                                        .font(.system(size: 15))
                                        .foregroundStyle(.primary)
                                    Text("List of people that Joined Group")
                                        .frame(alignment: .leading)
                                        .font(.system(size: 11))
                                        .foregroundStyle(.secondary)
                                }
                                Spacer()
                                Image(systemName: "chevron.forward")
                                    .frame(width: 28)
                            }
                            .padding(.horizontal, 25)
                        }
                        Divider()
                    }
                }
                VStack{
                    NavigationLink(destination: LikedPeopleView()){
                        HStack(spacing: 29){
                                Image(systemName: "\(K.favouriteSign)")
                                .foregroundStyle(Color(K.Colors.favouriteSignColor))
                                    .font(.system(size: 35))
                                    .fontWeight(.light)
                            VStack(alignment: .leading, spacing: 5){
                                Text("Favourite people")
                                    .fontWeight(.semibold)
                                    .font(.system(size: 15))
                                    .foregroundStyle(.primary)
                                Text("List of favourite People")
                                    .font(.system(size: 11))
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                            Image(systemName: "chevron.forward")
                                .frame(width: 28)
                        }
                        .padding(.horizontal, 25)
                    }
                    Divider()
                }
            }
            .accentColor(Color(K.Colors.lightGray))
            
        }
        .navigationTitle("People")
    }
}

#Preview {
    SettingsPeopleView()
}