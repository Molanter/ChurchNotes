//
//  TopTabBar.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 7/19/23.
//

import Foundation
import SwiftUI


struct TopBarView: View {
    @EnvironmentObject var viewModel: AppViewModel
    @Binding var currentTab: Int
    @Namespace var namespace
    @State var presentSheet = false
    @State var title = ""
    var showAddStage: Bool
    var choosedStages = K.choosedStages
    @State var nowStage = ""
    
    var array: [Stage]
    var appArray: [AppStage]
    var app: Bool
    var appStages: [Stage]{
        return viewModel.stagesArray.filter { $0.createBy.contains("string") }
    }
    
    var itemTitles: [Stage]{
        return appStages.sorted(by: { $0.orderIndex < $1.orderIndex })
    }
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 0) {
                if !app{
                    if !array.isEmpty{
                        ForEach(Array(zip(
                            self.array.indices, self.array)),
                                id: \.0,
                                content: { index, name in
                            TopBarItem(currentTab: $currentTab,
                                       namespace: namespace.self,
                                       tabBarItemName: name.name,
                                       tab: index)
                            .contextMenu {
                                Button(role: .destructive) {
                                    print("rfg")
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                        })
                        Button(action: {presentSheet.toggle()}){
                            Image(systemName: "plus.rectangle.on.folder")
                                .padding(.horizontal)
                        }
                        .foregroundColor(Color(K.Colors.mainColor))
                    }
                    if self.showAddStage{
                        Button(action: {presentSheet.toggle()}){
                            Image(systemName: "plus.rectangle.on.folder")
                                .padding(.horizontal)
                        }
                        .foregroundColor(Color(K.Colors.mainColor))
                    }
                }else{
                    ForEach(Array(zip(
                        self.appArray.indices, self.appArray)),
                            id: \.0,
                            content: { index, name in
                        TopBarItem(currentTab: $currentTab,
                                   namespace: namespace.self,
                                   tabBarItemName: name.name,
                                   tab: index)
                        .contextMenu {
                            Button(role: .destructive) {
                                
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                    })
                }
                
            }
        }
        .sheet(isPresented: $presentSheet){
            NavigationStack{
                CreateStageView(presentSheet: self.$presentSheet)
            }
            .edgesIgnoringSafeArea(.bottom)
            .background(Color(K.Colors.mainColor))
            .presentationDetents([.medium])
        }
        .frame(height: 30)
    }
    func addItemTitle(){
        viewModel.saveStages(name: title)
        self.presentSheet.toggle()
        title = ""
    }
}



struct TopBarItem: View {
    @Binding var currentTab: Int
    let namespace: Namespace.ID
    
    var tabBarItemName: String
    var tab: Int
    
    var body: some View {
        Button {
            withAnimation{
                self.currentTab = tab
            }
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


//#Preview {
//    @State var currentTab: Int = 0
//
//    TopBarView(currentTab: $currentTab)
//        .environmentObject(AppViewModel())
//}
