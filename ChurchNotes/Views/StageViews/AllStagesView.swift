//
//  AllStagesView.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 8/30/23.
//

import SwiftUI

struct AllStagesView: View {
    @EnvironmentObject var viewModel: AppViewModel
    @Environment(\.dismissSearch) private var dismissSearch

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
        return searchText.isEmpty ? viewModel.stagesArray.sorted(by: { $0.orderIndex < $1.orderIndex }) : viewModel.stagesArray.filter { $0.name.contains(searchText)}
    }
    private var appStages: [AppStage]{
        return searchText.isEmpty ? K.AppStages.stagesArray.sorted(by: { $0.orderIndex < $1.orderIndex }) : K.AppStages.stagesArray.filter { $0.name.contains(searchText)}
    }
    
    var body: some View {
        ZStack(alignment: .bottom){
                List{
                    ForEach(appStages){ item in
                        VStack(alignment: .leading){
                            NavigationLink(destination: PeopleView(itemTitles: item.name)){
                                HStack(spacing: 29){
                                        Image(systemName: "folder.badge.gearshape")
                                            .font(.system(size: 29))
                                            .fontWeight(.light)
                                            .foregroundStyle(K.Colors.mainColor, Color.primary)
                                    VStack(alignment: .leading, spacing: 5){
                                        Text(item.name)
                                            .fontWeight(.semibold)
                                            .font(.subheadline)
                                            .foregroundStyle(.primary)
                                        Text("\(viewModel.peopleArray.filter { $0.title.contains(item.name) }.count) people-in-stage")
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    }
                                }
                            }
                        }
                    }
                    .accentColor(Color(K.Colors.lightGray))
                    ForEach(sortedStages){ item in
                        VStack(alignment: .leading){
                            NavigationLink(destination: PeopleView(itemTitles: item.name)){
                                HStack(spacing: 29){
                                        Image(systemName: "folder.badge.person.crop")
                                            .font(.system(size: 29))
                                            .fontWeight(.light)
                                            .foregroundStyle(K.Colors.mainColor, Color.primary)
                                    VStack(alignment: .leading, spacing: 5){
                                        Text(item.name)
                                            .fontWeight(.semibold)
                                            .font(.system(size: 15))
                                            .foregroundStyle(.primary)
                                        Text("\(viewModel.peopleArray.filter { $0.title.contains(item.name) }.count) people-in-stage")
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    }
                                }
                            }
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
                    if !searchText.isEmpty && appStages.isEmpty && sortedStages.isEmpty{
                        Section(header: Text("you-do-not-have-stage-with-name '\(searchText)'")){
                            Button(action: {
                                self.searchText = ""
                                self.presentSheet = true
                                dismissSearch()
                            }){
                                Label("create", systemImage: "person.badge.plus")
                                    .foregroundColor(Color.black)
                                    .padding(.vertical, 10)
                                    .frame(maxWidth: .infinity)
                                    .background(K.Colors.mainColor)
                                    .cornerRadius(7)
                            }
                        }
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
                    .background(K.Colors.mainColor)
                    .cornerRadius(7)
            }
            
            .padding(15)
        }
        .background(
            Color(K.Colors.listBg)
        )
        .sheet(isPresented: $presentSheet){
            NavigationStack{
                CreateStageView(presentSheet: $presentSheet)
            }
            .edgesIgnoringSafeArea(.bottom)
            .background(K.Colors.mainColor)
            .presentationDetents([.medium])
        }
        .sheet(item: $stage){ item in
            NavigationStack{
                EditStageView(stage: $stage)
                    .accentColor(K.Colors.mainColor)
            }
            .edgesIgnoringSafeArea(.bottom)
            .background(K.Colors.mainColor)
            .presentationDetents([.medium])
        }
        .navigationTitle("sstages")
    }
}

//#Preview {
//    AllStagesView()
//}
