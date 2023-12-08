//
//  ItemView.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 7/2/23.
//

import SwiftUI
import SwiftData
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore
import iPhoneNumberField


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
    @State private var isShaked = false
    @State var presentStageSheet = false
    @State var nowStage: Int = 2
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
        return nowStage == 0 ? sortedAppStages[currentTab].name : (sortedStages.isEmpty ? "" : sortedStages[currentTab].name)
        
    }
    private var people: [Person] {
        return viewModel.peopleArray.filter { $0.title.contains(itemTitles) }
    }
    private var filteredNames: [Person] {
        return isSearching ? viewModel.peopleArray.sorted(by: { $0.orderIndex < $1.orderIndex }).sorted(by: { $0.isLiked && !$1.isLiked }).filter { $0.name.contains(published.searchText)} : people.sorted(by: { $0.orderIndex < $1.orderIndex })
    }
    private var filteredItems: [Person] {
        return isSearching ? (published.searchText.isEmpty ? viewModel.peopleArray.sorted(by: { $0.orderIndex < $1.orderIndex }).sorted(by: { $0.isLiked && !$1.isLiked }) : filteredNames.filter { $0.name.contains(published.searchText)}) : filteredNames
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
                if viewModel.peopleArray.isEmpty{
                    ProgressView()
                        .padding()
                }else{
                    if isSearching{
                        VStack(spacing: 0){
                            SearchSlider(currentTab: $searchTab)
                                    TabView(selection: $searchTab){
                                        List{
                                            if isSearching && !filteredItems.isEmpty{
                                                ForEach(filteredItems){ item in
                                                    if item.isCheked == false && item.isDone == false{
                                                        Button(action: {
                                                            currentItem = item
                                                            self.sheetPesonInfo.toggle()
                                                            dismissSearch()
                                                            self.searchTab = 0
                                                        }){
                                                            RowPersonModel(item: item)
                                                            .alert("Delete Person", isPresented: Binding(
                                                                get: { self.isShowingDeleteAlert && lastItem != nil },
                                                                set: { newValue in
                                                                    if !newValue {
                                                                        self.isShowingDeleteAlert = false
                                                                    }
                                                                }
                                                            )) {
                                                                Button("Cancel", role: .cancel) {}
                                                                Button("Delete", role: .destructive) {
                                                                    viewModel.deletePerson(documentId: lastItem?.documentId ?? item.documentId)
                                                                    isShowingDeleteAlert = false
                                                                }
                                                            } message: {
                                                                Text("Do you really want to delete this person? This action cannot be undone.")
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
                                                                    Label("Favourite", systemImage: item.isLiked ? "\(K.favouriteSign).fill" : "\(K.favouriteSign)")
                                                                        .accentColor(Color(K.Colors.favouriteSignColor))
                                                                        .contentTransition(.symbolEffect(.replace))
                                                                }
                                                                
                                                                Button(role: .destructive) {
                                                                    self.lastItem = item
                                                                    withAnimation{
                                                                        self.isShowingDeleteAlert = true
                                                                    }
                                                                } label: {
                                                                    Label("Delete", systemImage: "trash")
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                                .onDelete(perform: { indexSet in
                                                    if let firstIndex = indexSet.first {
                                                        let itemToDelete = filteredItems[firstIndex]
                                                        self.lastItem = itemToDelete
                                                        withAnimation{
                                                            self.isShowingDeleteAlert = true
                                                        }                        }
                                                })
                                                .padding(.horizontal, 0)
                                            }else if isSearching && filteredItems.isEmpty{
                                                Section(header: Text("You don't have Person with name '\(published.searchText)'")){
                                                    Button(action: {
                                                        self.published.searchText = ""
                                                        self.showAddPersonView = true
                                                    }){
                                                        Label("Create", systemImage: "person.badge.plus")
                                                            .foregroundColor(Color.black)
                                                            .padding(.vertical, 10)
                                                            .frame(maxWidth: .infinity)
                                                            .background(Color(K.Colors.mainColor))
                                                            .cornerRadius(7)
                                                    }
                                                }
                                            }
                                        }
                                        .scrollContentBackground(.hidden)
                                        .listStyle(.plain)
                                        .frame(maxHeight: .infinity)
                                        .tag(0)
                                        List{
                                            ForEach(filteredItems){ item in
                                                if item.isCheked == false && item.isDone == false && item.isLiked == true{
                                                    Button(action: {
                                                        currentItem = item
                                                        self.sheetPesonInfo.toggle()
                                                        dismissSearch()
                                                        self.searchTab = 0
                                                    }){
                                                        RowPersonModel(item: item)
                                                        .alert("Delete Person", isPresented: Binding(
                                                            get: { self.isShowingDeleteAlert && lastItem != nil },
                                                            set: { newValue in
                                                                if !newValue {
                                                                    self.isShowingDeleteAlert = false
                                                                }
                                                            }
                                                        )) {
                                                            Button("Cancel", role: .cancel) {}
                                                            Button("Delete", role: .destructive) {
                                                                viewModel.deletePerson(documentId: lastItem?.documentId ?? item.documentId)
                                                                isShowingDeleteAlert = false
                                                            }
                                                        } message: {
                                                            Text("Do you really want to delete this person? This action cannot be undone.")
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
                                                                Label("Favourite", systemImage: item.isLiked ? "\(K.favouriteSign).fill" : "\(K.favouriteSign)")
                                                                    .accentColor(Color(K.Colors.favouriteSignColor))
                                                                    .contentTransition(.symbolEffect(.replace))
                                                            }
                                                            
                                                            Button(role: .destructive) {
                                                                self.lastItem = item
                                                                withAnimation{
                                                                    self.isShowingDeleteAlert = true
                                                                }
                                                            } label: {
                                                                Label("Delete", systemImage: "trash")
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                            .onDelete(perform: { indexSet in
                                                if let firstIndex = indexSet.first {
                                                    let itemToDelete = filteredItems[firstIndex]
                                                    self.lastItem = itemToDelete
                                                    withAnimation{
                                                        self.isShowingDeleteAlert = true
                                                    }                        }
                                            })
                                            .padding(.horizontal, 0)
                                        }
                                        .scrollContentBackground(.hidden)
                                        .listStyle(.plain)
                                        .frame(maxHeight: .infinity)
                                        .tag(1)
                                        Group{
                                            if !viewModel.notificationsArray.isEmpty{
                                                List{

                                                ForEach(viewModel.notificationsArray){ notf in
                                                    VStack(alignment: .leading){
                                                        HStack{
                                                            Text(notf.date, style: .time)
                                                                .bold()
                                                                .font(.title3)
                                                            HStack(spacing: 1){
                                                                if notf.sunday && notf.monday && notf.tuesday && notf.wednsday && notf.thursday && notf.friday && notf.saturday{
                                                                    Text("All Days")
                                                                }else if notf.sunday && !notf.monday && !notf.tuesday && !notf.wednsday && !notf.thursday && !notf.friday && notf.saturday{
                                                                    Text("Weekends")
                                                                }else if !notf.sunday && notf.monday && notf.tuesday && notf.wednsday && notf.thursday && notf.friday && !notf.saturday{
                                                                    Text("Weekdays")
                                                                }else{
                                                                    Text(notf.sunday ? "Sun " : "")
                                                                    Text(notf.monday ? "Mon " : "")
                                                                    Text(notf.tuesday ? "Tue " : "")
                                                                    Text(notf.wednsday ? "Wed " : "")
                                                                    Text(notf.thursday ? "Thu " : "")
                                                                    Text(notf.friday ? "Fri " : "")
                                                                    Text(notf.saturday ? "Sat " : "")
                                                                }
                                                            }
                                                            .frame(alignment: .leading)
                                                            .foregroundStyle(.secondary)
                                                            .font(.body)
                                                            Spacer()
                                                            Button(action: {
                                                                self.deleteItem = notf
                                                                self.showActionSheet.toggle()
                                                            }){
                                                                Image(systemName: "xmark")
                                                                    .font(.title2)
                                                            }
                                                        }
                                                        Text(notf.message)
                                                            .font(.body)
                                                    }
                                                    .actionSheet(isPresented: $showActionSheet) {
                                                        ActionSheet(title: Text("You want to remove this notification"),
                                                                    message: Text("Press '**Remove**' to resume."),
                                                                    buttons: [
                                                                        .cancel(),
                                                                        .destructive(
                                                                            Text("Remove")
                                                                        ){
                                                                            removeNotification(item: notf)
                                                                        }
                                                                    ]
                                                        )
                                                    }
                                                }
                                                .onDelete { indexSet in
                                                    if let firstIndex = indexSet.first {
                                                        self.deleteItem = viewModel.notificationsArray[firstIndex]
                                                        self.showActionSheet.toggle()
                                                    }
                                                }
                                                }
                                                .listStyle(.plain)
                                            }else{
                                                VStack(alignment: .leading){
                                                    Image(systemName: "bell.slash")
                                                    Text("You don't have notifications yet.")
                                                }
                                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                            }
                                        }
                                        .onAppear(perform: {
                                            viewModel.fetchNotifications()
                                        })
                                            .tag(2)
                                    }
                                    .tabViewStyle(.page(indexDisplayMode: .never))
                            }
                        .frame(maxHeight: .infinity, alignment: .top)
                    }else{
                            List{
                                if nowStage == 0{
                                    appStages
                                }else if nowStage == 1{
                                    if !sortedStages.isEmpty{
                                        youStages
                                    }else{
                                        VStack(alignment: .leading, spacing: 10, content: {
                                            Image(systemName: "questionmark.folder")
                                                .font(.largeTitle)
                                            Text("You don't have your own stages yet.")
                                                .font(.title)
                                                .bold()
                                            Text("Create your first stage, to see it here.")
                                                .font(.title2)
                                            Button(action: {
                                                self.presentStageSheet.toggle()
                                            }){
                                                Spacer()
                                                Text("Create")
                                                    .foregroundColor(Color.white)
                                                    .padding(.vertical, 10)
                                                    .padding(.leading)
                                                Image(systemName: "folder.badge.plus")
                                                    .foregroundColor(Color.white)
                                                    .padding(.leading)
                                                Spacer()
                                            }
                                            .background(Color(K.Colors.mainColor))
                                            .cornerRadius(7)
                                        })
                                        .padding(.horizontal, 15)
                                    }
                                }
                            }
                            .headerProminence(.standard)
                            .scrollContentBackground(.hidden)
                            .listStyle(.plain)
                            .frame(maxHeight: .infinity)
                    }
                }
            }
            
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onAppear(perform: {
                self.nowStage = K.choosedStages
            })
            .onChange(of: K.choosedStages) { oldValue, newValue in
                self.nowStage = newValue
            }
            
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
//                    VStack(alignment: .center){
//                        HStack(spacing: 0){
//                            Button(action: {
//                                withAnimation{
//                                    K.choosedStages = 0
//                                    self.currentTab = 0
//                                    self.nowStage = 0
//                                }
//                            }){
                            Text(nowStage == 0 ? "App Stages" : "Your Stages")
//                                .foregroundStyle(Color(K.Colors.mainColor))
//                            }
//                            Button(action: {
//                                withAnimation{
//                                    K.choosedStages = 1
//                                    self.currentTab = 0
//                                    self.nowStage = 1
//                                }
//                            }){
//                                Text("Your Stages")
//                                    .font(.system(size: 15))
//                                    .foregroundStyle(nowStage == 1 ? Color(K.Colors.mainColor) : Color(K.Colors.lightGray).opacity(0.5))
//                                    .bold()
//                                    .padding(.vertical, 5)
//                                    .padding(.horizontal, 10)
//                                    .background(
//                                        RoundedRectangle(cornerRadius: .infinity)
//                                            .stroke(nowStage == 1 ? Color(K.Colors.mainColor) : Color.clear, lineWidth: 2)
//                                            .offset(x: nowStage == 1 ? 0 : -130)
//                                        
//                                    )
//                            }
//                        }
                        
                    }
            })
            .toolbarTitleMenu { // ADD THIS!
                            Button("App Stages") {
                                    nowStage = 0
                            }.buttonStyle(.borderedProminent)
                            
                            Button("Your Stages") {
                                nowStage = 1
                            }.buttonStyle(.borderedProminent)
                        }
            .onAppear(perform: {
                nowStage = K.choosedStages
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
                    AddPersonView(showAddPersonView: $showAddPersonView, offset: filteredItems.startIndex, stageName: itemTitles, titleNumber: currentTab, count: viewModel.peopleArray.count)
                        .toolbar{
                            ToolbarItem(placement: .topBarLeading){
                                Button(action: {
                                    self.showAddPersonView.toggle()
                                }){
                                    Text("Cancel")
                                }
                            }
                        }
                }
                .accentColor(Color(K.Colors.mainColor))
                .edgesIgnoringSafeArea(.bottom)
                .presentationDetents([.large])
            }
            .sheet(isPresented: $isShaked, content: {
                NavigationStack{
                    ShakeReportView()
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
                .presentationDetents([.medium])
                .accentColor(Color(K.Colors.mainColor))
            })
            .sheet(item: $currentItem, onDismiss: nil){ item in
                NavigationStack{
                    ItemPersonView(item: item, currentTab: currentTab, currentItem: $currentItem)
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
            .onShake{
                self.isShaked.toggle()
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    var appStages: some View {
//                    List{
        Section(header: TopBarView(currentTab: self.$currentTab, showAddStage: false, array: sortedStages, appArray: sortedAppStages, app: true)){
            ForEach(filteredItems){ item in
                if item.isCheked == false && item.isDone == false{
                    Button(action: {
                        currentItem = item
                        self.sheetPesonInfo.toggle()
                        print(currentTab)
                    }){
                        RowPersonModel(item: item)
                        .swipeActions(edge: .leading) {
                            Button(action: {
                                self.lastItem = item
                                self.nextStage()
                            } ) {
                                Label("Next Stage", systemImage: "arrowshape.turn.up.right")
                            }
                        }
                        .alert("Delete Person", isPresented: Binding(
                            get: { self.isShowingDeleteAlert && lastItem != nil },
                            set: { newValue in
                                if !newValue {
                                    self.isShowingDeleteAlert = false
                                }
                            }
                        )) {
                            Button("Cancel", role: .cancel) {}
                            Button("Delete", role: .destructive) {
                                viewModel.deletePerson(documentId: lastItem?.documentId ?? item.documentId)
                                isShowingDeleteAlert = false
                            }
                        } message: {
                            Text("Do you really want to delete this person? This action cannot be undone.")
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
                                Label("Favourite", systemImage: item.isLiked ? "\(K.favouriteSign).fill" : "\(K.favouriteSign)")
                                    .accentColor(Color(K.Colors.favouriteSignColor))
                                    .contentTransition(.symbolEffect(.replace))
                            }
                            if currentTab != 0{
                                Button{
                                    self.lastItem = item
                                    previousStage()
                                } label: {
                                    Label("Previous Stage", systemImage: "arrowshape.turn.up.left")
                                }
                                
                            }
                            if currentTab != 6{
                                Button{
                                    self.lastItem = item
                                    self.nextStage()
                                } label: {
                                    Label("Next Stage", systemImage: "arrowshape.turn.up.right")
                                }
                            }
                            
                            Button(role: .destructive) {
                                self.lastItem = item
                                withAnimation{
                                    self.isShowingDeleteAlert = true
                                }
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                    }
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
                                Button(action: {
                                    currentItem = item
                                    self.sheetPesonInfo.toggle()
                                    print(currentTab)
                                }){
                                    RowPersonModel(item: item)
                                    .alert("Delete Person", isPresented: $isShowingDeleteAlert) {
                                        Button("Cancel", role: .cancel) {}
                                        Button("Delete", role: .destructive) {
                                            viewModel.deletePerson(documentId: lastItem?.documentId ?? item.documentId)
                                            isShowingDeleteAlert = false
                                        }
                                    } message: {
                                        Text("Do you really want to delete this person? This action cannot be undone.")
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
                                            Label("Favourite", systemImage: item.isLiked ? "\(K.favouriteSign).fill" : "\(K.favouriteSign)")
                                                .accentColor(Color(K.Colors.favouriteSignColor))
                                                .contentTransition(.symbolEffect(.replace))
                                        }
                                        Button(role: .destructive) {
                                            self.lastItem = item
                                            withAnimation{
                                                self.isShowingDeleteAlert = true
                                            }
                                        } label: {
                                            Label("Delete", systemImage: "trash")
                                        }
                                    }
                                }
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
//                }
//                .scrollContentBackground(.hidden)
//                .listStyle(.plain)
//                .frame(maxHeight: .infinity)
//            }
//            if sortedStages.isEmpty{
//                VStack(alignment: .leading, spacing: 10, content: {
//                    Image(systemName: "questionmark.folder")
//                        .font(.largeTitle)
//                    Text("You don't have your own stages yet.")
//                        .font(.title)
//                        .bold()
//                    Text("Create your first stage, to see it here.")
//                        .font(.title2)
//                    Button(action: {
//                        self.presentStageSheet.toggle()
//                    }){
//                        Spacer()
//                        Text("Create")
//                            .foregroundColor(Color.white)
//                            .padding(.vertical, 10)
//                            .padding(.leading)
//                        Image(systemName: "folder.badge.plus")
//                            .foregroundColor(Color.white)
//                            .padding(.leading)
//                        Spacer()
//                    }
//                    .background(Color(K.Colors.mainColor))
//                    .cornerRadius(7)
//                })
//                .padding(.horizontal, 15)
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
    
    private func removeNotification(item: Notifics){
        if item.sunday{
            notify.stopNotifying(day: 1, count: item.orderIndex)
        }
        if item.monday{
            notify.stopNotifying(day: 2, count: item.orderIndex)
        }
        if item.tuesday{
            notify.stopNotifying(day: 3, count: item.orderIndex)
        }
        if item.wednsday{
            notify.stopNotifying(day: 4, count: item.orderIndex)
        }
        if item.thursday{
            notify.stopNotifying(day: 5, count: item.orderIndex)
        }
        if item.friday{
            notify.stopNotifying(day: 6, count: item.orderIndex)
        }
        if item.saturday{
            notify.stopNotifying(day: 7, count: item.orderIndex)
        }
        viewModel.stopNotifing(item: item)
    }
}

//#Preview {
//    ItemView()
//}
//
//
