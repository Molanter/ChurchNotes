//
//  DonePeople.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 10/21/23.
//

import SwiftUI
import SwiftData

struct DonePeople: View {
    @EnvironmentObject var viewModel: AppViewModel

    @Query var strings: [StringDataModel]

    @State private var searchText = ""
    @State private var currentItem: Person?
    @State var sheetPesonInfo = false
    @State private var lastItem: Person?
    @State private var isShowingDeleteAlert = false

    let notify = ReminderHandler()
    
    var backgroundType: String {
        if let strModel = strings.first(where: { $0.name == "backgroundType" }) {
            return strModel.string
        }else {
            return "none"
        }
    }
    
    var body: some View {
        NavigationStack{
            List{
                ForEach(viewModel.peopleArray.sorted(by: { $0.name < $1.name })){ item in
                    if item.isDone == true{
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
                                    .onTapGesture {
                                        withAnimation{
                                            viewModel.likePerson(documentId: item.documentId, isLiked: false)
                                        }
                                    }
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
                        .listRowBackground(
                            GlassListRow()
                        )
                        .actionSheet(isPresented: $isShowingDeleteAlert) {
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
                        .sheet(item: $currentItem, onDismiss: nil){ item in
                            NavigationStack{
                                ItemPersonView(item: item, currentItem: $currentItem)
                                    .toolbar{
                                        ToolbarItem(placement: .topBarLeading){
                                            Button(action: {
                                                currentItem = nil
                                            }){
                                                Text("cancel")
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
                        let itemToDelete = viewModel.peopleArray.sorted(by: { $0.name < $1.name })[firstIndex]
                        // Now you can access the documentId of the itemToDelete
                        self.lastItem = itemToDelete
                        self.isShowingDeleteAlert.toggle()
                    }
                })
//                .onMove { source, destination in
//
//                }
            }
            .scrollContentBackground(backgroundType == "none" ? .visible : .hidden)
            .background {
                ListBackground()
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
        .navigationTitle("done-people")
        .navigationBarTitleDisplayMode(.large)
    }
}

#Preview {
    DonePeople()
}
