//
//  ItemView.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 7/2/23.
//

import SwiftUI
import SwiftData


struct ItemView: View {
    @EnvironmentObject var viewModel: AppViewModel
    @EnvironmentObject var published: PublishedVariebles
    @Environment(\.isSearching) private var isSearching
    @Environment(\.dismissSearch) private var dismissSearch
    
    @Query var strings: [StringDataModel]

    @State var showAddPersonView = false
    @State private var lastItem: Person?
    @State private var isShowingDeleteAlert = false
    @State var presentStageSheet = false
    @State private var arrayToDelete: [String] = []
    @State private var showDeleteToast = false
    @State private var arrayToSharePeople: [Person] = []
    @State private var showSearchView = false
    
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
    
    private var backgroundType: String {
        if let strModel = strings.first(where: { $0.name == "backgroundType" }) {
            return strModel.string
        }else {
            return "none"
        }
    }
    
    var body: some View{
        NavigationStack {
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
                    if !filteredItems.isEmpty {
                            stages
                        }else if sortedStages.isEmpty, published.nowStage == 1{
                            NoStageView(presentStageSheet: $presentStageSheet)
                        }else if viewModel.peopleArray.isEmpty {
                            NoPeopleView(presentStageSheet: $showAddPersonView)
                        }
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
                        .padding([.horizontal, .vertical],10)
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color(K.Colors.text)))
                        .padding([.horizontal, .bottom], 15)
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
                    if published.device == .phone {
                        ToolbarItem(placement: .topBarLeading) {
                            Button(published.isEditing ? "done" : "edit"){
                                withAnimation{
                                    published.isEditing.toggle()
                                }
                            }
                        }
                    }else {
                        ToolbarItem(placement: .topBarTrailing) {
                            Button(published.isEditing ? "done" : "edit"){
                                withAnimation{
                                    published.isEditing.toggle()
                                }
                            }
                            .foregroundStyle(K.Colors.mainColor)
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
                                if !published.selectPeopleArray.isEmpty{
                                    showDeletingToast()
                                }
                                arrayToDelete = Array(published.selectPeopleArray)
                                print(published.selectPeopleArray)
                            }label: {
                                Label("delete", systemImage: "trash.fill")
                            }
                            .disabled(published.selectPeopleArray.isEmpty)
                            Button{
                                let peopleArray = viewModel.peopleArray.filter { person in
                                    published.selectPeopleArray.contains(person.id)
                                }
                                if moreFavourite(Array(published.selectPeopleArray)) {
                                    for person in peopleArray {
                                        viewModel.likePerson(documentId: person.documentId, isLiked: false)
                                        withAnimation{
                                            viewModel.fetchPeople()
                                        }
                                    }
                                }else {
                                    for person in peopleArray {
                                        viewModel.likePerson(documentId: person.documentId, isLiked: true)
                                        withAnimation{
                                            viewModel.fetchPeople()
                                        }
                                    }
                                }
                                published.isEditing = false
                            }label: {
                                Label("favourite", systemImage: moreFavourite(Array(published.selectPeopleArray)) ? "heart" : "heart.fill")
                            }
                            .disabled(published.selectPeopleArray.isEmpty)
                            Spacer()
                            HStack{
                                Text("\(published.selectPeopleArray.count) ")
                                Text("people-selected")
                            }
                            .foregroundStyle(Color(K.Colors.text))
                            Spacer()
                            Button{
                                self.arrayToSharePeople = viewModel.peopleArray.filter { person in
                                    published.selectPeopleArray.contains(person.id)
                                }
                                self.showSearchView.toggle()
                            }label: {
                                Label("share-people", systemImage: "square.and.arrow.up")
                            }
                            .disabled(published.selectPeopleArray.isEmpty)
                            Button{
                                self.published.selectPeopleArray.removeAll()
                            }label: {
                                Label("un-select", systemImage: "person.2.slash.fill")
                            }
                            .disabled(published.selectPeopleArray.isEmpty)
                        }
                    }
                }
            })
            .navigationDestination(isPresented: $showSearchView) {
                SearchPersonView()
                    .navigationBarBackButtonHidden()
                    .accentColor(Color(K.Colors.text))
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            Button {
                                self.showSearchView = false
                            }label: {
                                HStack(spacing: 10){
                                    Image(systemName: "chevron.left")
                                    Text("back")
                                    Spacer()
                                }
                                .foregroundStyle(Color(K.Colors.text))
                            }
                        }
                    }
            }
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
                    AddPersonView(showAddPersonView: $showAddPersonView, createName: self.published.createPersonName, offset: filteredItems.startIndex, stageName: itemTitles, titleNumber: published.currentTab, count: viewModel.peopleArray.count)
                .presentationDetents([.large])
            }
            .sheet(item: $published.currentItem, onDismiss: nil){ item in
                ItemPersonView(item: item, currentItem: $published.currentItem)
            }
            .sheet(isPresented: $published.showShare, content: {
                SharePersonView(people: arrayToSharePeople)                        
            })
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    var stages: some View {
        List(selection: $published.selectPeopleArray){
            Section(header: published.nowStage == 0 ? TopBarView(currentTab: self.$published.currentTab, showAddStage: false, array: sortedStages, appArray: sortedAppStages, app: true) : TopBarView(currentTab: self.$published.currentTab, showAddStage: false, array: sortedStages, appArray: sortedAppStages, app: false)) {
                ForEach(filteredItems){ item in
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
        .scrollContentBackground(backgroundType == "none" ? .visible : .hidden)
        .background {
            ListBackground()
        }
        .listStyle(.plain)
    }
    
    private func nextStage(){
        let num = viewModel.currentUser?.next ?? 0
        self.viewModel.addAchiv(name: "next", int: num + 1)
        print(num + 0)
        viewModel.nextStage(documentId: lastItem?.documentId ?? "", titleNumber: published.currentTab)
        
        let newName = K.AppStages.stagesArray.sorted(by: { $0.orderIndex < $1.orderIndex })[(self.lastItem?.titleNumber ?? 0) + 1].name
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
        
        let newName = K.AppStages.stagesArray.sorted(by: { $0.orderIndex < $1.orderIndex })[(self.lastItem?.titleNumber ?? 0) - 1].name
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
                viewModel.fetchPeople()
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
        viewModel.fetchPeople()
    }

    private func moreFavourite(_ array: [String]) -> Bool{
        let peopleArray = viewModel.peopleArray.filter { person in
            published.selectPeopleArray.contains(person.id)
        }
        let favArray = peopleArray.filter { person in
            person.isLiked == true
        }
        let unFuvArray = peopleArray.filter { person in
            person.isLiked == false
        }
        if favArray.count > unFuvArray.count {
            return true
        }else {
            return false
        }
    }
}

//#Preview {
//    ItemView()
//}
//
//
