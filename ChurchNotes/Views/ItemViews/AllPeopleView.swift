//
//  AllPeopleView.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 7/19/23.
//

import SwiftUI
import SwiftData

struct AllPeopleView: View {
    @Query (sort: \Items.name, order: .forward) var items: [Items]
    @Query (sort: \ItemsTitle.timeStamp, order: .forward) var itemTitles: [ItemsTitle]
    @State private var searchText = ""
    @State private var currentItem: Items?

    var body: some View {
        NavigationStack{
                List(items, id: \.self){item in
                        Button(action: {currentItem = item}){
                                HStack{
                                    ZStack(alignment: .bottomTrailing){
                                        if item.imageData != nil{
                                            if let img = item.imageData{
                                                Image(uiImage: UIImage(data: img)!)
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fill)
                                                    .frame(width: 40, height: 40)
                                                    .cornerRadius(20)
                                                    .overlay(
                                                        Circle().stroke(.gray.opacity(0.6), lineWidth: 1)
                                                    )
                                            }
                                        }else{
                                            ZStack(alignment: .center){
                                                Circle()
                                                    .foregroundColor(Color(K.Colors.darkGray))
                                                    .frame(width: 40, height: 40)
                                                Text(String(item.name.components(separatedBy: " ").compactMap { $0.first }).count >= 3 ? String(String(item.name.components(separatedBy: " ").compactMap { $0.first }).prefix(2)) : String(item.name.components(separatedBy: " ").compactMap { $0.first }))
                                                    .textCase(.uppercase)
                                                    .foregroundColor(Color.white)
                                            }

                                        }
                                        Circle()
                                            .overlay(
                                                Circle().stroke(.white, lineWidth: 1)
                                            )
                                            .frame(width: 15)
                                            .foregroundColor(Color(K.Colors.green))
                                    }
                                    VStack(alignment: .leading, spacing: 3){
                                        Text(item.name.capitalized)
                                            .padding(.vertical, 3)
                                            .fontWeight(.medium)
                                            .foregroundStyle(.primary)
                                            .font(.system(size: 13))
                                        HStack(spacing: 1){
                                            Text(item.timestamp, format: .dateTime.month(.wide))
                                            Text(item.timestamp, format: .dateTime.day())
                                            Text(", \(item.timestamp, format: .dateTime.year()), ")
                                            Text(item.timestamp, style: .time)
                                        }
                                        .font(.system(size: 11))
                                        .foregroundStyle(Color(K.Colors.lightGray))
                                    }
                                }
                                .sheet(item: $currentItem, onDismiss: nil){ item in
                                    NavigationStack{
                                        ItemPersonView(item: item)
                                            .toolbar{
                                                ToolbarItem(placement: .topBarTrailing){
                                                    Button(action: {
                                                        currentItem = nil
                                                    }){
                                                        Image(systemName: "xmark.circle")
                                                    }
                                                }
                                            }
                                    }
                                        .accentColor(Color.white)
    
                                }
                            }
                }
                .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .automatic), prompt: "Search Name")
                .scrollContentBackground(.hidden)
                .listStyle(.plain)
                .frame(maxHeight: .infinity)
        }
    }
}

//#Preview {
//    AllPeopleView()
//        .environmentObject(AppViewModel())
//        .modelContainer(for: [UserProfile.self, Items.self, ItemsTitle.self])
//}
