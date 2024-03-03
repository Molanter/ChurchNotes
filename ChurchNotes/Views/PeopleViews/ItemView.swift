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
    @State var searchTab: Int = 0
    @State private var lastItem: Person?
    @State private var isShowingDeleteAlert = false
    @State var presentStageSheet = false
    @State var showActionSheet = false
    @State var deleteItem: Notifics?
    @State private var arrayToDelete: [String] = []
    @State private var showDeleteToast = false
    let notify = NotificationHandler()
    
    private var sortedAppStages: [AppStage]{
        return K.AppStages.stagesArray.sorted(by: { $0.orderIndex < $1.orderIndex })
    }
    private var sortedStages: [Stage]{
        return viewModel.stagesArray.sorted(by: { $0.orderIndex < $1.orderIndex })
    }
    private var itemTitles: String{
        return published.nowStage == 0 ? sortedAppStages[published.currentTab].title : (sortedStages.isEmpty ? "" : sortedStages[published.currentTab].name)
        
    }
    private var filteredItems: [Person] {
        return viewModel.peopleArray.filter { $0.title.contains(itemTitles) }.sorted(by: { $0.orderIndex < $1.orderIndex }).sorted(by: { $0.isLiked && !$1.isLiked })
    }
    
    //        init() {
    //                let appearance = UINavigationBarAppearance()
    //                appearance.shadowColor = .clear
    //                UINavigationBar.appearance().standardAppearance = appearance
    //                UINavigationBar.appearance().scrollEdgeAppearance = appearance
    //        }
    
    
    var body: some View{
        NavigationView{
            ZStack{
                if isSearching{
                    SearchView()
                        .onDisappear {
                            if published.currentItem != nil{
                                published.currentItem = published.currentItem
                                published.currentItem = nil
                            }
                            if self.published.createPersonName != ""{
                                self.showAddPersonView = true
                            }
                        }
                }else{
//                    List(selection: $published.deletePeopleArray){
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
                                    .background(K.Colors.mainColor)
                                    .cornerRadius(7)
                                })
                                .padding(.horizontal, 15)
                            }
                        }
