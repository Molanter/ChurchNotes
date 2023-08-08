//
//  ItemView.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 7/2/23.
//

import SwiftUI
import SwiftData
import iPhoneNumberField

struct ItemView: View {
    @Environment(\.modelContext) private var modelContext
    @SwiftData.Query (sort: \ItemsTitle.timeStamp, order: .forward, animation: .spring) var titles: [ItemsTitle]
    @EnvironmentObject var viewModel: AppViewModel
    @SwiftData.Query var title: [ItemsTitle]
    @SwiftData.Query (sort: \Items.timestamp, order: .forward, animation: .spring) var items: [Items]
    
    @State private var searchText = ""
    @State var name = ""
    @State var isLiked = false
    @State var isCheked = false
    @State private var showingAlert = false
    @State var notes = ""
    @State var birthDay = Date.now
    @State var presentSheet = false
    @State var shouldShowImagePicker = false
    @State var image: UIImage?
    @State var finishImage: Data?
    @State var sheetPesonInfo = false
    @State var email = ""
    @State var currentTab: Int = 0
    @State var phoneNumber: String = ""
    @State private var currentItem: Items?
    @State private var nameIsEmpty = false
    var itemTitles: ItemsTitle{
        if title.isEmpty{
            addFirst()
            return titles[currentTab]
        }else{
            return titles[currentTab]
        }
    }
    
