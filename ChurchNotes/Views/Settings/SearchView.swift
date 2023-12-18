//
//  SearchView.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 12/8/23.
//

import SwiftUI

struct SearchView: View {
    @EnvironmentObject var viewModel: AppViewModel
    @EnvironmentObject var published: PublishedVariebles
    @Environment(\.dismissSearch) private var dismissSearch
    @Environment(\.isSearching) private var isSearching

    @State var searchTab: Int = 0
    @State var showActionSheet = false
    @State var deleteItem: Notifics?
    @State var currentItem: Person?
    @State var isShowingDeleteAlert = false
    @State var lastItem: Person?

    
    var filteredItems: [Person]
    let notify = NotificationHandler()
    var body: some View {
        VStack(spacing: 0){
            SearchSlider(currentTab: $searchTab)
                    TabView(selection: $searchTab){
                        List{
                            if isSearching && !filteredItems.isEmpty{
                                ForEach(filteredItems){ item in
                                    if item.isCheked == false && item.isDone == false{
                                        Button(action: {
                                            published.currentItem = item
                                            dismissSearch()
                                            self.searchTab = 0
                                        }){
                                            RowPersonModel(item: item)
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
                                Section(header: Text("you-do-not-have-person-with-name '\(published.searchText)'")){
                                    Button(action: {
                                        self.searchTab = 0
                                        self.published.createPersonName = self.published.searchText
                                        self.published.searchText = ""
                                        dismissSearch()
                                    }){
                                        Label("create", systemImage: "person.badge.plus")
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
                                        published.currentItem = item
                                        dismissSearch()
                                        self.searchTab = 0
                                    }){
                                        RowPersonModel(item: item)
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
                                                    Text("all-days")
                                                }else if notf.sunday && !notf.monday && !notf.tuesday && !notf.wednsday && !notf.thursday && !notf.friday && notf.saturday{
                                                    Text("weekends")
                                                }else if !notf.sunday && notf.monday && notf.tuesday && notf.wednsday && notf.thursday && notf.friday && !notf.saturday{
                                                    Text("weekdays")
                                                }else{
                                                    Text(notf.sunday ? "sun" : "")
                                                    Text(notf.monday ? "mon" : "")
                                                    Text(notf.tuesday ? "tue" : "")
                                                    Text(notf.wednsday ? "wed" : "")
                                                    Text(notf.thursday ? "thu" : "")
                                                    Text(notf.friday ? "fri" : "")
                                                    Text(notf.saturday ? "sat" : "")
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
                                        ActionSheet(title: Text("you-want-to-remove-this-notification"),
                                                    message: Text("press-remove-to-resume"),
                                                    buttons: [
                                                        .cancel(),
                                                        .destructive(
                                                            Text("remove")
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
                                    Text("you-do-not-have-notifications-yet")
                                }
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                            }
                        }
                        .onAppear(perform: {
                            viewModel.fetchNotifications()
                        })
                            .tag(2)
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
            }
//        .sheet(item: $currentItem, onDismiss: nil){ item in
//            NavigationStack{
//                ItemPersonView(item: item, currentItem: $currentItem)
//                    .onDisappear(perform: {
//                        if viewModel.moved == 1{
//                            withAnimation{
//                                viewModel.moved = 0
//                            }
//                        }else if viewModel.moved == 2{
//                            withAnimation{
//                                viewModel.moved = 0
//                            }
//                        }
//                    })
//                    .toolbar{
//                        ToolbarItem(placement: .topBarLeading){
//                            Button(action: {
//                                currentItem = nil
//                            }){
//                                Image(systemName: "xmark.circle")
//                            }
//                        }
//                    }
//            }
//            .accentColor(Color.white)
//            
//        }
        .frame(maxHeight: .infinity, alignment: .top)
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
//    SearchView()
//}
