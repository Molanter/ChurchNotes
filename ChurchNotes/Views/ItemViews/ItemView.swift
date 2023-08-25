//
//  ItemView.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 7/2/23.
//

import SwiftUI
import SwiftData
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore
import iPhoneNumberField

struct ItemView: View {
    @Environment(\.modelContext) private var modelContext
    @Query (sort: \ItemsTitle.timeStamp, order: .forward) var titles: [ItemsTitle]
    @EnvironmentObject var viewModel: AppViewModel
    @Query var title: [ItemsTitle]
    @Query (sort: \Items.timestamp, order: .forward) var items: [Items]

    @State var showAddPersonView = false
    @State private var searchText = ""
    @State var presentSheet = false
    @State var finishImage: Data?
    @State var sheetPesonInfo = false
    @State var currentTab: Int = 0
    @State private var currentItem: Items?
    
    var itemTitles: ItemsTitle{
        if title.isEmpty{
            addFirst()
            return titles[currentTab]
        }else{
            return titles[currentTab]
        }
    }
    var filteredNames: [Items] {
        if searchText.isEmpty {
            return itemTitles.items!.sorted(by: { $0.timestamp > $1.timestamp })
        } else {
            return itemTitles.items!.filter { $0.name.contains(searchText) }
        }
    }
    
    //    init() {
    //            let appearance = UINavigationBarAppearance()
    //            appearance.shadowColor = .clear
    //            UINavigationBar.appearance().standardAppearance = appearance
    //            UINavigationBar.appearance().scrollEdgeAppearance = appearance
    //    }
    
    var body: some View {
        NavigationStack{
            List{
                Section(header: TopBarView(currentTab: self.$currentTab)){
                    ForEach(filteredNames, id: \.self){item in
                        Button(action: {
                            currentItem = item
                            self.sheetPesonInfo.toggle()
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
                            }
                                                                .swipeActions(edge: .trailing) {
                                                                    Button(role: .destructive, action: {
                                                                        modelContext.delete(item)
                                                                    } ) {
                                                                        Label("Delete", systemImage: "trash")
                                                                    }
                                                                }
                                                                .contextMenu {
                                                                    Button(role: .destructive) {
                                                                        modelContext.delete(item)
                                                                        try? modelContext.save()
                                                                    } label: {
                                                                        Label("Delete", systemImage: "trash")
                                                                    }
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
                    .onDelete(perform: delete)
                    .padding(.horizontal, 0)
                }
            }
            .toolbar(content: {
                ToolbarItem(placement: .topBarTrailing, content: {
                    Button(action: {self.showAddPersonView.toggle()}){
                        Image(systemName: "person.badge.plus")
                            .foregroundStyle(Color(K.Colors.mainColor))
                    }
                })
                ToolbarItem(placement: .topBarLeading) {
                    EditButton()
                }
            })
            .scrollContentBackground(.hidden)
            .listStyle(.plain)
            .frame(maxHeight: .infinity)
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .automatic), prompt: "Search Name")
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
        .sheet(isPresented: $showAddPersonView){
            NavigationStack{
                AddPersonView(showAddPersonView: $showAddPersonView, title: itemTitles)
                    .toolbar{
                        ToolbarItem(placement: .topBarLeading){
                            Button(action: {
                                self.showAddPersonView.toggle()
                            }){
                                Text("Cancel")
                            }
                        }
                    }
            }
            .accentColor(Color(K.Colors.mainColor))
            .edgesIgnoringSafeArea(.bottom)
            .presentationDetents([.medium, .large])
        }
        .frame(maxHeight: .infinity)
    }
    
    func addFirst(){
        var newItemTitle = ItemsTitle(name: "New Friend")
        modelContext.insert(newItemTitle)
        newItemTitle = ItemsTitle(name: "Invited")
        modelContext.insert(newItemTitle)
        newItemTitle = ItemsTitle(name: "Attanded")
        modelContext.insert(newItemTitle)
        newItemTitle = ItemsTitle(name: "Baptized")
        modelContext.insert(newItemTitle)
        newItemTitle = ItemsTitle(name: "Acepted Christ")
        modelContext.insert(newItemTitle)
        newItemTitle = ItemsTitle(name: "Serving")
        modelContext.insert(newItemTitle)
        newItemTitle = ItemsTitle(name: "Joined Group")
        modelContext.insert(newItemTitle)
    }
    
    private func delete(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
    
//    func deleteItem(_ item: Items) {
//        modelContext.delete(item)
//    }
}

//#Preview {
//    @Query var itemTitles: [ItemsTitle]
//    ItemView()
//    .modelContainer(for: [UserProfile.self, Items.self, ItemsTitle.self])
//
//}


