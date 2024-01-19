//
//  AllPeopleView.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 7/19/23.
//

import SwiftUI

struct AllPeopleView: View {
    private var items : [Person]{
        return viewModel.peopleArray.sorted(by: { $0.name < $1.name })
    }
    @State private var searchText = ""
    @State private var currentItem: Person?
    let notify = NotificationHandler()
    @State private var lastItem: Person?
    @EnvironmentObject var viewModel: AppViewModel
    @State private var isShowingDeleteAlert = false
    @State var sheetPesonInfo = false

    
    
    
    
    var body: some View {
        NavigationStack{
            List{
                ForEach(items){ item in
                    if !item.isCheked{
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
                                                    .frame(width: 40, height: 40)
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
//                                    Circle()
//                                        .overlay(
//                                            Circle().stroke(.white, lineWidth: 1)
//                                        )
//                                        .frame(width: 15)
//                                        .foregroundColor(Color(K.Colors.green))
                                }
                                VStack(alignment: .leading, spacing: 3){
                                    Text(item.name.capitalized)
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
                        let itemToDelete = items[firstIndex]
                        // Now you can access the documentId of the itemToDelete
                        self.lastItem = itemToDelete
                        self.isShowingDeleteAlert.toggle()
                    }
                })
//                .onMove { source, destination in
//                    
//                }
            }
            .refreshable{
                viewModel.fetchPeople()
            }
            .toolbar(content: {
                
                ToolbarItem(placement: .topBarTrailing) {
                    EditButton()
                }
            })
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .automatic), prompt: "search-name")
            .scrollContentBackground(.hidden)
            .listStyle(.plain)
            .frame(maxHeight: .infinity)
        }
        .navigationTitle("all-people")
    }
}

//#Preview {
//    AllPeopleView()
//        .environmentObject(AppViewModel())
//        .modelContainer(for: [UserProfile.self, Items.self, ItemsTitle.self])
//}
