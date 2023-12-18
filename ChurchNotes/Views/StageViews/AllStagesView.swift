//
//  AllStagesView.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 8/30/23.
//

import SwiftUI

struct AllStagesView: View {
    @EnvironmentObject var viewModel: AppViewModel

    @State private var searchText = ""
    @State private var currentItem: Person?
    @State private var lastItem: Person?
    @State private var title = ""
    @State var presentSheet = false
    @State var stage: Stage?
    @State var appStage: AppStage?
    
    @State private var showActionSheet = false

    let notify = NotificationHandler()
    private var sortedStages: [Stage]{
        return viewModel.stagesArray.sorted(by: { $0.orderIndex < $1.orderIndex })
    }
    private var appStages: [AppStage]{
        return K.AppStages.stagesArray.sorted(by: { $0.orderIndex < $1.orderIndex })
    }
    
    var body: some View {
        ZStack(alignment: .bottom){
            ScrollView(.vertical){
                VStack(alignment: .leading, spacing: 20){
                    ForEach(appStages){ item in
                        VStack(alignment: .leading){
                            NavigationLink(destination: PeopleView(itemTitles: item.name)){
                                HStack(spacing: 29){
                                    ZStack(alignment: .bottomTrailing){
                                        Image(systemName: "folder.fill")
                                            .font(.system(size: 29))
                                            .fontWeight(.light)
                                        Image(systemName: "gearshape.fill")
                                            .foregroundStyle(Color(K.Colors.mainColor))
                                            .font(.system(size: 19))
                                            .fontWeight(.medium)
                                            .offset(x: 6, y: 5)
                                        
                                    }
                                    VStack(alignment: .leading, spacing: 5){
                                        Text(item.name)
                                            .fontWeight(.semibold)
                                            .font(.system(size: 15))
                                            .foregroundStyle(.primary)
                                        Text("\(viewModel.peopleArray.filter { $0.title.contains(item.name) }.count) people-in-stage")
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
                    ForEach(sortedStages){ item in
                        VStack(alignment: .leading){
                            NavigationLink(destination: PeopleView(itemTitles: item.name)){
                                HStack(spacing: 29){
                                    ZStack(alignment: .bottomTrailing){
                                        Image(systemName: "folder.fill")
                                            .font(.system(size: 29))
                                            .fontWeight(.light)
                                        Image(systemName: "person.fill")
                                            .foregroundStyle(Color(K.Colors.mainColor))
                                            .font(.system(size: 19))
                                            .fontWeight(.medium)
                                            .offset(x: 6, y: 5)
                                        
                                    }
                                    VStack(alignment: .leading, spacing: 5){
                                        Text(item.name)
                                            .fontWeight(.semibold)
                                            .font(.system(size: 15))
                                            .foregroundStyle(.primary)
                                        Text("\(viewModel.peopleArray.filter { $0.title.contains(item.name) }.count) people-in-stage")
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
                        .contextMenu {
                            Button {
                                self.stage = item
                            } label: {
                                Label("edit", systemImage: "square.and.pencil")
                            }
                            Button(role: .destructive) {
                                withAnimation{
                                    self.showActionSheet = true
                                }
                            } label: {
                                Label("delete", systemImage: "trash")
                            }
                        }
                        .actionSheet(isPresented: $showActionSheet) {
                            ActionSheet(title: Text("you-want-to-remove-this-stage '\(item.name)'?"),
                                        message: Text("press-remove-to-resume"),
                                        buttons: [
                                            .cancel(),
                                            .destructive(
                                                Text("remove")
                                            ){
                                                viewModel.deleteStage(documentId: stage?.documentId ?? "")
                                            }
                                        ]
                            )
                        }
                    }
                    .accentColor(Color(K.Colors.lightGray))
                }
            }
            .searchable(text: $searchText,
                        placement: .navigationBarDrawer(displayMode: .automatic),
                        prompt: "search-stage")
            Button(action: {
                self.presentSheet.toggle()
            }){
                Label("add-stage", systemImage: "plus.rectangle.on.folder")
                    .foregroundColor(Color.white)
                    .padding(.vertical, 10)
                    .frame(maxWidth: .infinity)
                    .background(Color(K.Colors.mainColor))
                    .cornerRadius(7)
            }
            
            .padding(15)
        }
        .sheet(isPresented: $presentSheet){
            NavigationStack{
                CreateStageView(presentSheet: $presentSheet)
            }
            .edgesIgnoringSafeArea(.bottom)
            .background(Color(K.Colors.mainColor))
            .presentationDetents([.medium])
        }
        .sheet(item: $stage){ item in
            NavigationStack{
                EditStageView(stage: $stage)
                    .accentColor(Color(K.Colors.mainColor))
            }
            .edgesIgnoringSafeArea(.bottom)
            .background(Color(K.Colors.mainColor))
            .presentationDetents([.medium])
        }
        .navigationTitle("sstages")
    }
}

#Preview {
    AllStagesView()
}
