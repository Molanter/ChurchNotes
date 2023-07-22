//
//  TopTabBar.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 7/19/23.
//

import Foundation
import SwiftUI
import SwiftData


struct TopBarView: View {
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
                    .foregroundColor(Color(K.Colors.mainColor))
                    .padding(.top, 50)
                    .padding(.bottom, 10)
                }else{
                    ForEach(Array(zip(
                        self.itemTitles.indices, self.itemTitles)),
                            id: \.0,
                            content: {
                        index, name in
                        TopBarItem(currentTab: $currentTab,
                                   namespace: namespace.self,
                                   tabBarItemName: name.name,
                                   tab: index)
                    })
                    Button(action: {presentSheet.toggle()}){
                        Image(systemName: "plus")
                    }
                    .foregroundColor(Color(K.Colors.mainColor))
                }
                
            }
        }
        .padding(.horizontal, 15)
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
            .background(Color(K.Colors.mainColor))
            .presentationDetents([.medium, .large])
        }
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

struct TopBarItem: View {
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
                    .font(.system(size: 13))
                    .fontWeight(.regular)
                    .foregroundColor(currentTab == tab ? Color(K.Colors.mainColor) : Color(K.Colors.mainColor).opacity(0.5))
                    .padding(.horizontal, 30)
                if currentTab == tab {
                    Color(K.Colors.mainColor)
                        .frame(height: 5)
                        .matchedGeometryEffect(id: "underline",
                                               in: namespace,
                                               properties: .frame)
                } else {
                    Color(K.Colors.mainColor)
                        .opacity(0.5)
                        .frame(height: 5)
                }
            }
            .animation(.spring(), value: self.currentTab)
        }
        .buttonStyle(.plain)
    }
}
