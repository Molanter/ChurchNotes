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
    @State var showAddPersonView = false
    @State private var searchText = ""
    @State var presentSheet = false
    @State var finishImage: Data?
    @State var sheetPesonInfo = false
    @State var currentTab: Int = 0
    @State private var currentItem: Person?
    @State private var lastItem: Person?
    @State private var isShowingDeleteAlert = false
    @State private var isShaked = false
    @State var presentStageSheet = false

    var choosedStages = K.choosedStages
    @State var nowStage: Int = 2
    let notify = NotificationHandler()
    
    private var stageSort: String{
        var string = ""
        if nowStage == 0{
            string = "app"
        }else if nowStage == 1{
            string = "user"
        }
        return string
    }
    
    private var selectedStages: [Stage]{
        return viewModel.stagesArray.filter { $0.createBy.contains(stageSort) }
    }
    
    private var sortedYourStages: [Stage]{
        return selectedStages.sorted(by: { $0.orderIndex < $1.orderIndex })
    }
    
    private var sortedAppStages: [Stage]{
        return selectedStages.sorted(by: { $0.orderIndex < $1.orderIndex })
    }
    private var itemTitles: Stage{
        return nowStage == 0 ? sortedAppStages[currentTab] : sortedYourStages[currentTab]

    }
    private var people: [Person] {
        return viewModel.peopleArray.filter { $0.title.contains(itemTitles.name) }
    }
    private var filteredNames: [Person] {
        return searchText.isEmpty ? people.sorted(by: { $0.orderIndex < $1.orderIndex }) : people.filter { $0.name.contains(searchText) }
    }
    private var filteredItems: [Person] {
        return searchText.isEmpty ? filteredNames.sorted(by: { $0.isLiked && !$1.isLiked }) : filteredNames.filter { $0.name.contains(searchText) }
    }
    
    //    init() {
    //            let appearance = UINavigationBarAppearance()
    //            appearance.shadowColor = .clear
    //            UINavigationBar.appearance().standardAppearance = appearance
    //            UINavigationBar.appearance().scrollEdgeAppearance = appearance
    //    }
    

    var body: some View{
        NavigationStack{
            ZStack(alignment: .center){
                if nowStage == 0{
                    appStages
                }else if nowStage == 1{
                    youStages
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
                ToolbarItem(placement: .topBarTrailing, content: {
                    Button(action: {self.showAddPersonView.toggle()}){
                        Image(systemName: "person.badge.plus")
                            .foregroundStyle(Color(K.Colors.mainColor))
                    }
                })
                ToolbarItem(placement: .topBarTrailing) {
                    EditButton()
                }
                
                ToolbarItem(placement: .topBarLeading) {
                    VStack(alignment: .center){
                        HStack(spacing: 0){
                            Button(action: {
                                withAnimation{
                                    K.choosedStages = 0
                                    nowStage = 0
                                }
                            }){
                                Text("App Stages")
                                    .font(.system(size: 16))
                                    .foregroundStyle(nowStage == 0 ? Color(K.Colors.blackAndWhite) : Color(K.Colors.lightGray).opacity(0.5))
                                    .bold()
                                    .padding(.vertical, 7)
                                    .padding(.horizontal, 15)
                                    .background(
                                        RoundedRectangle(cornerRadius: .infinity)
                                            .foregroundStyle(nowStage == 0 ? Color(K.Colors.mainColor) : Color.clear)
                                            .offset(x: nowStage == 0 ? 0 : 145)

                                        )
                            }
                            Button(action: {
                                withAnimation{
                                    K.choosedStages = 1
                                    nowStage = 1
                                }
                            }){
                                Text("Your Stages")
                                    .font(.system(size: 16))
                                    .foregroundStyle(nowStage == 1 ? Color(K.Colors.mainColor) : Color(K.Colors.lightGray).opacity(0.5))
                                    .bold()
                                    .padding(.vertical, 7)
                                    .padding(.horizontal, 15)
                                    .background(
                                        RoundedRectangle(cornerRadius: .infinity)
                                            .stroke(nowStage == 1 ? Color(K.Colors.mainColor) : Color.clear, lineWidth: 2)
                                            .offset(x: nowStage == 1 ? 0 : -130)

                                        )
                            }
                        }
                        
                    }
                    .onAppear(perform: {
                        nowStage = K.choosedStages
                    })
                }
            })
        }

    }
    
    var appStages: some View {
        NavigationStack{
            List{
                Section(header: TopBarView(currentTab: self.$currentTab, showAddStage: false, array: sortedAppStages)){
                    ForEach(filteredItems){ item in
                        if item.isCheked == false && item.isDone == false{
                                Button(action: {
                                    currentItem = item
                                    self.sheetPesonInfo.toggle()
                                    print(currentTab)
                                }){
                                    HStack{
                                        ZStack(alignment: .bottomTrailing){
                                            if item.imageData != ""{
                                                    AsyncImage(url: URL(string: item.imageData)){image in
                                                        image.resizable()
                                                        
                                                    }placeholder: {
                                                        ProgressView()
                                                            .aspectRatio(contentMode: .fill)
                                                            .frame(width: 100, height: 100)
                                                    }
                                                        .aspectRatio(contentMode: .fill)
                                                        .frame(width: 40, height: 40)
                                                        .cornerRadius(20)
                                                        .overlay(
                                                            Circle().stroke(.gray.opacity(0.6), lineWidth: 1)
                                                        )
                                            }else{
                                                ZStack(alignment: .center){
                                                    Circle()
                                                        .foregroundColor(Color(K.Colors.darkGray))
                                                        .frame(width: 40, height: 40)
                                                    Text(viewModel.twoNames(name: item.name))
                                                        .textCase(.uppercase)
                                                        .foregroundColor(Color.white)
                                                }
                                                
                                            }
                                            Circle()
                                                .overlay(
                                                    Circle().stroke(.white, lineWidth: 1)
                                                )
                                                .frame(width: 15)
                                                .foregroundColor(Color(K.Colors.green))
                                        }
                                        VStack(alignment: .leading, spacing: 3){
                                            Text(item.name.capitalized )
                                                .padding(.vertical, 3)
                                                .fontWeight(.medium)
                                                .foregroundStyle(.primary)
                                                .font(.system(size: 13))
                                            HStack(spacing: 1){
                                                Text(item.timestamp, format: .dateTime.month(.wide))
                                                Text(item.timestamp, format: .dateTime.day())
                                                Text(", \(item.timestamp, format: .dateTime.year()), ")
                                                Text(item.timestamp, style: .time)
                                            }
                                            .font(.system(size: 11))
                                            .foregroundStyle(Color(K.Colors.lightGray))
                                        }
                                        Spacer()
                                        Image(systemName: item.isLiked ? "\(K.favouriteSign).fill" : "")
                                            .foregroundStyle(Color(K.Colors.favouriteSignColor))
                                            .contentTransition(.symbolEffect(.replace))
                                            .padding()
                                            .onTapGesture {
                                                withAnimation{
                                                    viewModel.likePerson(documentId: item.documentId, isLiked: false)
                                                }
                                            }
                                    }
                                    .swipeActions(edge: .trailing) {
                                        Button(role: .destructive, action: {
                                            self.lastItem = item
                                            self.isShowingDeleteAlert.toggle()
                                        } ) {
                                            Label("Delete", systemImage: "trash")
                                        }
                                    }
                                    .swipeActions(edge: .leading) {
                                        Button(action: {
                                            viewModel.nextStage(documentId: item.documentId, titleNumber: currentTab)
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                                if viewModel.moved == 1{
                                                    print("terdg")
                                                    withAnimation {
                                                        currentTab += 1
                                                    }
                                                }
                                            }
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
                                                viewModel.previousStage(documentId: item.documentId, titleNumber: currentTab)
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                                    if viewModel.moved == 2{
                                                        withAnimation {
                                                            currentTab -= 1
                                                        }
                                                    }
                                                }
                                            } label: {
                                                Label("Previous Stage", systemImage: "arrowshape.turn.up.left")
                                            }

                                        }
                                        if currentTab != 6{
                                            Button{
                                                viewModel.nextStage(documentId: item.documentId, titleNumber: currentTab)
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                                    if viewModel.moved == 1{
                                                        print("terdg")
                                                        withAnimation {
                                                            currentTab += 1
                                                        }
                                                    }
                                                }
                                            } label: {
                                                Label("Next Stage", systemImage: "arrowshape.turn.up.right")
                                            }
                                        }
                                        
                                        Button(role: .destructive) {
                                            self.lastItem = item
                                            withAnimation{
                                                self.isShowingDeleteAlert.toggle()
                                            }
                                        } label: {
                                            Label("Delete", systemImage: "trash")
                                        }
                                    }
//                                preview:{
//                                        ReactionButtonsView()
//
//                                    }
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
                                                        print("dfx")
                                                        withAnimation {
                                                            currentTab += 1
                                                        }
                                                }else if viewModel.moved == 2{
                                                        print("terdg")
                                                        withAnimation {
                                                            currentTab -= 1
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
                            }
                        }
                    .onDelete(perform: { indexSet in
                        if let firstIndex = indexSet.first {
                            let itemToDelete = filteredItems[firstIndex]
                            // Now you can access the documentId of the itemToDelete
                            self.lastItem = itemToDelete
                            self.isShowingDeleteAlert.toggle()
                        }
                    })
                    .padding(.horizontal, 0)
                }
            }
            .onShake{
                print("Device shaken!")
                self.isShaked.toggle()
            }
            .scrollContentBackground(.hidden)
            .listStyle(.plain)
            .frame(maxHeight: .infinity)
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .automatic), prompt: "Search Name")
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
        
        
        
        

        .sheet(isPresented: $showAddPersonView){
            NavigationStack{
                AddPersonView(showAddPersonView: $showAddPersonView, offset: filteredItems.startIndex, stageName: itemTitles.name, titleNumber: currentTab, count: filteredItems.count)
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
        .frame(maxHeight: .infinity)
    }
    
    var youStages: some View {
        NavigationStack{
            ZStack{
                if !sortedYourStages.isEmpty{
                    List{
                        Section(header: TopBarView(currentTab: self.$currentTab, showAddStage: true, array: sortedYourStages)){
                            ForEach(filteredItems){ item in
                                if item.isCheked == false && item.isDone == false{
                                        Button(action: {
                                            currentItem = item
                                            self.sheetPesonInfo.toggle()
                                            print(currentTab)
                                        }){
                                            HStack{
                                                ZStack(alignment: .bottomTrailing){
                                                    if item.imageData != ""{
                                                            AsyncImage(url: URL(string: item.imageData)){image in
                                                                image.resizable()
                                                                
                                                            }placeholder: {
                                                                ProgressView()
                                                                    .aspectRatio(contentMode: .fill)
                                                                    .frame(width: 100, height: 100)
                                                            }
                                                                .aspectRatio(contentMode: .fill)
                                                                .frame(width: 40, height: 40)
                                                                .cornerRadius(20)
                                                                .overlay(
                                                                    Circle().stroke(.gray.opacity(0.6), lineWidth: 1)
                                                                )
                                                    }else{
                                                        ZStack(alignment: .center){
                                                            Circle()
                                                                .foregroundColor(Color(K.Colors.darkGray))
                                                                .frame(width: 40, height: 40)
                                                            Text(viewModel.twoNames(name: item.name))
                                                                .textCase(.uppercase)
                                                                .foregroundColor(Color.white)
                                                        }
                                                        
                                                    }
                                                    Circle()
                                                        .overlay(
                                                            Circle().stroke(.white, lineWidth: 1)
                                                        )
                                                        .frame(width: 15)
                                                        .foregroundColor(Color(K.Colors.green))
                                                }
                                                VStack(alignment: .leading, spacing: 3){
                                                    Text(item.name.capitalized )
                                                        .padding(.vertical, 3)
                                                        .fontWeight(.medium)
                                                        .foregroundStyle(.primary)
                                                        .font(.system(size: 13))
                                                    HStack(spacing: 1){
                                                        Text(item.timestamp, format: .dateTime.month(.wide))
                                                        Text(item.timestamp, format: .dateTime.day())
                                                        Text(", \(item.timestamp, format: .dateTime.year()), ")
                                                        Text(item.timestamp, style: .time)
                                                    }
                                                    .font(.system(size: 11))
                                                    .foregroundStyle(Color(K.Colors.lightGray))
                                                }
                                                Spacer()
                                                Image(systemName: item.isLiked ? "\(K.favouriteSign).fill" : "")
                                                    .foregroundStyle(Color(K.Colors.favouriteSignColor))
                                                    .contentTransition(.symbolEffect(.replace))
                                                    .padding()
                                                    .onTapGesture {
                                                        withAnimation{
                                                            viewModel.likePerson(documentId: item.documentId, isLiked: false)
                                                        }
                                                    }
                                            }
                                            .swipeActions(edge: .trailing) {
                                                Button(role: .destructive, action: {
                                                    self.lastItem = item
                                                    self.isShowingDeleteAlert.toggle()
                                                } ) {
                                                    Label("Delete", systemImage: "trash")
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
                                                Button(role: .destructive) {
                                                    self.lastItem = item
                                                    withAnimation{
                                                        self.isShowingDeleteAlert.toggle()
                                                    }
                                                } label: {
                                                    Label("Delete", systemImage: "trash")
                                                }
                                            }
        //                                preview:{
        //                                        ReactionButtonsView()
        //
        //                                    }
                                        }
                                        .sheet(isPresented: $isShaked, content: {
                                            NavigationStack{
                                                ShakeReportView()
                                                    .toolbar{
                                                        ToolbarItem(placement: .topBarTrailing){
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
                                                    .toolbar{
                                                        ToolbarItem(placement: .topBarTrailing){
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
                                    }
                                }
                            .onDelete(perform: { indexSet in
                                if let firstIndex = indexSet.first {
                                    let itemToDelete = filteredItems[firstIndex]
                                    // Now you can access the documentId of the itemToDelete
                                    self.lastItem = itemToDelete
                                    self.isShowingDeleteAlert.toggle()
                                }
                            })
                            .padding(.horizontal, 0)
                        }
                    }
                    .onShake{
                        print("Device shaken!")
                        self.isShaked.toggle()
                    }
                    .scrollContentBackground(.hidden)
                    .listStyle(.plain)
                    .frame(maxHeight: .infinity)
                    .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .automatic), prompt: "Search Name")
                    .tabViewStyle(.page(indexDisplayMode: .never))
                }
                if sortedYourStages.isEmpty{
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
                AddPersonView(showAddPersonView: $showAddPersonView, offset: filteredItems.startIndex, stageName: itemTitles.name, titleNumber: currentTab, count: filteredItems.count)
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
        .frame(maxHeight: .infinity)
    }

    
}

//#Preview {
//    ItemView()
//}
//
//
