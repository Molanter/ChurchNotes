//
//  PeopleView.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 10/20/23.
//

import SwiftUI
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

struct PeopleView: View {
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
    let notify = NotificationHandler()
   
    
    
    
    var itemTitles: String
    
    private var people: [Person] {
        return viewModel.peopleArray.filter { $0.title.contains(itemTitles) }
    }
    private var filteredNames: [Person] {
        if searchText.isEmpty {
            return people.sorted(by: { $0.orderIndex < $1.orderIndex })
        } else {
            return people.filter { $0.name.contains(searchText) }
        }
    }
    
    private var filteredItems: [Person] {
        if searchText.isEmpty {
            return filteredNames.sorted(by: { $0.isLiked && !$1.isLiked })
        } else {
            return filteredNames.filter { $0.name.contains(searchText) }
        }
    }
    
    //    init() {
    //            let appearance = UINavigationBarAppearance()
    //            appearance.shadowColor = .clear
    //            UINavigationBar.appearance().standardAppearance = appearance
    //            UINavigationBar.appearance().scrollEdgeAppearance = appearance
    //    }
    

    var body: some View {
        NavigationStack{
            List{
//                Section(header: Text(itemTitles.capitalized)){
                    ForEach(filteredItems){ item in
                        if item.isCheked == false{
                                Button(action: {
                                    currentItem = item
                                    self.sheetPesonInfo.toggle()
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
//                                            Circle()
//                                                .overlay(
//                                                    Circle().stroke(.white, lineWidth: 1)
//                                                )
//                                                .frame(width: 15)
//                                                .foregroundColor(Color(K.Colors.green))
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
                                            Label("delete", systemImage: "trash")
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
                                        Button(role: .destructive) {
                                            self.lastItem = item
                                            withAnimation{
                                                self.isShowingDeleteAlert.toggle()
                                            }
                                        } label: {
                                            Label("delete", systemImage: "trash")
                                        }
                                    }
                                }
                                
                                .sheet(item: $currentItem, onDismiss: nil){ item in
                                    NavigationStack{
                                        ItemPersonView(item: item, currentItem: $currentItem)
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
//                }
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
            })
            .scrollContentBackground(.hidden)
            .listStyle(.plain)
            .frame(maxHeight: .infinity)
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .automatic), prompt: "search-name")
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
        
        
        

        .sheet(isPresented: $showAddPersonView){
            NavigationStack{
                AddPersonView(showAddPersonView: $showAddPersonView, offset: filteredItems.startIndex, stageName: itemTitles, titleNumber: currentTab, count: filteredItems.count)
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
        .frame(maxHeight: .infinity)
        .navigationTitle(itemTitles)
    }
    
    
}


//#Preview {
//    PeopleView()
//}
