//
//  SettingsPeopleView.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 8/30/23.
//

import SwiftUI

struct SettingsPeopleView: View {
    @State private var searchText = ""
    @State private var currentItem: Person?
    let notify = NotificationHandler()
    @State private var lastItem: Person?
    
    
    @EnvironmentObject var viewModel: AppViewModel
    @EnvironmentObject var published: PublishedVariebles

    var body: some View{
        NavigationStack{
            ScrollView(.vertical){
                VStack(alignment: .leading, spacing: 20){
                    VStack(alignment: .leading){
                        NavigationLink(destination: AllPeopleView()){
                            HStack(spacing: 29){
                                Image(systemName: "person.2")
                                    .font(.system(size: 29))
                                    .fontWeight(.light)
                                VStack(alignment: .leading, spacing: 5){
                                    Text("all-people")
                                        .fontWeight(.semibold)
                                        .font(.system(size: 15))
                                        .foregroundStyle(.primary)
                                    Text("list-of-all-people")
                                        .font(.system(size: 11))
                                        .foregroundStyle(.secondary)
                                }
                                Spacer()
                                Image(systemName: "chevron.forward")
                                    .frame(width: 28)
                            }
                            .padding(.horizontal, 25)
                        }
                        .navigationDestination(
                            isPresented: Binding(
                                get: { published.currentPeopleNavigationLink == "allpeople-view" },
                                set: { newValue in
                                    published.currentPeopleNavigationLink = newValue ? "allpeople-view" : nil
                                }
                            )
                        ) {
                            AllPeopleView()
                                .onAppear(perform: {
                                    published.tabsAreHidden = true
                                })
                                    .toolbar(.hidden, for: .tabBar)
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
                                    Text("all-your-stages")
                                        .fontWeight(.semibold)
                                        .font(.system(size: 15))
                                        .foregroundStyle(.primary)
                                    Text("list-of-all-stages")
                                        .font(.system(size: 11))
                                        .foregroundStyle(.secondary)
                                }
                                Spacer()
                                Image(systemName: "chevron.forward")
                                    .frame(width: 28)
                            }
                            .padding(.horizontal, 25)
                        }
                        .navigationDestination(
                            isPresented: Binding(
                                get: { published.currentPeopleNavigationLink == "allstages-view" },
                                set: { newValue in
                                    published.currentPeopleNavigationLink = newValue ? "allstages-view" : nil
                                }
                            )
                        ) {
                            AllStagesView()
                                .onAppear(perform: {
                                    published.tabsAreHidden = true
                                })
                                    .toolbar(.hidden, for: .tabBar)
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
                                        Text("done-people")
                                            .fontWeight(.semibold)
                                            .font(.system(size: 15))
                                            .foregroundStyle(.primary)
                                        Text("list-of-people-that-joined-group")
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
                            .navigationDestination(
                                isPresented: Binding(
                                    get: { published.currentPeopleNavigationLink == "donepeople-view" },
                                    set: { newValue in
                                        published.currentPeopleNavigationLink = newValue ? "donepeople-view" : nil
                                    }
                                )
                            ) {
                                DonePeople()
                                    .onAppear(perform: {
                                        published.tabsAreHidden = true
                                    })
                                        .toolbar(.hidden, for: .tabBar)
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
                                    Text("favourite-people")
                                        .fontWeight(.semibold)
                                        .font(.system(size: 15))
                                        .foregroundStyle(.primary)
                                    Text("list-of-favourite-people")
                                        .font(.system(size: 11))
                                        .foregroundStyle(.secondary)
                                }
                                Spacer()
                                Image(systemName: "chevron.forward")
                                    .frame(width: 28)
                            }
                            .padding(.horizontal, 25)
                        }
                        
                        .navigationDestination(
                            isPresented: Binding(
                                get: { published.currentPeopleNavigationLink == "likedpeople-view" },
                                set: { newValue in
                                    published.currentPeopleNavigationLink = newValue ? "likedpeople-view" : nil
                                }
                            )
                        ) {
                            LikedPeopleView()
                                .onAppear(perform: {
                                    published.tabsAreHidden = true
                                })
                                    .toolbar(.hidden, for: .tabBar)
                        }
                        Divider()
                    }
                }
                .accentColor(Color(K.Colors.lightGray))
                
            }
            .navigationTitle("people")
        }
    }
}

#Preview {
    SettingsPeopleView()
}
