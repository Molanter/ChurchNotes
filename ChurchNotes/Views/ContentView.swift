//
//  ContentView.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 6/28/23.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State var tabBarView = TabBarView.self
    @Query (sort: \ItemsTitle.timeStamp, order: .forward, animation: .spring) var itemTitles: [ItemsTitle]
    @State var currentTab: Int = 0
    @State var currentTa: Int = 99
    var body: some View {
        VStack (spacing: 0){
            TabBarView(currentTab: self.$currentTab)

            TabView(selection: self.$currentTab) {

            ItemView(itemTitles: itemTitles[currentTab]).tag(currentTab)
                            .navigationBarHidden(true)
            }
            .swipeActions(edge: .trailing) {
                Button(action: {self.currentTab += 1} ) {
                    Label("Delete", systemImage: "trash")
                  }
                }
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
    }
}

struct TabBarView: View {
    @Binding var currentTab: Int
    @Namespace var namespace
    @Environment(\.modelContext) private var modelContext
    @Query (sort: \ItemsTitle.timeStamp, order: .forward, animation: .spring) var itemTitles: [ItemsTitle]
    @State var presentSheet = false
    @State var title = ""
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 0) {
                if itemTitles.isEmpty{
                    Button(action: {presentSheet.toggle()}){
                        Image(systemName: "plus")
                    }
                    .foregroundColor(Color(K.Colors.bluePurple))
                    .padding(.top, 50)
                    .padding(.bottom, 10)
                }else{
                    ForEach(Array(zip(
                        self.itemTitles.indices, self.itemTitles)),
                            id: \.0,
                            content: {
                        index, name in
                        TabBarItem(currentTab: $currentTab,
                                   namespace: namespace.self,
                                   tabBarItemName: name.name,
                                   tab: index)
                    })
                    Button(action: {presentSheet.toggle()}){
                        Image(systemName: "plus")
                    }
                    .foregroundColor(Color(K.Colors.bluePurple))
                }
                
            }
            .padding(.horizontal, 15)
        }
        .background(Color(K.Colors.background))
        .onAppear{
            if itemTitles.isEmpty{
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
                    .background(Color(K.Colors.bluePurple))
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
                                .foregroundColor(Color(K.Colors.lightBlue))
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {addItemTitle()}){
                            Text("Save")
                                .foregroundColor(Color(K.Colors.lightBlue))
                        }
                    }
                }
                .edgesIgnoringSafeArea(.bottom)
                Spacer()
            }
            .edgesIgnoringSafeArea(.bottom)
            .background(Color(K.Colors.bluePurple))
            .presentationDetents([.medium, .large])
        }
        .background(Color(K.Colors.background))
        .frame(height: 40)
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

struct TabBarItem: View {
    @Binding var currentTab: Int
    let namespace: Namespace.ID
    
    var tabBarItemName: String
    var tab: Int
    
    var body: some View {
        Button {
            self.currentTab = tab
        } label: {
            VStack {
                Spacer()
                Text(tabBarItemName)
                    .font(.system(size: 18))
                    .foregroundColor(currentTab == tab ? Color(K.Colors.bluePurple) : Color(K.Colors.bluePurple).opacity(0.5))
                    .padding(.horizontal, 10)
                if currentTab == tab {
                    Color(K.Colors.bluePurple)
                        .frame(height: 3)
                        .matchedGeometryEffect(id: "underline",
                                               in: namespace,
                                               properties: .frame)
                } else {
                    Color(K.Colors.bluePurple)
                        .opacity(0.5)
                        .frame(height: 3)
                }
            }
            .animation(.spring(), value: self.currentTab)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [UserProfile.self, Items.self, ItemsTitle.self])
}
