//
//  DefaultPeopleList.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 9/5/24.
//

import SwiftUI
import SwiftData

struct PlainPeopleList: View {
    @EnvironmentObject var published: PublishedVariebles
    @Environment(\.isSearching) private var isSearching
    @EnvironmentObject var viewModel: AppViewModel

    @Query var strings: [StringDataModel]

    @State var showAddPersonView = false
    @State private var lastItem: Person?
    @State private var isShowingDeleteAlert = false
    @State var presentStageSheet = false
    @State private var arrayToDelete: [String] = []
    @State private var showDeleteToast = false
    @State private var arrayToSharePeople: [Person] = []
    @State private var showSearchView = false

    var people: [Person]
    
    private var sortedAppStages: [AppStage]{
        return AppStages.stagesArray.sorted(by: { $0.orderIndex < $1.orderIndex })
    }
    private var sortedStages: [Stage]{
        return viewModel.stagesArray.sorted(by: { $0.orderIndex < $1.orderIndex })
    }
    
    private var backgroundType: String {
        if let strModel = strings.first(where: { $0.name == "backgroundType" }) {
            return strModel.string
        }else {
            return "none"
        }
    }
    
    var body: some View {
        List(selection: $published.selectPeopleArray){
            Section(header: published.nowStage == 0 ? TopBarView(currentTab: self.$published.currentTab, showAddStage: false, array: sortedStages, appArray: sortedAppStages, app: true) : TopBarView(currentTab: self.$published.currentTab, showAddStage: false, array: sortedStages, appArray: sortedAppStages, app: false)) {
                ForEach(people) { item in
                    if item.isCheked == false && item.isDone == false{
                        ZStack {
                            if published.device == .phone {
                                RowPersonModel(item: item)
                            }else {
                                NavigationLink(
                                    destination: ItemPersonView(item: item, currentItem: $published.currentSplitItem),
                                    isActive: Binding(
                                    get: { published.currentSplitItem == item },
                                    set: { newValue in
                                        published.currentSplitItem = newValue ? item : nil
                                     }
                                )){
                                    RowPersonModel(item: item)
                                }
                            }
                        }
                        .listRowBackground(
                            GlassListRow(people: true)
                        )
                            .swipeActions(edge: .leading) {
                                if published.nowStage == 0 {
                                    Button(action: {
                                        self.lastItem = item
                                        self.nextStage()
                                    } ) {
                                        Label("next-stage", systemImage: "arrowshape.turn.up.right")
                                    }
                                }
                            }
                            .swipeActions(edge: .trailing){
                                    Button(role: .destructive){
                                        self.lastItem = item
                                        self.isShowingDeleteAlert = true
                                    }label: {
                                        Label("delete", systemImage: "trash")
                                    }
                            }
                            .actionSheet(isPresented: Binding(
                                get: { self.isShowingDeleteAlert && lastItem != nil },
                                set: { newValue in
                                    if !newValue {
                                        self.isShowingDeleteAlert = false
                                    }
                                }
                            )) {
                                ActionSheet(title: Text("delete-person"),
                                            message: Text("do-you-really-want-to-delete-this-person"),
                                            buttons: [
                                                .cancel(),
                                                .destructive(
                                                    Text("delete")
                                                ){
                                                    withAnimation{
                                                        viewModel.deletePerson(documentId: lastItem?.documentId ?? item.documentId)
                                                        isShowingDeleteAlert = false
                                                        viewModel.fetchPeople()
                                                    }
                                                }
                                            ]
                                )
                            }
                            .contextMenu {
                                Button{
                                    withAnimation{
                                        if item.isLiked{
                                            viewModel.likePerson(documentId: item.documentId, isLiked: false)
                                        }else{
                                            viewModel.likePerson(documentId: item.documentId, isLiked: true)
                                        }
                                        viewModel.fetchPeople()
                                    }
                                } label: {
                                    Label("favourite", systemImage: item.isLiked ? "\(K.favouriteSign).fill" : "\(K.favouriteSign)")
                                        .accentColor(Color(K.Colors.favouriteSignColor))
                                        .contentTransition(.symbolEffect(.replace))
                                }
                                if published.nowStage == 0 {
                                    if published.currentTab != 6{
                                        Button{
                                            self.lastItem = item
                                            self.nextStage()
                                        } label: {
                                            Label("next-stage", systemImage: "arrowshape.turn.up.right")
                                        }
                                    }
                                    if published.currentTab != 0{
                                        Button{
                                            self.lastItem = item
                                            previousStage()
                                        } label: {
                                            Label("previous-stage", systemImage: "arrowshape.turn.up.left")
                                        }
                                        
                                    }
                                }
                                Button {
                                    self.arrayToSharePeople = []
                                    arrayToSharePeople.append(item)
                                    self.showSearchView.toggle()
                                }label: {
                                    Label("share-person", systemImage: "square.and.arrow.up")
                                }
                                Section {
                                    Button(role: .destructive) {
                                        self.lastItem = item
                                        withAnimation{
                                            self.isShowingDeleteAlert = true
                                        }
                                    } label: {
                                        Label("delete", systemImage: "trash")
                                    }
                                }
                            }
                    }
                }
                .onMove(perform: { index, int in
                    var updatedItems = people
                    updatedItems.move(fromOffsets: index, toOffset: int)
                    for (index, item) in updatedItems.enumerated() {
                        updatedItems[index].orderIndex = index
                        viewModel.changeorderIndex(documentId: item.documentId, orderIndex: index)
                    }
                })
            }
        }
        .environment(\.editMode, .constant(published.isEditing ? EditMode.active : EditMode.inactive))
        .refreshable{
            viewModel.fetchPeople()
        }
        .scrollContentBackground(backgroundType == "none" ? .visible : .hidden)
        .background {
            ListBackground()
        }
        .listStyle(.plain)
    }
    
