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

struct ChatMessage: Identifiable{
    var id: String { documentId}
    let documentId: String
    let userId, name, notes, email, title, phone, imageData: String
    let orderIndex: Int
    let isCheked, isLiked, isDone: Bool
    let birthDay, timestamp: Date
    init(documentId: String, data: [String: Any]){
        self.documentId = documentId
        self.userId = data["userId"] as? String ?? ""
        self.name = data["name"] as? String ?? ""
        self.notes = data["notes"] as? String ?? ""
        self.email = data["email"] as? String ?? ""
        self.title = data["title"] as? String ?? ""
        self.phone = data["phone"] as? String ?? ""
        self.imageData = data["imageData"] as? String ?? ""
        self.orderIndex = data["orderIndex"] as? Int ?? 0
        self.isCheked = data["isCheked"] as? Bool ?? false
        self.isLiked = data["isLiked"] as? Bool ?? false
        self.isDone = data["isDone"] as? Bool ?? false
        self.birthDay = (data["birthDay"] as? Timestamp)?.dateValue() ?? Date()
        self.timestamp = (data["timestamp"] as? Timestamp)?.dateValue() ?? Date()
    }
}

class ChatViewModel: ObservableObject{
    let db = Firestore.firestore()
    let auth = Auth.auth()
    @State var errorMessage = ""
    @Published var name = ""
    @Published var notes = ""
    @Published var email = ""
    @Published var title = ""
    @Published var phone = ""
    @Published var imageData = ""
    @Published var orderIndex = 0
    @Published var isCheked = false
    @Published var isLiked = false
    @Published var isDone = false
    @Published var birthDay = Date()
    @Published var timestamp = Date.now

    @Published var chatMessages = [ChatMessage]()
    func fetchMessages(){
        guard let userId = auth.currentUser?.uid else {return}
        db.collection(userId).addSnapshotListener { querySnapshot, error in
            if let err = error{
                self.errorMessage = err.localizedDescription
            }
            
            querySnapshot?.documents.forEach({ queryDocumentSnapshot in
                let data = queryDocumentSnapshot.data()
                let docId = queryDocumentSnapshot.documentID
                let chatMessage = ChatMessage(documentId: docId, data: data)
                self.chatMessages.append(chatMessage)
            })
        }
    }
    func handleSend(){
        guard let userId = auth.currentUser?.uid else {return}
        let writerDocument = db.collection(userId).document()

        let messageData = ["userId": userId, "name": name, "notes": notes, "email": email, "title": title, "phone": phone, "imageData": imageData, "orderIndex": orderIndex, "isCheked": isCheked, "isLiked": isLiked, "isDone": isDone, "birthDay": birthDay, "timeStamp": timestamp] as [String: Any]
        writerDocument.setData(messageData){error in
            if let er = error{
                self.errorMessage = er.localizedDescription
            }
        }
        
    }
}



struct ItemView: View {
    @Environment(\.modelContext) private var modelContext
    @Query (sort: \ItemsTitle.timeStamp, order: .forward) var titles: [ItemsTitle]
    @Query (sort: \Items.orderIndex, order: .forward) var items: [Items]
    @EnvironmentObject var vm: ChatViewModel

    @EnvironmentObject var viewModel: AppViewModel
    @Query var title: [ItemsTitle]
    @State var showAddPersonView = false
    @State private var searchText = ""
    @State var presentSheet = false
    @State var finishImage: Data?
    @State var sheetPesonInfo = false
    @State var currentTab: Int = 0
    @State private var currentItem: Items?
    let notify = NotificationHandler()
    @State private var lastItem: Items?
   
    
    private var itemTitles: ItemsTitle{
        if title.isEmpty{
            addFirst()
            return titles[currentTab]
        }else{
            return titles[currentTab]
        }
    }
    private var filteredNames: [Items] {
        if searchText.isEmpty {
            return itemTitles.items.sorted(by: { $0.orderIndex < $1.orderIndex })
        } else {
            return itemTitles.items.filter { $0.name.contains(searchText) }
        }
    }
    
    private var filteredItems: [Items] {
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
                Section(header: TopBarView(currentTab: self.$currentTab)){
                    ForEach(filteredItems, id: \.self){ item in
                        if !item.isCheked {
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
                                    Image(systemName: item.isLiked ? "heart.fill" : "")
                                        .foregroundStyle(Color(K.Colors.red))
                                        .contentTransition(.symbolEffect(.replace))
                                        .padding()
                                        .onTapGesture {
                                            withAnimation{
                                                item.isLiked.toggle()
                                            }
                                        }
                                }
                                .swipeActions(edge: .trailing) {
                                    Button(role: .destructive, action: {
                                        modelContext.delete(item)
//                                        withAnimation{
//                                            item.isCheked.toggle()
//                                        }
//                                        notify.stopNotifying(type: "birthday", name: item.name)
//                                        lastItem = item

                                    } ) {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                                .contextMenu {
                                    Button{
                                        withAnimation{
                                            item.isLiked.toggle()
                                        }
                                    } label: {
                                        Label("Favourite", systemImage: item.isLiked ? "heart.fill" : "heart")
                                            .accentColor(Color(K.Colors.red))
                                            .contentTransition(.symbolEffect(.replace))

                                    }
                                    Button(role: .destructive) {
//                                        modelContext.delete(item)
//                                        try? modelContext.save()
                                        withAnimation{
                                            item.isCheked.toggle()
                                        }
                                        notify.stopNotifying(type: "birthday", name: item.name)
                                        lastItem = item
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
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
                    }
//                    .onDelete(perform: delete)
                    .onDelete(perform: { indexSet in
                        withAnimation{
                            for index in indexSet {
                                filteredItems[index].isCheked.toggle()
                                let name = filteredItems[index].name
                                notify.stopNotifying(type: "birthday", name: name)
                                lastItem = filteredItems[index]
                            }
                        }
                        
                    })
                    .onMove { source, destination in
                        
                        let list = filteredItems
                        var updatedItems = list
                        updatedItems.move(fromOffsets: source, toOffset: destination)
                        for (index, item) in updatedItems.enumerated() {
                            item.orderIndex = index
                        }
//                        updatedItems.updateOrderIndices()
                    }
                    .padding(.horizontal, 0)
                }
            }
            .onAppear{
                vm.fetchMessages()
            }
            .onShake{
                print("Device shaken!")
                self.lastItem?.isCheked.toggle()
                    }
            .toolbar(content: {
                ToolbarItem(placement: .topBarTrailing, content: {
                    Button(action: {self.showAddPersonView.toggle()}){
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
        
        .sheet(isPresented: $showAddPersonView){
            NavigationStack{
                AddPersonView(showAddPersonView: $showAddPersonView, title: itemTitles, offset: filteredItems.startIndex)
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
            .presentationDetents([.medium, .large])
        }
        .frame(maxHeight: .infinity)
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
                modelContext.delete(itemTitles.items[index])
            }
        }
    }
    
    
}

//#Preview {
//    @Query var itemTitles: [ItemsTitle]
//    ItemView()
//    .modelContainer(for: [UserProfile.self, Items.self, ItemsTitle.self])
//
//}


