//
//  AllStagesView.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 8/30/23.
//

import SwiftUI
import SwiftData

struct AllStagesView: View {
    @Environment(\.modelContext) private var modelContext
    @Query (sort: \Items.orderIndex, order: .forward) var items: [Items]
    @Query (sort: \ItemsTitle.timeStamp, order: .forward) var itemTitles: [ItemsTitle]
    @State private var searchText = ""
    @State private var currentItem: Items?
    let notify = NotificationHandler()
    @State private var lastItem: Items?
    @EnvironmentObject var viewModel: AppViewModel
    @State var title = ""
    @State var presentSheet = false

    
    var body: some View {
        ZStack(alignment: .bottom){
            ScrollView(.vertical){
                VStack(alignment: .leading, spacing: 20){
                    
//                    ForEach(itemTitles){ item in
//                        VStack(alignment: .leading){
//                            NavigationLink(destination: AllPeopleView()){
//                                HStack(spacing: 29){
//                                    ZStack(alignment: .bottomTrailing){
//                                        Image(systemName: "folder")
//                                            .font(.system(size: 29))
//                                            .fontWeight(.light)
//                                        Image(systemName: contains(item.name) ? "gearshape" : "person.fill")
//                                            .foregroundStyle(Color(K.Colors.mainColor))
//                                            .font(.system(size: 19))
//                                            .fontWeight(.medium)
//                                            .offset(x: 6, y: 5)
//
//                                    }
//                                    VStack(alignment: .leading, spacing: 5){
//                                        Text(item.name)
//                                            .fontWeight(.semibold)
//                                            .font(.system(size: 15))
//                                            .foregroundStyle(.primary)
//                                        Text("\(item.items.count) people in stage")
//                                            .font(.system(size: 11))
//                                            .foregroundStyle(.secondary)
//                                    }
//                                    Spacer()
//                                    Image(systemName: "chevron.forward")
//                                        .frame(width: 28)
//                                }
//                                .padding(.horizontal, 25)
//                            }
//                            Divider()
//                        }
//                    }
//                    .accentColor(Color(K.Colors.lightGray))
                }
            }
            Button(action: {
                self.presentSheet.toggle()
            }){
                Label("Add Stage", systemImage: "plus.rectangle.on.folder")
                    .foregroundColor(Color.white)
            }
            .padding(.vertical, 10)
            .frame(maxWidth: .infinity)
            .background(Color(K.Colors.mainColor))
            .cornerRadius(7)
            .padding(15)
        }
        .sheet(isPresented: $presentSheet){
            NavigationStack{
                VStack(alignment: .leading, spacing: 20){
                    Text("Write New Stage Name")
                        .font(.title2)
                        .fontWeight(.medium)
                    HStack{
                        TextField("Stage Name", text: $title)
                            .onSubmit {
                                addItemTitle()
                            }
                    }
                    .padding(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5.0).stroke(Color(K.Colors.darkGray), lineWidth: 1)
                    )
                    Button(action: {addItemTitle()}){
                        Text("Add")
                            .foregroundColor(Color.white)
                    }
                    .padding(.vertical, 10)
                    .frame(maxWidth: .infinity)
                    .background(Color(K.Colors.mainColor))
                    .cornerRadius(7)
                }
                .padding(15)
                Spacer()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding()
                .toolbar{
                    ToolbarItem(placement: .navigationBarLeading){
                        Button(action: {
                            presentSheet.toggle()
                        }){
                            Text("Cancel")
                                .foregroundColor(Color(K.Colors.mainColor))
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {addItemTitle()}){
                            Text("Save")
                                .foregroundColor(Color(K.Colors.mainColor))
                        }
                    }
                }
                .edgesIgnoringSafeArea(.bottom)
                Spacer()
            }
            .edgesIgnoringSafeArea(.bottom)
            .background(Color(K.Colors.mainColor))
            .presentationDetents([.medium, .large])
        }
    }
    
    private func addItemTitle(){
        let newItemTitle = ItemsTitle(name: title)
        modelContext.insert(newItemTitle)
        title = ""
        self.presentSheet.toggle()
    }
    
    private func contains(_ name: String) -> Bool{
        switch name{
        case "New Friend":
            return true
        case "Invited":
            return true
        case "Attanded":
            return true
        case "Baptized":
            return true
        case "Acepted Christ":
            return true
        case "Serving":
            return true
        case "Joined Group":
            return true
        default:
            return false
        }
    }
}

#Preview {
    AllStagesView()
}
