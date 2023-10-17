//
//  AllPeopleView.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 7/19/23.
//

import SwiftUI
import SwiftData

struct AllPeopleView: View {
    @Query (sort: \Items.orderIndex, order: .forward) var items: [Items]
    @Query (sort: \ItemsTitle.timeStamp, order: .forward) var itemTitles: [ItemsTitle]
    @State private var searchText = ""
    @State private var currentItem: Items?
    let notify = NotificationHandler()
    @State private var lastItem: Items?
    @EnvironmentObject var viewModel: AppViewModel
    
    
    
    
    
    var body: some View {
        NavigationStack{
            List{
                ForEach(items, id: \.self){ item in
                    if !item.isCheked{
                        Button(action: {
                            currentItem = item
                        }){
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
                                            Text(viewModel.twoNames(name: item.name))
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
                                Spacer()
                                Image(systemName: item.isLiked ? "heart.fill" : "")
                                    .foregroundStyle(Color(K.Colors.red))
                                    .contentTransition(.symbolEffect(.replace))
                                    .padding()
                                    .onTapGesture {
                                        withAnimation{
                                            item.isLiked.toggle()
                                        }
                                    }
                            }
                            .swipeActions(edge: .trailing) {
                                Button(role: .destructive, action: {
                                    //                                        modelContext.delete(item)
                                    withAnimation{
                                        item.isCheked.toggle()
                                    }
                                    notify.stopNotifying(type: "birthday", name: item.name)
                                    lastItem = item
                                    
                                } ) {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                            .contextMenu {
                                Button{
                                    withAnimation{
                                        item.isLiked.toggle()
                                    }
                                } label: {
                                    Label("Favourite", systemImage: item.isLiked ? "heart.fill" : "heart")
                                        .accentColor(Color(K.Colors.red))
                                        .contentTransition(.symbolEffect(.replace))
                                    
                                }
                                Button(role: .destructive) {
                                    //                                        modelContext.delete(item)
                                    //                                        try? modelContext.save()
                                    withAnimation{
                                        item.isCheked.toggle()
                                    }
                                    notify.stopNotifying(type: "birthday", name: item.name)
                                    lastItem = item
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                        }
                        .sheet(item: $currentItem, onDismiss: nil){ item in
//                            NavigationStack{
//                                ItemPersonView(item: item)
//                                    .toolbar{
//                                        ToolbarItem(placement: .topBarTrailing){
//                                            Button(action: {
//                                                currentItem = nil
//                                            }){
//                                                Image(systemName: "xmark.circle")
//                                            }
//                                        }
//                                    }
//                            }
//                            .accentColor(Color.white)
                            
                        }
                    }
                }
                .onDelete(perform: { indexSet in
                    withAnimation{
                        for index in indexSet {
                            items[index].isCheked.toggle()
                            let name = items[index].name
                            notify.stopNotifying(type: "birthday", name: name)
                            lastItem = items[index]
                        }
                    }
                    
                })
                .onMove { source, destination in
                    
                    let list = items
                    // Make a copy of the current list of items
                    var updatedItems = list
                    
                    // Apply the move operation to the items
                    updatedItems.move(fromOffsets: source, toOffset: destination)
                    
                    // Update each item's relative index order based on the new items
                    // Can extract and reuse this part if the order of the items is changed elsewhere (like when deleting items)
                    // The iteration could be done in reverse to reduce changes to the indices but isn't necessary
                    for (index, item) in updatedItems.enumerated() {
                        item.orderIndex = index
                    }
                    
                    //                        items.updateOrderIndices()
                }
            }
            .toolbar(content: {
                
                ToolbarItem(placement: .topBarTrailing) {
                    EditButton()
                }
            })
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