    var filteredNames: [Items] {
        if searchText.isEmpty {
            return itemTitles.items.sorted(by: { $0.timestamp > $1.timestamp })
        } else {
            return itemTitles.items.filter { $0.name.contains(searchText) }
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
                Section(header: TopBarView(currentTab: self.$currentTab)){
                    ForEach(filteredNames, id: \.self){item in
                        Button(action: {
                            currentItem = item
                            self.sheetPesonInfo.toggle()
                        }){
                            HStack{
                                ZStack(alignment: .bottomTrailing){
                                    if item.imageData != nil{
                                        if let img = item.imageData{
                                            Image(uiImage: UIImage(data: img)!)
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: 40, height: 40)
                                                .cornerRadius(20)
                                                .overlay(
                                                    Circle().stroke(.gray.opacity(0.6), lineWidth: 1)
                                                )
                                        }
                                    }else{
                                        ZStack(alignment: .center){
                                            Circle()
                                                .foregroundColor(Color(K.Colors.darkGray))
                                                .frame(width: 40, height: 40)
                                            Text(String(item.name.components(separatedBy: " ").compactMap { $0.first }).count >= 3 ? String(String(item.name.components(separatedBy: " ").compactMap { $0.first }).prefix(2)) : String(item.name.components(separatedBy: " ").compactMap { $0.first }))
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
                            }
                            //                                    .swipeActions(edge: .trailing) {
                            //                                        Button(role: .destructive, action: {
                            //                                            modelContext.delete(item)
                            //                                            try? modelContext.save()
                            //                                        } ) {
                            //                                            Label("Delete", systemImage: "trash")
                            //                                        }
                            //                                    }
                            //                                    .contextMenu {
                            //                                        Button(role: .destructive) {
                            //                                            modelContext.delete(item)
                            //                                            try? modelContext.save()
                            //                                        } label: {
                            //                                            Label("Delete", systemImage: "trash")
                            //                                        }
                            //                                    }
                            
                        }
                        .sheet(item: $currentItem, onDismiss: nil){ item in
                            NavigationStack{
                                ItemPersonView(item: item)
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
                    
                    .padding(.horizontal, 0)
                }
            }
            .toolbar(content: {
                ToolbarItem(placement: .topBarTrailing, content: {
                    Button(action: {self.presentSheet.toggle()}){
                        Image(systemName: "person.badge.plus")
                            .foregroundStyle(Color(K.Colors.mainColor))
                    }
                })
                ToolbarItem(placement: .topBarLeading) {
                    EditButton()
                }
            })
            .scrollContentBackground(.hidden)
            .listStyle(.plain)
            .frame(maxHeight: .infinity)
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .automatic), prompt: "Search Name")
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
        .sheet(isPresented: $presentSheet){
            NavigationStack{
                ZStack(alignment: .bottom){
                    ScrollView{
                        VStack(alignment: .center){
                            Button (action: {
                                shouldShowImagePicker.toggle()
                            }){
                                VStack(alignment: . center){
                                    if let image = self.image{
                                        Image(uiImage: image)
                                            .resizable()
                                            .frame(width: 100, height: 100)
                                            .cornerRadius(50)
                                            .overlay(
                                                Circle().stroke(Color(K.Colors.mainColor), lineWidth: 2)
                                            )
                                            .padding(15)
                                        
                                    }else{
                                        Image(systemName: "person.fill.viewfinder")
                                            .resizable()
                                            .frame(width: 100, height: 100)
                                            .foregroundColor(Color(K.Colors.mainColor))
                                            .padding(15)
                                        
                                        
                                    }
                                    Text("tap to change Image")
                                        .foregroundStyle(.secondary)
                                        .foregroundStyle(Color(K.Colors.mainColor))
                                }
                                .padding(15)
                            }
                            VStack(alignment: .leading, spacing: 20){
                                VStack{
                                    HStack{
                                        Text("Write Person Name")
                                            .font(.title2)
                                            .fontWeight(.medium)
                                        Spacer()
                                        Text("(required)")
                                            .font(.subheadline)
                                            .foregroundStyle(.secondary)
                                            .fontWeight(.medium)
                                    }
                                    HStack{
                                        TextField("Name", text: $name)
                                            }
                                    .padding(10)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 5.0).stroke(Color(K.Colors.darkGray), lineWidth: 1)
                                    )
                                }
                                VStack{
                                    HStack{
                                        Text("Email")
                                            .font(.title2)
                                            .fontWeight(.medium)
                                        Spacer()
                                        Text("(optional)")
                                            .font(.subheadline)
                                            .foregroundStyle(.secondary)
                                            .fontWeight(.medium)
                                    }
                                    HStack{
                                        TextField("Email", text: $email)
                                            }
                                    .padding(10)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 5.0).stroke(Color(K.Colors.darkGray), lineWidth: 1)
                                    )
                                }
                                VStack(alignment: .leading, spacing: 20){
                                    Text("Phone")
                                        .fontWeight(.semibold)
                                        .font(.system(size: 15))
                                    HStack(alignment: .center, spacing: 0.0){
                                        ZStack(alignment: .leading){
                                            iPhoneNumberField("Phone Number", text: $phoneNumber)
                                                .maximumDigits(15)
                                                .prefixHidden(false)
                                                .flagHidden(false)
                                                .flagSelectable(true)
                                                .placeholderColor(Color(K.Colors.lightGray))
                                                .frame(height: 45)
                                                .disableAutocorrection(true)
                                                .textInputAutocapitalization(.never)
                                                .padding(0)
                                                .textContentType(.telephoneNumber)
                                                .foregroundStyle(Color.black)
                                        }
                                        .padding(.leading)
                                        Spacer()
                                        Image(systemName: "phone.fill")
                                            .foregroundStyle(Color(K.Colors.lightGray))
                                            .padding(.trailing)
                                    }
                                    .frame(height: 50)
                                    .overlay(
                                        RoundedRectangle(cornerSize: .init(width: 7, height: 7))
                                            .stroke(Color(K.Colors.justLightGray).opacity(0.5), lineWidth: 1)
                                    )
                                }
                                VStack{
                                    HStack{
                                        Text("Notes")
                                            .font(.title2)
                                            .fontWeight(.medium)
                                        Spacer()
                                        Text("(optional)")
                                            .font(.subheadline)
                                            .foregroundStyle(.secondary)
                                            .fontWeight(.medium)
                                    }
                                    HStack{
                                        TextField("Notes", text: $notes)
                                            }
                                    .padding(10)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 5.0).stroke(Color(K.Colors.darkGray), lineWidth: 1)
                                    )
                                }
                                VStack{
                                    HStack{
                                        Text("Birthday")
                                            .font(.title2)
                                            .fontWeight(.medium)
                                        Spacer()
                                        Text("(optional)")
                                            .font(.subheadline)
                                            .foregroundStyle(.secondary)
                                            .fontWeight(.medium)
                                    }
                                    HStack{
                                        Text("Birthday")
                                            .foregroundStyle(.secondary.opacity(0.5))
                                        DatePicker(
                                                "",
                                                selection: $birthDay,
                                                displayedComponents: [.date]
                                            )
                                            }
                                    .padding(10)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 5.0).stroke(Color(K.Colors.darkGray), lineWidth: 1)
                                    )
                                }
                                Button(action: {
                                    if !name.isEmpty{
                                        addItem()
                                    }else{
                                        nameError()
                                    }
                                }){
                                    Text("Add")
                                        .foregroundColor(Color.white)
                                        .padding(.vertical, 10)
                                        .frame(maxWidth: .infinity)
                                        .background(Color(K.Colors.mainColor))
                                        .cornerRadius(7)
                                }
                            }
                            .padding(15)
                        }
                        Spacer()
                    }
                    HStack(alignment: .center){
                        Text("Name is empty")
                            .foregroundStyle(Color(K.Colors.lightGray))
                    }
                    .frame(height: 40)
                    .frame(maxWidth: .infinity)
                    .background(Color(K.Colors.darkGray))
                    .cornerRadius(7)
                    .onTapGesture(perform: {
                        withAnimation{
                            nameIsEmpty = false
                        }
                    })
                    .offset(y: nameIsEmpty ? -20 : 100)
                    .padding(.horizontal, 15)
                }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(.vertical)
                    .toolbar{
                        ToolbarItem(placement: .navigationBarLeading){
                            Button(action: {
                                self.presentSheet.toggle()
                            }){
                                Text("Cancel")
                                    .foregroundColor(Color(K.Colors.lightBlue))
                            }
                        }
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button(action: {
                                if !name.isEmpty{
                                    addItem()
                                }else{
                                    nameError()
                                }
                            }){
                                Text("Save")
                                    .foregroundColor(Color(K.Colors.lightBlue))
                            }
                        }
                    }
                    .edgesIgnoringSafeArea(.bottom)
            }
            .sheet(isPresented: $shouldShowImagePicker) {
                ImagePicker(image: $image)
            }
            .edgesIgnoringSafeArea(.bottom)
            .presentationDetents([.medium, .large])
        }
        .frame(maxHeight: .infinity)
    }
    
    private func nameError(){
        withAnimation{
            nameIsEmpty = true
        }
//        DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) {
            withAnimation{
                nameIsEmpty = false
            }
//            }
    }
    
    private func addItem() {
        withAnimation {
            if image != nil{
                guard let imageSelected = image else{
                    return
                }
                guard let imageData = imageSelected.jpegData(compressionQuality: 0.4) else{
                    print("Avata is nil")
                    return
                }
                let modifiedDate = Calendar.current.date(byAdding: .day, value: -1, to: birthDay)!

                let newItem = Items(name: name, isLiked: false, isCheked: false, notes: notes, imageData: imageData, email: email, birthDay: birthDay >= modifiedDate ? nil : birthDay, title: itemTitles.name, phone: phoneNumber.count > 5 ? phoneNumber : "")
                itemTitles.items.append(newItem)
                email = ""
                name = ""
                notes = ""
                phoneNumber = ""
                image = nil
                self.presentSheet.toggle()
            }else{
                let modifiedDate = Calendar.current.date(byAdding: .day, value: -1, to: birthDay)!

                let newItem = Items(name: name, isLiked: false, isCheked: false, notes: notes, imageData: nil, email: email, birthDay: birthDay >= modifiedDate ? nil : birthDay, title: itemTitles.name, phone: phoneNumber.count > 5 ? phoneNumber : "")
                itemTitles.items.append(newItem)
                email = ""
                name = ""
                notes = ""
                phoneNumber = ""
                image = nil
                self.presentSheet.toggle()
            }
        }
    }
    
    func addFirst(){
        var newItemTitle = ItemsTitle(name: "New Friend")
        modelContext.insert(newItemTitle)
        newItemTitle = ItemsTitle(name: "Invited")
        modelContext.insert(newItemTitle)
        newItemTitle = ItemsTitle(name: "Attanded")
        modelContext.insert(newItemTitle)
        newItemTitle = ItemsTitle(name: "Baptized")
        modelContext.insert(newItemTitle)
        newItemTitle = ItemsTitle(name: "Acepted Christ")
        modelContext.insert(newItemTitle)
        newItemTitle = ItemsTitle(name: "Serving")
        modelContext.insert(newItemTitle)
        newItemTitle = ItemsTitle(name: "Joined Group")
        modelContext.insert(newItemTitle)
    }
    
    private func delete(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                itemTitles.items.remove(at: index)
                try? modelContext.save()
            }
        }
    }
    func deleteItem(_ item: Items) {
        modelContext.delete(item)
        try? modelContext.save()
    }
}

//#Preview {
//    @Query var itemTitles: [ItemsTitle]
//    ItemView()
//    .modelContainer(for: [UserProfile.self, Items.self, ItemsTitle.self])
//
//}


