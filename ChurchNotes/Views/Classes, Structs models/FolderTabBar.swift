//
//  FolderTabBar.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 8/28/23.
//

import Foundation
import SwiftUI
import SwiftData


struct FolderTabBar: View {
    @Binding var currentTab: Int
    @Namespace var namespace
    @Environment(\.modelContext) private var modelContext
    @Query (sort: \ItemsTitle.timeStamp, order: .forward) var titles: [ItemsTitle]
    @State var presentSheet = false
    @State var title = ""
    
    
    
    
    @Query (sort: \Items.name, order: .forward) var items: [Items]

    
    @State private var searchText = ""
    @State private var currentItem: Items?
    @EnvironmentObject var viewModel: AppViewModel
    var itemTitles: ItemsTitle{
        if titles.isEmpty{
            addFirst()
            return titles[currentTab]
        }else{
            return titles[currentTab]
        }
    }
    var filteredNames: [Items] {
        if searchText.isEmpty {
            return itemTitles.items.sorted(by: { $0.timestamp > $1.timestamp })
        } else {
            return itemTitles.items.filter { $0.name.contains(searchText) }
        }
    }
    
    
    
    
    
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
                if titles.isEmpty{
                    Button(action: {presentSheet.toggle()}){
                        Image(systemName: "plus.rectangle.on.folder")
                    }
                    .foregroundColor(Color(K.Colors.mainColor))
                    .padding(.top, 45)
                    .padding(.bottom, 10)
                }else{
                    ForEach(Array(zip(
                        self.titles.indices, self.titles)),
                            id: \.0,
                            content: { index, name in
                        VStack(alignment: .leading){
                            FolderTabBarItem(currentTab: $currentTab,
                                             tabBarItemName: name.name,
                                             tab: index)
                            .padding(.horizontal)
                            if currentTab == index{
                                    Text("fgh")
                                    ForEach(titles[currentTab].items){ item in
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
                                
                                .scrollContentBackground(.hidden)
                                .listStyle(.plain)
                                .frame(maxHeight: .infinity)
                                .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .automatic), prompt: "Search Name")
                                .tabViewStyle(.page(indexDisplayMode: .never))
                            }
                        }

                        
                    })
                    .frame(maxWidth: UIScreen.screenWidth)

                    Button(action: {presentSheet.toggle()}){
                        Image(systemName: "plus.rectangle.on.folder")
                            .padding(.horizontal)
                    }
                    .foregroundColor(Color(K.Colors.mainColor))
                }
                
        }
        .frame(maxWidth: UIScreen.screenWidth)
        .onAppear{
            if titles.isEmpty{
                addFirst()
            }
            
        }
        .sheet(isPresented: $presentSheet){
            NavigationStack{
                VStack(alignment: .leading, spacing: 20){
                    Text("Write New Title Name")
                        .font(.title2)
                        .fontWeight(.medium)
                    HStack{
                        TextField("New Title Name", text: $title)
                            .onSubmit {
                                addItemTitle()
                            }
                    }
                    .padding(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5.0).stroke(Color(K.Colors.darkGray), lineWidth: 1)
                    )
                    Button(action: {addItemTitle()}){
                        Text("Add")
                            .foregroundColor(Color.white)
                    }
                    .padding(.vertical, 10)
                    .frame(maxWidth: .infinity)
                    .background(Color(K.Colors.mainColor))
                    .cornerRadius(7)
                }
                .padding(15)
                Spacer()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding()
                    .toolbar{
                        ToolbarItem(placement: .navigationBarLeading){
                            Button(action: {
                                presentSheet.toggle()
                            }){
                                Text("Cancel")
                                    .foregroundColor(Color(K.Colors.mainColor))
                            }
                        }
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button(action: {addItemTitle()}){
                                Text("Save")
                                    .foregroundColor(Color(K.Colors.mainColor))
                            }
                        }
                    }
                    .edgesIgnoringSafeArea(.bottom)
                Spacer()
            }
            .edgesIgnoringSafeArea(.bottom)
            .background(Color(K.Colors.mainColor))
            .presentationDetents([.medium, .large])
        }
//        .padding(.horizontal, 50)
        
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
    func addItemTitle(){
        let newItemTitle = ItemsTitle(name: title)
        modelContext.insert(newItemTitle)
        title = ""
        self.presentSheet.toggle()
    }
}

struct FolderTabBarItem: View {
    
    
    
    
    @Binding var currentTab: Int
    //    let namespace: Namespace.ID
    //
    var tabBarItemName: String
    var tab: Int
    
    var body: some View {
        VStack{
            Button {
                self.currentTab = tab
            } label: {
                ZStack {
                    
                    
                    //                    .foregroundColor(currentTab == tab ? Color(K.Colors.mainColor) : Color(K.Colors.mainColor).opacity(0.5))
                    
                    
                    VStack(alignment: .leading){
                        HStack(alignment: .top, spacing: -58){
                            ZStack(alignment: .center){
                                RoundedRectangle(cornerRadius: 7)
                                    .fill(currentTab == tab ? Color(K.Colors.mainColor) : Color(K.Colors.darkGray))
                                Text(tabBarItemName)
                                    .font(.system(size: 13))
                                    .fontWeight(.regular)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 15)
                            }
                            .frame(width: 160, height: 45)
                            RoundedRectangle(cornerRadius: 7)
                                .fill(currentTab == tab ? Color(K.Colors.mainColor) : Color(K.Colors.darkGray))
                                .offset(y: -31)
                                .frame(width: 45, height: 35)
                                .rotationEffect(Angle(degrees: 55), anchor: .bottomLeading)
                            
                        }
                        RoundedRectangle(cornerRadius: 7)
                            .fill(currentTab == tab ? Color(K.Colors.mainColor) : Color(K.Colors.darkGray))
                            .offset(y: -22)
                            .frame(width: UIScreen.screenWidth, height: 23)
                    }
                }
                .frame(alignment: .leading)
                
            }
            .animation(.easeInOut, value: self.currentTab)
            .buttonStyle(.plain)
        }
    }
    
}


//#Preview {
//
//    FolderTabBarItem()
//        .environmentObject(AppViewModel())
//        .modelContainer(for: [UserProfile.self, Items.self, ItemsTitle.self])
//}
//

