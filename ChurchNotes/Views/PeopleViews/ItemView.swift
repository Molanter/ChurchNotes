//
//  ItemView.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 7/2/23.
//

import SwiftUI
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore


struct ItemView: View {
    @EnvironmentObject var viewModel: AppViewModel
    @EnvironmentObject var published: PublishedVariebles
    @Environment(\.isSearching) private var isSearching
    @Environment(\.dismissSearch) private var dismissSearch
    
    
    @State var showAddPersonView = false
    @State var presentSheet = false
    @State var finishImage: Data?
    @State var sheetPesonInfo = false
    @State var currentTab: Int = 0
    @State var searchTab: Int = 0
    @State private var currentItem: Person?
    @State private var lastItem: Person?
    @State private var isShowingDeleteAlert = false
    @State var presentStageSheet = false
    @State var showActionSheet = false
    @State var deleteItem: Notifics?

    let notify = NotificationHandler()
    
    private var sortedAppStages: [AppStage]{
        return K.AppStages.stagesArray.sorted(by: { $0.orderIndex < $1.orderIndex })
    }
    private var sortedStages: [Stage]{
        return viewModel.stagesArray.sorted(by: { $0.orderIndex < $1.orderIndex })
    }
    private var itemTitles: String{
        return published.nowStage == 0 ? sortedAppStages[currentTab].title : (sortedStages.isEmpty ? "" : sortedStages[currentTab].name)
        
    }
    private var people: [Person] {
        return viewModel.peopleArray.filter { $0.title.contains(itemTitles) }
    }
    private var filteredNames: [Person] {
        return isSearching ? viewModel.peopleArray.sorted(by: { $0.orderIndex < $1.orderIndex }).sorted(by: { $0.isLiked && !$1.isLiked }).filter { $0.name.contains(published.searchText)} : people.sorted(by: { $0.orderIndex < $1.orderIndex })
    }
    private var filteredItems: [Person] {
        return isSearching ? (published.searchText.isEmpty ? viewModel.peopleArray.sorted(by: { $0.orderIndex < $1.orderIndex }).sorted(by: { $0.isLiked && !$1.isLiked }) : filteredNames.filter { $0.name.contains(published.searchText)}) : filteredNames.sorted(by: { $0.isLiked && !$1.isLiked })
    }
    
