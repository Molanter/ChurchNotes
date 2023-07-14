//
//  AppView.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 6/28/23.
//

import SwiftUI
import SwiftData

struct AppView: View {
    @Query (sort: \ItemsTitle.timeStamp, order: .forward, animation: .spring) var itemTitles: [ItemsTitle]
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Items]
    @State var name = "name"
    @State var phone = "+1234567890"
    @State var email = "email@gmail.com"
    @State var notes = "Some notes here."
    @State var cristian = true
    @State var showingAlert = false
    @State var showingEditingProfile = false
    @State var width = false
    @State var isLikedCount = 0
    @State var isChekedCount = 0
    @State var presentSheet = false
    @State var title = ""
    var body: some View {
        TabView(selection: .constant(1),
                content:  {
            ContentView()
                .tabItem {
                    Label {
                        Text("Notes")
                    } icon: {
                        Image(systemName: "note.text")
                    }
                }
                .tag(1)
            settings
                .tabItem {
                    Label {
                        Text("Setings")
                    } icon: {
                        Image(systemName: "gear")
                            .rotationEffect(.degrees(22))
                        
                    }
                }
                .tag(2)
        })
        .onAppear(){
                if itemTitles.isEmpty{
                    addFirst()
                }
            UITabBar.appearance().backgroundColor = UIColor(Color(K.Colors.background))
            UITabBar.appearance().unselectedItemTintColor = UIColor(Color(K.Colors.justLightGray))
        }
        .accentColor(Color(K.Colors.bluePurple))
        
    }
    
    @Environment(\.defaultMinListRowHeight) var minRowHeight
    
    var settings: some View{
        NavigationStack{
            ScrollView{
                HStack{
                    Spacer()
                    VStack(alignment: .center){
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: width ? .infinity : 100)
                            .symbolRenderingMode(.multicolor)
                            .foregroundColor(Color(K.Colors.justLightGray))
                            .onTapGesture {
                                withAnimation{
                                    width.toggle()
                                }
                            }
                        HStack{
                            Text(name )
                                .font(.title2)
                                .fontWeight(.bold)
                            Text(cristian ? "†" : "")
                                .font(.title2)
                                .fontWeight(.bold)
                        }
                        Text(phone)
                            .fontWeight(.regular)
                            .font(.body)
                    }
                    Spacer()
                }
                List{
                    Section(header: Label(
                        title: { Text("Login Page")
                                .font(.title)
                                .fontWeight(.bold)
                            .foregroundColor(Color(K.Colors.lightGray))},
                        icon: { Image(systemName: "folder")
                                .font(.title)
                                .foregroundColor(Color(K.Colors.lightGray))
                        }
                    ).padding(.vertical))
                    {
                        NavigationLink(destination: LoginPage(), label: {
                            Label(
                                title: { Text("Login")
                                        .font(.body)
                                        .fontWeight(.bold)
                                    .foregroundColor(Color(K.Colors.lightGray))},
                                icon: { Image(systemName: "folder")
                                        .font(.body)
                                    .foregroundColor(Color(K.Colors.lightGray))}
                            )
                        })
                        .listRowBackground(Color(K.Colors.background))
                        NavigationLink(destination: LoginPage(), label: {
                            Label(
                                title: { Text("Register")
                                        .font(.body)
                                        .fontWeight(.bold)
                                    .foregroundColor(Color(K.Colors.lightGray))},
                                icon: { Image(systemName: "folder")
                                        .font(.body)
                                    .foregroundColor(Color(K.Colors.lightGray))}
                            )
                        })
                        .listRowBackground(Color(K.Colors.background))
                    }
                    Section(){
                        NavigationLink(destination: allTitles, label: {
                            Label(
                                title: { Text("All Titles")
                                        .font(.body)
                                        .fontWeight(.bold)
                                    .foregroundColor(Color(K.Colors.lightGray))},
                                icon: { Image(systemName: "folder")
                                        .font(.body)
                                    .foregroundColor(Color(K.Colors.lightGray))}
                            )
                        })
                        .listRowBackground(Color(K.Colors.background))
                    }
                    .padding(.vertical, 0)
                    Section(header: Text("")){
                        NavigationLink(destination: likedPoople, label: {
                            Label(
                                title: { Text("Favourite")
                                        .font(.body)
                                        .fontWeight(.bold)
                                    .foregroundColor(Color(K.Colors.lightGray))},
                                icon: { Image(systemName: "heart.fill")
                                        .font(.body)
                                    .foregroundColor(Color(K.Colors.red))}
                            )
                        })
                        .listRowBackground(Color(K.Colors.background))
                        NavigationLink(destination: donePeople, label: {
                            Label(
                                title: { Text("Done")
                                        .font(.body)
                                        .fontWeight(.bold)
                                    .foregroundColor(Color(K.Colors.lightGray))},
                                icon: { Image(systemName: "checkmark.circle.fill")
                                        .font(.body)
                                    .foregroundColor(Color(K.Colors.bluePurple))}
                            )
                        })
                        .listRowBackground(Color(K.Colors.background))
                        NavigationLink(destination: allPeople, label: {
                            Label(
                                title: { Text("All People")
                                        .font(.body)
                                        .fontWeight(.bold)
                                    .foregroundColor(Color(K.Colors.lightGray))},
                                icon: { Image(systemName: "person.fill")
                                        .font(.body)
                                    .foregroundColor(Color.black)}
                            )
                        })
                        .listRowBackground(Color(K.Colors.background))
                    }
                    
                }
                .scrollContentBackground(.hidden)
                .opacity(1)
                .frame(minHeight: minRowHeight * 10,maxHeight: .infinity)
                
            }
            
            
            .toolbar{
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button(action: {self.showingEditingProfile.toggle()}){
                        Image(systemName: "square.and.pencil")
                            .foregroundColor(Color(K.Colors.bluePurple))
                    }
                }
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    Button(action: {self.showingAlert.toggle()}){
                        Image(systemName: "network")
                            .disabled(true)
                            .foregroundColor(Color(K.Colors.bluePurple))
                    }
                    .alert("Write Person Name", isPresented: $showingAlert) {
                        TextField("Person Name", text: $name)
                            .foregroundColor(Color(K.Colors.lightGray))
                            .onSubmit {
                                if !name.isEmpty{
                                    self.showingAlert.toggle()
                                    addItem()
                                }else{
                                    
                                }
                            }
                        Button{
                            
                        } label: {
                            Text("Cancel")
                        }
                        
                        Button{
                            
                        }label: {
                            Text("Ok")
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $showingEditingProfile, onDismiss: {}, content: {
            editProfile
        })
        
    }
    
    var allPeople: some View{
        VStack(alignment: .leading){
            ZStack(alignment: .bottom){
                List{
                    Section(header: Label(
                        title: { Text("All")
                                .font(.title)
                                .fontWeight(.bold)
                            .foregroundColor(Color(K.Colors.lightGray))},
                        icon: { Image(systemName: "person.fill")
                                .font(.title)
                                .foregroundColor(Color(K.Colors.bluePurple))
                        }
                    ).padding(.vertical))
                    {
                        ForEach(items){item in
                            VStack(alignment: .leading){
                                Text(item.name .capitalized)
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.primary)
                                Text(item.notes)
                                    .foregroundStyle(.secondary)
                            }
                            .padding(.vertical, 5)
                            .swipeActions(edge: .trailing) {
                                  Button(role: .destructive, action: { modelContext.delete(item) } ) {
                                    Label("Delete", systemImage: "trash")
                                  }
                                }
                            .contextMenu {
                              Button(role: .destructive) {
                                  modelContext.delete(item)
                              } label: {
                                Label("Delete", systemImage: "trash")
                              }
                            }
                        }
                    }
                    
                    
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                HStack(alignment: .center){
                    Text("Count of all your notes: \(items.count)")
                        .foregroundStyle(.secondary)
                }
                .background(Color.clear)
            }
        }
    }
    
    var likedPoople: some View{
        VStack(alignment: .leading){
            ZStack(alignment: .bottom){
                List{
                    Section(header: Label(
                        title: { Text("Favourite")
                                .font(.title)
                                .fontWeight(.bold)
                            .foregroundColor(Color(K.Colors.lightGray))},
                        icon: { Image(systemName: "heart.fill")
                                .font(.title)
                                .foregroundColor(Color(K.Colors.red))
                        }
                    ).padding(.vertical))
                    {
                        ForEach(items){item in
                            if item.isLiked{
                                VStack(alignment: .leading){
                                    Text(item.name .capitalized)
                                        .font(.headline)
                                        .fontWeight(.semibold)
                                        .foregroundStyle(.primary)
                                    Text(item.notes)
                                        .foregroundStyle(.secondary)
                                }
                                .padding(.vertical, 5)
                                .swipeActions(edge: .trailing) {
                                      Button(role: .destructive, action: { modelContext.delete(item) } ) {
                                        Label("Delete", systemImage: "trash")
                                      }
                                    }
                                .contextMenu {
                                  Button(role: .destructive) {
                                      modelContext.delete(item)
                                  } label: {
                                    Label("Delete", systemImage: "trash")
                                  }
                                }
                            }
                        }
                    }
                    
                    
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                HStack(alignment: .center){
                    Text("Count of all your liked notes: \(items.count)")
                        .foregroundStyle(.secondary)
                }
                .background(Color.clear)
            }
        }
    }
    
    var donePeople: some View{
        VStack(alignment: .leading){
            ZStack(alignment: .bottom){
                List{
                    Section(header: Label(
                        title: { Text("Done")
                                .font(.title)
                                .fontWeight(.bold)
                            .foregroundColor(Color(K.Colors.lightGray))},
                        icon: { Image(systemName: "checkmark.circle.fill")
                                .font(.title)
                                .foregroundColor(Color(K.Colors.bluePurple))
                        }
                    ).padding(.vertical))
                    {
                        ForEach(items){item in
                            if item.isCheked{
                                VStack(alignment: .leading){
                                    Text(item.name .capitalized)
                                        .font(.headline)
                                        .fontWeight(.semibold)
                                        .foregroundStyle(.primary)
                                    Text(item.notes)
                                        .foregroundStyle(.secondary)
                                }
                                .padding(.vertical, 5)
                                .swipeActions(edge: .trailing) {
                                      Button(role: .destructive, action: { modelContext.delete(item) } ) {
                                        Label("Delete", systemImage: "trash")
                                      }
                                    }
                                .contextMenu {
                                  Button(role: .destructive) {
                                      modelContext.delete(item)
                                  } label: {
                                    Label("Delete", systemImage: "trash")
                                  }
                                }
                            }
                        }
                    }
                    
                    
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                HStack(alignment: .center){
                    Text("Count of all your done notes: \(items.count)")
                        .foregroundStyle(.secondary)
                }
                .background(Color.clear)
            }
        }
        
    }
    
    var allTitles: some View{
        NavigationStack{
            VStack(alignment: .leading){
                ZStack(alignment: .bottom){
                    List{
                        Section(header: Label(
                            title: { Text("Starts Titles")
                                    .font(.title)
                                    .fontWeight(.bold)
                                .foregroundColor(Color(K.Colors.lightGray))},
                            icon: { Image(systemName: "text.line.first.and.arrowtriangle.forward")
                                    .font(.title)
                                    .foregroundColor(Color(K.Colors.lightGray))
                            }
                        ).padding(.vertical))
                        {
                            ForEach(itemTitles){item in
                                if item.name == "New Friend" || item.name == "Praying" || item.name == "Invited" || item.name == "Attanded" || item.name == "Baptized" || item.name == "Acepted Christ" || item.name == "Serving" || item.name == "Joined Group"{
                                        VStack{
                                            Text(item.name .capitalized)
                                                .padding(5)
                                                .font(.headline)
                                                .fontWeight(.semibold)
                                                .foregroundStyle(.primary)
                                            
                                        }
                                        .padding(.vertical, 2)
                                        .swipeActions(edge: .trailing) {
                                              Button(role: .destructive, action: { modelContext.delete(item) } ) {
                                                Label("Delete", systemImage: "trash")
                                              }
                                            }
                                        .contextMenu {
                                          Button(role: .destructive) {
                                              modelContext.delete(item)
                                          } label: {
                                            Label("Delete", systemImage: "trash")
                                          }
                                        }
                                }
                            }
                            .onDelete(perform: delete)
                            
                            
                        }
                        Section(header: Label(
                            title: { Text("Your Titles")
                                    .font(.title)
                                    .fontWeight(.bold)
                                .foregroundColor(Color(K.Colors.lightGray))},
                            icon: { Image(systemName: "folder")
                                    .font(.title)
                                    .foregroundColor(Color(K.Colors.lightGray))
                            }
                        ).padding(.vertical))
                        {
                            ForEach(itemTitles){item in
                                if item.name != "New Friend" && item.name != "Praying" && item.name != "Invited" && item.name != "Attanded" && item.name != "Baptized" && item.name != "Acepted Christ" && item.name != "Serving" && item.name != "Joined Group"{
                                        VStack{
                                            Text(item.name .capitalized)
                                                .padding(5)
                                                .font(.headline)
                                                .fontWeight(.semibold)
                                                .foregroundStyle(.primary)
                                            
                                        }
                                        .padding(.vertical, 2)
                                        .swipeActions(edge: .trailing) {
                                              Button(role: .destructive, action: { modelContext.delete(item) } ) {
                                                Label("Delete", systemImage: "trash")
                                              }
                                            }
                                        .contextMenu {
                                          Button(role: .destructive) {
                                              modelContext.delete(item)
                                          } label: {
                                            Label("Delete", systemImage: "trash")
                                          }
                                        }
                                }
                            }
                            .onDelete(perform: delete)
                            
                            
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                    VStack{
                        HStack{
                            Spacer()
                            Image(systemName: "folder.badge.plus")
                                .onTapGesture {
                                    self.presentSheet.toggle()
                                }
                                .padding(15)
                                .font(.title2)
                                .foregroundColor(Color(K.Colors.bluePurple))
                        }
                        HStack(alignment: .center){
                            Text("Count of all your Titles: \(itemTitles.count - 7 >= 0 ? itemTitles.count - 7 : 0)")
                                .foregroundStyle(.secondary)
                        }
                        .background(Color.clear)
                    }
                }
            }
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing) {
                        EditButton()
                            .foregroundColor(Color(K.Colors.bluePurple))
                }
            }
            .sheet(isPresented: $presentSheet){
                NavigationStack{
                    VStack(alignment: .leading, spacing: 20){
                        Text("Write New Title Name")
                            .font(.title)
                            .fontWeight(.bold)
                        TextField("New Title Name", text: $title)
                            .onSubmit {
                                addItemTitle()
                            }
                        
                            .textFieldStyle(.roundedBorder)
                        Button(action: {addItemTitle()}){
                            Text("Add")
                                .foregroundColor(Color(K.Colors.bluePurple))
                        }
                        .padding(.vertical, 5)
                        .padding(.horizontal, 20)
                        .background(Color(K.Colors.darkGray))
                        .cornerRadius(7)
                    }
                    .frame(maxHeight: .infinity)
                    .padding()
                    .toolbar{
                        ToolbarItem(placement: .navigationBarLeading){
                            Button(action: {
                                presentSheet.toggle()
                            }){
                                Text("Cancel")
                                    .foregroundColor(Color(K.Colors.bluePurple))
                            }
                        }
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button(action: {addItemTitle()}){
                                Text("Save")
                                    .foregroundColor(Color(K.Colors.bluePurple))
                            }
                        }
                    }
                }
                .background(Color(K.Colors.background))
                .presentationDetents([.medium, .large])
            }
        }
        .background(Color(K.Colors.background))
        
        
    }
    
    private func delete(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(itemTitles[index])
            }
        }
    }
    
    func addItemTitle(){
        let newItemTitle = ItemsTitle(name: title)
        modelContext.insert(newItemTitle)
        title = ""
        self.presentSheet.toggle()
    }
    
    var editProfile: some View{
        VStack{
            Button(action: {}){
                VStack(alignment: .leading){
                    Image(systemName: "person.fill.viewfinder")
                    Text("Chose profile picture")
                }
            }
            VStack(alignment: .center){
                Text("Whay is your name?")
                TextField("Name", text: $name)
            }
            .padding(.horizontal)
            
        }
        .toolbar{
            ToolbarItemGroup(placement: .navigationBarLeading) {
                Button(action: {self.showingEditingProfile.toggle()}){
                    Text("Cancel")
                        .foregroundColor(Color(K.Colors.bluePurple))
                }
            }
        }
    }
    private func addItem() {
        withAnimation {
            let newItem = UserProfile(name: name, phoneNumber: phone, email: email, cristian: cristian, notes: notes)
            modelContext.insert(newItem)
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
}


#Preview {
    AppView()
        .modelContainer(for: [UserProfile.self, Items.self, ItemsTitle.self])
}