//                    }
//                    .refreshable{
//                        viewModel.fetchPeople()
//                    }
//                    .scrollContentBackground(.hidden)
//                    .listStyle(.plain)
//                    .environment(\.editMode, .constant(published.isEditing ? EditMode.active : EditMode.inactive)).animation(Animation.default)
                    

                }
                VStack{
                    Spacer()
                    if showDeleteToast{
                        HStack{
                            Image(systemName: "exclamationmark.octagon.fill")
                            Text("cancel-action")
                            Spacer()
                            Text("cancel")
                                .foregroundStyle(K.Colors.mainColor)
                                .onTapGesture {
                                    withAnimation(.snappy){
                                        published.deleteCanceled = true
                                        self.showDeleteToast = false
                                    }
                                }
                        }
                        .foregroundStyle(Color(K.Colors.blackAndWhite))
                        .padding(.horizontal,10)
                        .padding(.vertical, 10)
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color(K.Colors.text)))
                        .padding(.horizontal, 15)
                        .padding(.bottom, 15)
                        .transition(.offset(y: 200))
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .onAppear(perform: {
                self.published.nowStage = K.choosedStages
                
            })
            .onChange(of: published.nowStage) { old, new in
                K.choosedStages = new
            }
            .onChange(of: isSearching, { old, new in
                published.tabsAreHidden = new
            })
            .onChange(of: published.isEditing, { old, new in
                published.tabsAreHidden = new
            })
            .toolbar(content: {
                if !sortedStages.isEmpty {
                    ToolbarItem(placement: .topBarTrailing, content: {
                        Button(action: {self.showAddPersonView = true}){
                            Image(systemName: "person.badge.plus")
                                .foregroundStyle(K.Colors.mainColor)
                        }
                    })
                }
                if !filteredItems.isEmpty{
                    ToolbarItem(placement: .topBarLeading) {
                        Button(published.isEditing ? "Done" : "Edit"){
                            withAnimation{
                                published.isEditing.toggle()
                            }
                        }
                    }
                }
                
                ToolbarItem(placement: .principal) {
                    Text(published.nowStage == 0 ? "app-stages" : "my-stages")
                    
                }
                if published.isEditing{
                    ToolbarItem(placement: .bottomBar) {
                        HStack{
                                Button{
                                    published.isEditing = false
                                    if !published.deletePeopleArray.isEmpty{
                                        showDeletingToast()
                                    }
                                    arrayToDelete = Array(published.deletePeopleArray)
                                    print(published.deletePeopleArray)
                                }label: {
                                    Text("delete")
                                }
                                .disabled(published.deletePeopleArray.isEmpty)
                                Spacer()
                            HStack{
                                Text("\(published.deletePeopleArray.count) ")
                                Text("people-selected")
                            }
                                .foregroundStyle(Color.white)
                                Spacer()
                                Button{
                                    self.published.deletePeopleArray.removeAll()
                                }label: {
                                    Text("un-select")
                                }
                                .disabled(published.deletePeopleArray.isEmpty)
                        }
                    }
                }
            })
            .toolbarTitleMenu {
                Button("app-stages") {
                    if published.nowStage == 1{
                        published.currentTab = 0
                    }
                    published.nowStage = 0
                }.buttonStyle(.borderedProminent)
                
                Button("my-stages") {
                    if published.nowStage == 0{
                        published.currentTab = 0
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
                .background(K.Colors.mainColor)
                .presentationDetents([.medium])
            }
            .sheet(isPresented: $showAddPersonView){
                NavigationStack{
                    AddPersonView(showAddPersonView: $showAddPersonView, createName: self.published.createPersonName, offset: filteredItems.startIndex, stageName: itemTitles, titleNumber: published.currentTab, count: viewModel.peopleArray.count)
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
                .accentColor(K.Colors.mainColor)
                .edgesIgnoringSafeArea(.bottom)
                .presentationDetents([.large])
            }
            .sheet(item: $published.currentItem, onDismiss: nil){ item in
                NavigationStack{
                    ItemPersonView(item: item, currentItem: $published.currentItem)
                        .onDisappear(perform: {
                            if viewModel.moved == 1{
                                withAnimation{
                                    published.currentTab += 1
                                    viewModel.moved = 0
                                }
                            }else if viewModel.moved == 2{
                                withAnimation{
                                    published.currentTab -= 1
                                    viewModel.moved = 0
                                }
                            }
                        })
                        .toolbar{
                            ToolbarItem(placement: .topBarLeading){
                                Button(action: {
                                    published.currentItem = nil
                                }){
                                    Text("cancel")
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
        List(selection: $published.deletePeopleArray){
            Section(header: TopBarView(currentTab: self.$published.currentTab, showAddStage: false, array: sortedStages, appArray: sortedAppStages, app: true)){
                ForEach(filteredItems){ item in
                    if item.isCheked == false && item.isDone == false{
                        RowPersonModel(item: item)
                            .swipeActions(edge: .leading) {
                                Button(action: {
                                    self.lastItem = item
                                    self.nextStage()
                                } ) {
                                    Label("next-stage", systemImage: "arrowshape.turn.up.right")
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
                                    }
                                } label: {
                                    Label("favourite", systemImage: item.isLiked ? "\(K.favouriteSign).fill" : "\(K.favouriteSign)")
                                        .accentColor(Color(K.Colors.favouriteSignColor))
                                        .contentTransition(.symbolEffect(.replace))
                                }
                                if published.currentTab != 0{
                                    Button{
                                        self.lastItem = item
                                        previousStage()
                                    } label: {
                                        Label("previous-stage", systemImage: "arrowshape.turn.up.left")
                                    }
                                    
                                }
                                if published.currentTab != 6{
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
                            }
                    }
                }
                .onMove(perform: { index, int in
                    var updatedItems = filteredItems
                    
                    updatedItems.move(fromOffsets: index, toOffset: int)
                    
                    for (index, item) in updatedItems.enumerated() {
                        updatedItems[index].orderIndex = index
                        viewModel.changeorderIndex(documentId: item.documentId, orderIndex: index)
                    }
                })
                .padding(.horizontal, 0)
            }
        }
        .environment(\.editMode, .constant(published.isEditing ? EditMode.active : EditMode.inactive))
        .refreshable{
            viewModel.fetchPeople()
        }
        .scrollContentBackground(.hidden)
        .listStyle(.plain)
    }
    
    var youStages: some View {
        List(selection: $published.deletePeopleArray){
            Section(header: TopBarView(currentTab: self.$published.currentTab, showAddStage: false, array: sortedStages, appArray: sortedAppStages, app: false)){
                ForEach(filteredItems){ item in
                    if item.isCheked == false && item.isDone == false{
                        RowPersonModel(item: item)
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
                            }
                    }
                }
                .padding(.horizontal, 0)
            }
            .frame(maxHeight: .infinity)
        }
        .environment(\.editMode, .constant(published.isEditing ? EditMode.active : EditMode.inactive))
        .refreshable{
            viewModel.fetchPeople()
        }
        .scrollContentBackground(.hidden)
        .listStyle(.plain)
    }
    
    private func nextStage(){
        let num = viewModel.currentUser?.next ?? 0
        self.viewModel.addAchiv(name: "next", int: num + 1)
        print(num + 0)
        viewModel.nextStage(documentId: lastItem?.documentId ?? "", titleNumber: published.currentTab)
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
        viewModel.previousStage(documentId: lastItem?.documentId ?? "", titleNumber: published.currentTab)
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
    
    private func showDeletingToast(){
        withAnimation(.snappy){
            self.showDeleteToast = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            withAnimation(.snappy){
                self.showDeleteToast = false
            }
            if !published.deleteCanceled{
                deleteSelectedSet()
            }else {
                published.deleteCanceled = false
            }
        }
    }
    
    private func deleteSelectedSet(){
        print("func", arrayToDelete)
        for person in arrayToDelete{
            print(person)
            viewModel.deletePerson(documentId: person)
        }
        print("Finished loop")
    }
}

//#Preview {
//    ItemView()
//}
//
//