    //        init() {
    //                let appearance = UINavigationBarAppearance()
    //                appearance.shadowColor = .clear
    //                UINavigationBar.appearance().standardAppearance = appearance
    //                UINavigationBar.appearance().scrollEdgeAppearance = appearance
    //        }
    
    
    var body: some View{
        NavigationView{
            ZStack(alignment: .center){
//                if viewModel.peopleArray.isEmpty{
//                    ProgressView()
//                        .padding()
//                }else{
                    if isSearching{
                        SearchView(filteredItems: filteredItems)
                            .onDisappear {
                                if published.currentItem != nil{
                                    currentItem = published.currentItem
                                    published.currentItem = nil
                                }
                                if self.published.createPersonName != ""{
                                    self.showAddPersonView = true
                                }
                            }
                    }else{
                            List{
                                if published.nowStage == 0{
                                    appStages
                                }else if published.nowStage == 1{
                                    if !sortedStages.isEmpty{
                                        youStages
                                    }else{
                                        VStack(alignment: .leading, spacing: 10, content: {
                                            Image(systemName: "questionmark.folder")
                                                .font(.largeTitle)
                                            Text("you-do-not-have-your-own-stages-yet")
                                                .font(.title)
                                                .bold()
                                            Text("create-your-first-stage-to-see-it-here")
                                                .font(.title2)
                                            Button(action: {
                                                self.presentStageSheet.toggle()
                                            }){
                                                HStack{
                                                    Spacer()
                                                    Text("create")
                                                        .foregroundColor(Color.white)
                                                        .padding(.vertical, 10)
                                                        .padding(.leading)
                                                    Image(systemName: "folder.badge.plus")
                                                        .foregroundColor(Color.white)
                                                        .padding(.leading)
                                                    Spacer()
                                                }
                                            }
                                            .frame(maxWidth: .infinity)
                                            .background(Color(K.Colors.mainColor))
                                            .cornerRadius(7)
                                        })
                                        .padding(.horizontal, 15)
                                    }
                                }
                            }
                            .refreshable{
                                viewModel.fetchPeople()
                            }
                            .headerProminence(.standard)
                            .scrollContentBackground(.hidden)
                            .listStyle(.plain)
                            .frame(maxHeight: .infinity)
                    }
//                }
            }
            
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onAppear(perform: {
                self.published.nowStage = K.choosedStages
                
            })
            .onChange(of: published.nowStage) { old, new in
                K.choosedStages = new
            }
            .onChange(of: isSearching, { old, new in
                published.tabsAreHidden = new
            })
            .toolbar(content: {
                if !sortedStages.isEmpty {
                    ToolbarItem(placement: .topBarTrailing, content: {
                        Button(action: {self.showAddPersonView = true}){
                            Image(systemName: "person.badge.plus")
                                .foregroundStyle(Color(K.Colors.mainColor))
                        }
                    })
                }
                if !filteredItems.isEmpty{
                    ToolbarItem(placement: .topBarLeading) {
                        EditButton()
                    }
                }
                
            ToolbarItem(placement: .principal) {
                Text(published.nowStage == 0 ? "app-stages" : "my-stages")
//                    .foregroundStyle(Color(K.Colors.mainColor))
                    
                }
            })
            .toolbarTitleMenu { // ADD THIS!
                            Button("app-stages") {
                                if published.nowStage == 1{
                                    self.currentTab = 0
                                }
                                published.nowStage = 0
                            }.buttonStyle(.borderedProminent)
                            
                            Button("my-stages") {
                                if published.nowStage == 0{
                                    self.currentTab = 0
                                }
                                published.nowStage = 1
                            }.buttonStyle(.borderedProminent)
                        }
            .onAppear(perform: {
                published.nowStage = K.choosedStages
            })
            .sheet(isPresented: $presentStageSheet){
                NavigationStack{
                    CreateStageView(presentSheet: self.$presentStageSheet)
                }
                .edgesIgnoringSafeArea(.bottom)
                .background(Color(K.Colors.mainColor))
                .presentationDetents([.medium])
            }
            .sheet(isPresented: $showAddPersonView){
                NavigationStack{
                    AddPersonView(showAddPersonView: $showAddPersonView, createName: self.published.createPersonName, offset: filteredItems.startIndex, stageName: itemTitles, titleNumber: currentTab, count: viewModel.peopleArray.count)
                        .toolbar{
                            ToolbarItem(placement: .topBarLeading){
                                Button(action: {
                                    self.showAddPersonView.toggle()
                                }){
                                    Text("cancel")
                                }
                            }
                        }
                }
                .accentColor(Color(K.Colors.mainColor))
                .edgesIgnoringSafeArea(.bottom)
                .presentationDetents([.large])
            }
            
            .sheet(item: $currentItem, onDismiss: nil){ item in
                NavigationStack{
                    ItemPersonView(item: item, currentItem: $currentItem)
                        .onDisappear(perform: {
                            if viewModel.moved == 1{
                                withAnimation{
                                    currentTab += 1
                                    viewModel.moved = 0
                                }
                            }else if viewModel.moved == 2{
                                withAnimation{
                                    currentTab -= 1
                                    viewModel.moved = 0
                                }
                            }
                        })
                        .toolbar{
                            ToolbarItem(placement: .topBarLeading){
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
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    var appStages: some View {
//                    List{
        Section(header: TopBarView(currentTab: self.$currentTab, showAddStage: false, array: sortedStages, appArray: sortedAppStages, app: true)){
            ForEach(filteredItems){ item in
                if item.isCheked == false && item.isDone == false{
//                    Button(action: {
//
//                    }){
                        RowPersonModel(item: item)
                            .onTapGesture(count: 2, perform: {
                                viewModel.likePerson(documentId: item.documentId, isLiked: true)
                            })
                            .onTapGesture(count: 1, perform: {
                                currentItem = item
                                self.sheetPesonInfo.toggle()
                                print(currentTab)
                            })
                        .swipeActions(edge: .leading) {
                            Button(action: {
                                self.lastItem = item
                                self.nextStage()
                            } ) {
                                Label("next-stage", systemImage: "arrowshape.turn.up.right")
                            }
                        }
                        .alert("delete-person", isPresented: Binding(
                            get: { self.isShowingDeleteAlert && lastItem != nil },
                            set: { newValue in
                                if !newValue {
                                    self.isShowingDeleteAlert = false
                                }
                            }
                        )) {
                            Button("cancel", role: .cancel) {}
                            Button("delete", role: .destructive) {
                                viewModel.deletePerson(documentId: lastItem?.documentId ?? item.documentId)
                                isShowingDeleteAlert = false
                            }
                        } message: {
                            Text("do-you-really-want-to-delete-this-person")
                        }
                        
                        .contextMenu {
                            Button{
                                withAnimation{
                                    if item.isLiked{
                                        viewModel.likePerson(documentId: item.documentId, isLiked: false)
                                    }else{
                                        viewModel.likePerson(documentId: item.documentId, isLiked: true)
                                    }
                                }
                            } label: {
                                Label("favourite", systemImage: item.isLiked ? "\(K.favouriteSign).fill" : "\(K.favouriteSign)")
                                    .accentColor(Color(K.Colors.favouriteSignColor))
                                    .contentTransition(.symbolEffect(.replace))
                            }
                            if currentTab != 0{
                                Button{
                                    self.lastItem = item
                                    previousStage()
                                } label: {
                                    Label("previous-stage", systemImage: "arrowshape.turn.up.left")
                                }
                                
                            }
                            if currentTab != 6{
                                Button{
                                    self.lastItem = item
                                    self.nextStage()
                                } label: {
                                    Label("next-stage", systemImage: "arrowshape.turn.up.right")
                                }
                            }
                            
                            Button(role: .destructive) {
                                self.lastItem = item
                                withAnimation{
                                    self.isShowingDeleteAlert = true
                                }
                            } label: {
                                Label("delete", systemImage: "trash")
                            }
                        } preview: {
                            RowPersonModel(item: item)
                                .environmentObject(AppViewModel())
                                .padding(10)
                                .onTapGesture {
                                    currentItem = item
                                    self.sheetPesonInfo.toggle()
                                }
                                .background(Color(K.Colors.blackAndWhite))
                        }
//                    }
                }
            }
            .onDelete(perform: { indexSet in
                if let firstIndex = indexSet.first {
                    let itemToDelete = filteredItems[firstIndex]
                    // Now you can access the documentId of the itemToDelete
                    self.lastItem = itemToDelete
                    withAnimation{
                        self.isShowingDeleteAlert = true
                    }                        }
            })
            .padding(.horizontal, 0)
        }
//                    }
//                    .headerProminence(.standard)
//                    .scrollContentBackground(.hidden)
//                    .listStyle(.plain)
//                    .frame(maxHeight: .infinity)
    }
    
    var youStages: some View {
//        ZStack{
//            if !sortedStages.isEmpty{
//                List{
                    Section(header: TopBarView(currentTab: self.$currentTab, showAddStage: false, array: sortedStages, appArray: sortedAppStages, app: false)){
                        ForEach(filteredItems){ item in
                            if item.isCheked == false && item.isDone == false{
//                                Button(action: {
//
//                                }){
                                    RowPersonModel(item: item)
                                        .onTapGesture(count: 2, perform: {
                                            viewModel.likePerson(documentId: item.documentId, isLiked: true)
                                        })
                                        .onTapGesture(count: 1, perform: {
                                            currentItem = item
                                            self.sheetPesonInfo.toggle()
                                        })
                                    .alert("delete-person", isPresented: $isShowingDeleteAlert) {
                                        Button("cancel", role: .cancel) {}
                                        Button("delete", role: .destructive) {
                                            viewModel.deletePerson(documentId: lastItem?.documentId ?? item.documentId)
                                            isShowingDeleteAlert = false
                                        }
                                    } message: {
                                        Text("do-you-really-want-to-delete-this-person")
                                    }
                                    
                                    .contextMenu {
                                        Button{
                                            withAnimation{
                                                if item.isLiked{
                                                    viewModel.likePerson(documentId: item.documentId, isLiked: false)
                                                }else{
                                                    viewModel.likePerson(documentId: item.documentId, isLiked: true)
                                                }
                                            }
                                        } label: {
                                            Label("favourite", systemImage: item.isLiked ? "\(K.favouriteSign).fill" : "\(K.favouriteSign)")
                                                .accentColor(Color(K.Colors.favouriteSignColor))
                                                .contentTransition(.symbolEffect(.replace))
                                        }
                                        Button(role: .destructive) {
                                            self.lastItem = item
                                            withAnimation{
                                                self.isShowingDeleteAlert = true
                                            }
                                        } label: {
                                            Label("delete", systemImage: "trash")
                                        }
                                    } preview: {
                                        RowPersonModel(item: item)
                                            .environmentObject(AppViewModel())
                                            .padding(10)
                                            .onTapGesture {
                                                currentItem = item
                                                self.sheetPesonInfo.toggle()
                                            }
                                            .background(Color(K.Colors.blackAndWhite))
                                    }
//                                }
                            }
                        }
                        .onDelete(perform: { indexSet in
                            if let firstIndex = indexSet.first {
                                let itemToDelete = filteredItems[firstIndex]
                                // Now you can access the documentId of the itemToDelete
                                self.lastItem = itemToDelete
                                withAnimation{
                                    self.isShowingDeleteAlert = true
                                }                                }
                        })
                        .padding(.horizontal, 0)
                    }
//            }
//        }
        
        .frame(maxHeight: .infinity)
    }
    
    private func nextStage(){
        let num = viewModel.currentUser?.next ?? 0
        self.viewModel.addAchiv(name: "next", int: num + 1)
        print(num + 0)
        viewModel.nextStage(documentId: lastItem?.documentId ?? "", titleNumber: currentTab)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if viewModel.moved == 1{
                withAnimation {
                    currentTab += 1
                    viewModel.moved = 0
                }
            }
        }
        if let user = viewModel.currentUser{
            if user.next == 4{
                viewModel.addBadge(name: "Next")
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.published.currentBadge = K.Badges().nNext
                }
                viewModel.getFcmByEmail(email: user.email, messageText: "You received a new badge 'Next'", subtitle: "Congratulations", title: "New Badge", imageURL: "", link: "", badgeCount: 1)
            }else if user.next == 19{
                viewModel.addBadge(name: "nGoing")
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.published.currentBadge = K.Badges().nGoing
                }
                viewModel.getFcmByEmail(email: user.email, messageText: "You received a new badge 'Going'", subtitle: "Congratulations", title: "New Badge", imageURL: "", link: "", badgeCount: 3)
            }else if user.next == 49{
                viewModel.addBadge(name: "nnext")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.published.currentBadge = K.Badges().nnext
                    }
                viewModel.getFcmByEmail(email: user.email, messageText: "You received a new badge 'next'", subtitle: "Congratulations", title: "New Badge", imageURL: "", link: "", badgeCount: 5)
            }
        }
        self.lastItem = nil
    }
    
    private func previousStage(){
        let num = viewModel.currentUser?.next ?? 0
        self.viewModel.addAchiv(name: "next", int: num != 0 ? num - 1 : 0)
        print(num + 0)
        viewModel.previousStage(documentId: lastItem?.documentId ?? "", titleNumber: currentTab)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if viewModel.moved == 2{
                withAnimation {
                    currentTab -= 1
                    viewModel.moved = 0
                }
            }
        }
        self.lastItem = nil
    }
}

//#Preview {
//    ItemView()
//}
//
//