    private func previousStage(){
        let num = viewModel.currentUser?.next ?? 0
        self.viewModel.addAchiv(name: "next", int: num != 0 ? num - 1 : 0)
        print(num + 0)
        viewModel.previousStage(documentId: lastItem?.documentId ?? "", titleNumber: published.currentTab)
        
        let newName = AppStages.stagesArray.sorted(by: { $0.orderIndex < $1.orderIndex })[(self.lastItem?.titleNumber ?? 0) - 1].name
        self.lastItem?.title = newName
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if viewModel.moved == 2{
                withAnimation {
                    published.currentTab -= 1
                    viewModel.moved = 0
                }
            }
        }
        self.lastItem = nil
    }
    
    private func nextStage(){
        let num = viewModel.currentUser?.next ?? 0
        self.viewModel.addAchiv(name: "next", int: num + 1)
        print(num + 0)
        viewModel.nextStage(documentId: lastItem?.documentId ?? "", titleNumber: published.currentTab)
        
        let newName = AppStages.stagesArray.sorted(by: { $0.orderIndex < $1.orderIndex })[(self.lastItem?.titleNumber ?? 0) + 1].name
        self.lastItem?.title = newName
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if viewModel.moved == 1{
                withAnimation {
                    published.currentTab += 1
                    viewModel.moved = 0
                }
            }
        }
        if let user = viewModel.currentUser{
            if user.next == 4{
                viewModel.addBadge(name: "Next")
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.published.currentBadge = Badges().nNext
                }
                viewModel.getFcmByEmail(email: user.email, messageText: "You received a new badge 'Next'", subtitle: "Congratulations", title: "New Badge", imageURL: "", link: "", badgeCount: 1)
            }else if user.next == 19{
                viewModel.addBadge(name: "nGoing")
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.published.currentBadge = Badges().nGoing
                }
                viewModel.getFcmByEmail(email: user.email, messageText: "You received a new badge 'Going'", subtitle: "Congratulations", title: "New Badge", imageURL: "", link: "", badgeCount: 3)
            }else if user.next == 49{
                viewModel.addBadge(name: "nnext")
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.published.currentBadge = Badges().nnext
                }
                viewModel.getFcmByEmail(email: user.email, messageText: "You received a new badge 'next'", subtitle: "Congratulations", title: "New Badge", imageURL: "", link: "", badgeCount: 5)
            }
        }
        self.lastItem = nil
    }

}

//#Preview {
//    PlainPeopleList()
//}
