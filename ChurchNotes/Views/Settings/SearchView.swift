//
//  SearchView.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 12/8/23.
//

import SwiftUI
import SwiftData

struct SearchView: View {
    @EnvironmentObject var viewModel: AppViewModel
    @EnvironmentObject var published: PublishedVariebles
    @Environment(\.dismissSearch) private var dismissSearch
    @Environment(\.isSearching) private var isSearching
    
//    @Query var reminders: [ReminderDataModel]

    @State var searchTab: Int = 1
//    @State var showActionSheet = false
//    @State var deleteItem: ReminderDataModel?
//    @State var currentItem: Person?
    @State var isShowingDeleteAlert = false
    @State var lastItem: Person?

    
    var filteredItems: [Person]{
        var people = viewModel.peopleArray.sorted(by: { $0.orderIndex < $1.orderIndex }).sorted(by: { $0.isLiked && !$1.isLiked })
        return published.searchText.isEmpty ? people : people.filter { $0.name.contains(published.searchText) }
    }
    
    var body: some View {
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
                                .background(K.Colors.mainColor)
                                .cornerRadius(10)
                        }
                        .listRowBackground(Color.clear)
                        .listRowSeparatorTint(Color.clear)
                    }
                }
            }
                .scrollContentBackground(.hidden)
                .listStyle(.plain)
                .frame(maxHeight: .infinity)
            .background(Color(K.Colors.listBg))
        .onDisappear(perform: {
            published.tabsAreHidden = false
        })
        .onAppear(perform: {
            published.tabsAreHidden = true
        })
    }
    
    func returnPeople(name: String) -> [Person]{
        return viewModel.peopleArray.filter { $0.title.contains(name) }.sorted(by: { $0.orderIndex < $1.orderIndex }).sorted(by: { $0.isLiked && !$1.isLiked })
    }
    
    
}

//#Preview {
//    SearchView()
//}
