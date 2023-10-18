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
                    NavigationLink(destination: Text("")){
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
                VStack(alignment: .leading){
                    NavigationLink(destination: Text("")){
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
                VStack{
                    NavigationLink(destination: Text("")){
                        HStack(spacing: 29){
                            ZStack(alignment: .bottomTrailing){
                                Image(systemName: "person")
                                    .font(.system(size: 35))
                                    .fontWeight(.light)
                                Image(systemName: "heart.fill")
                                    .foregroundStyle(Color(K.Colors.red))
                                    .font(.system(size: 19))
                                    .fontWeight(.light)
                                    .offset(x: 6, y: 5)
                            }
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
                VStack{
                    NavigationLink(destination: Text("")){
                        HStack(spacing: 29){
                            ZStack(alignment: .bottomTrailing){
                                Image(systemName: "person")
                                    .font(.system(size: 35))
                                    .fontWeight(.light)
                                Image(systemName: "trash.fill")
                                    .foregroundStyle(Color(K.Colors.red))
                                    .font(.system(size: 19))
                                    .fontWeight(.light)
                                    .offset(x: 6, y: 5)
                            }
                            VStack(alignment: .leading, spacing: 5){
                                Text("Deleted people")
                                    .fontWeight(.semibold)
                                    .font(.system(size: 15))
                                    .foregroundStyle(.primary)
                                Text("List of deleted people")
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
    }
}

#Preview {
    SettingsPeopleView()
}
