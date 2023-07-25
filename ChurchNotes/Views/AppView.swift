//
//  AppView.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 6/28/23.
//

import SwiftUI
import SwiftData
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore
import iPhoneNumberField

struct AppView: View {
    @SwiftData.Query (sort: \ItemsTitle.timeStamp, order: .forward, animation: .spring) var itemTitles: [ItemsTitle]
    @Environment(\.modelContext) private var modelContext
    @SwiftData.Query (sort: \Items.timestamp, order: .forward, animation: .spring) var items: [Items]
    @State var name = "name"
    @State var phone = "+1234567890"
    @State var email = "email@gmail.com"
    @State var cristian = true
    @State var showingEditingProfile = false
    @State var width = false
    @State var username = ""
    @State var country = ""
    @State var notes = ""
    @State var image: UIImage?
    @State var profileImage = ""
    @State var showImagePicker = false
    @State var errReg = ""
    @State var documentId = ""
    @State var logoutAlert = false
    @State var currentTab: Int = 1
    @State var tabBar = true
    @State var accentColor = false
    var db = Firestore.firestore()
    var auth = Auth.auth()
    @EnvironmentObject var viewModel: AppViewModel
    @State private var selection: Int = 0 // 1

    var body: some View {
        VStack(alignment: .center, spacing: 0) { // 2
                    ZStack { // 3
                        if (selection == 0) {
                            ItemView()
                        } else if (selection == 1) {
                            settings
                        }// else if (selection == 2) {
//                            contactsContent()
//                        } else if (selection == 3) {
//                            keypadContent()
//                        } else if (selection == 4) {
//                            voicemailContent()
//                        }
                    }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            HStack(alignment: .lastTextBaseline) {
                CustomTabBarItem(iconName: "note.text",
                                 label: "Notes",
                                 selection: $selection,
                                 tag: 0)
                CustomTabBarItem(iconName: "gearshape",
                                 label: "Settings",
                                 selection: $selection,
                                 tag: 1)
//                CustomTabBarItem(iconName: "person.crop.circle",
//                                 label: "Contacts",
//                                 selection: $selection,
//                                 tag: 2)
//                CustomTabBarItem(iconName: "circle.grid.3x3.fill",
//                                 label: "Keypad",
//                                 selection: $selection,
//                                 tag: 3)
//                CustomTabBarItem(iconName: "recordingtape",
//                                 label: "Voicemail",
//                                 selection: $selection,
//                                 tag: 4)
            }
                    .frame(maxWidth: .infinity)
                    .background(
                        GeometryReader { parentGeometry in
                            Rectangle()
                                .fill(Color(K.Colors.background))
                                .frame(width: parentGeometry.size.width, height: 0.5)
                                .position(x: parentGeometry.size.width / 2, y: 0)
                        }
                    )
                    .background(Color(UIColor.systemGray6))
                }.frame(maxHeight: .infinity, alignment: .bottom)
        .onAppear(){
            if itemTitles.isEmpty{
                addFirst()
            }
        }
        .accentColor(accentColor ? Color.white : Color(K.Colors.bluePurple))
        
    }
    
    var update: some View {
        
        NavigationStack{
            ScrollView{
                VStack{
                    Spacer()
                    VStack(alignment: .center){
                        VStack(alignment: .center){
                            Text("Update Profile")
                                .font(.title)
                                .fontWeight(.bold)
                                .padding(.bottom, 5)
                            Text("Your email: '\(email)'")
                                .foregroundStyle(.secondary)
                                .font(.system(size: 14))
                                .padding(.bottom, 10)
                        }
                        Button (action: {
                            showImagePicker.toggle()
                        }){
                            VStack(alignment: . center){
                                if profileImage != "" && image == nil{
                                    AsyncImage(url: URL(string: profileImage)){image in
                                        image.resizable()
                                        
                                    }placeholder: {
                                        ProgressView()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 100, height: 100)
                                    }
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 100, height: 100)
                                    .cornerRadius(width ? 0 : .infinity)
                                }else{
                                    if let image = self.image{
                                        Image(uiImage: image)
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 100, height: 100)
                                            .cornerRadius(50)
                                            .overlay(
                                                Circle().stroke(Color(K.Colors.mainColor), lineWidth: 2)
                                            )
                                            .padding(15)
                                        
                                    }else{
                                        Image(systemName: "person.fill.viewfinder")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 100, height: 100)
                                            .foregroundColor(Color(K.Colors.mainColor))
                                            .padding(15)
                                            .fontWeight(.regular)
                                    }
                                }
                                Text("tap to change Image")
                                    .foregroundColor(Color(K.Colors.mainColor))
                                    .font(.system(size: 14))
                                    .fontWeight(.regular)
                            }
                        }
                        .sheet(isPresented: $showImagePicker) {
                            ImagePicker(image: $image)
                        }
                        .padding(.bottom, 30)
                        VStack(alignment: .leading, spacing: 20){
                            VStack(alignment: .leading, spacing: 20){
                                Text("Full Name")
                                    .fontWeight(.semibold)
                                    .font(.system(size: 15))
                                HStack(alignment: .center, spacing: 0.0){
                                    ZStack(alignment: .leading){
                                        if name.isEmpty {
                                            Text("Name")
                                                .padding(.leading)
                                                .foregroundColor(Color(K.Colors.lightGray))
                                        }
                                        TextField("", text: $name)
                                            .padding(.leading)
                                            .disableAutocorrection(true)
                                            .textInputAutocapitalization(.never)
                                            .opacity(0.75)
                                            .padding(0)
                                            .keyboardType(.namePhonePad)
                                            .textContentType(.name)
                                            .foregroundStyle(Color.black)
                                    }
                                    Spacer()
                                    Image(systemName: "person.fill")
                                        .foregroundStyle(Color(K.Colors.lightGray))
                                        .padding(.trailing)
                                }
                                .frame(height: 50)
                                .overlay(
                                    RoundedRectangle(cornerSize: .init(width: 7, height: 7))
                                        .stroke(Color(K.Colors.justLightGray).opacity(0.5), lineWidth: 1)
                                )
                            }
                            VStack(alignment: .leading, spacing: 20){
                                Text("Create Username")
                                    .fontWeight(.semibold)
                                    .font(.system(size: 15))
                                HStack(alignment: .center, spacing: 0.0){
                                    ZStack(alignment: .leading){
                                        if username.isEmpty {
                                            Text("Username")
                                                .padding(.leading)
                                                .foregroundColor(Color(K.Colors.lightGray))
                                        }
                                        TextField("", text: $username)
                                            .padding(.leading)
                                            .disableAutocorrection(true)
                                            .textInputAutocapitalization(.never)
                                            .opacity(0.75)
                                            .padding(0)
                                            .keyboardType(.namePhonePad)
                                            .textCase(.lowercase)
                                            .textContentType(.username)
                                            .foregroundStyle(Color.black)
                                    }
                                    Spacer()
                                    Image(systemName: "at")
                                        .foregroundStyle(Color(K.Colors.lightGray))
                                        .padding(.trailing)
                                }
                                .frame(height: 50)
                                .overlay(
                                    RoundedRectangle(cornerSize: .init(width: 7, height: 7))
                                        .stroke(Color(K.Colors.justLightGray).opacity(0.5), lineWidth: 1)
                                )
                            }
                            VStack(alignment: .leading, spacing: 20){
                                Text("Country")
                                    .fontWeight(.semibold)
                                    .font(.system(size: 15))
                                HStack(alignment: .center, spacing: 0.0){
                                    ZStack(alignment: .leading){
                                        if country.isEmpty {
                                            Text("Country")
                                                .padding(.leading)
                                                .foregroundColor(Color(K.Colors.lightGray))
                                        }
                                        TextField("", text: $country)
                                            .padding(.leading)
                                            .disableAutocorrection(true)
                                            .textInputAutocapitalization(.never)
                                            .opacity(0.75)
                                            .padding(0)
                                            .textContentType(.countryName)
                                            .foregroundStyle(Color.black)
                                    }
                                    Spacer()
                                    Image(systemName: "flag.fill")
                                        .foregroundStyle(Color(K.Colors.lightGray))
                                        .padding(.trailing)
                                }
                                .frame(height: 50)
                                .overlay(
                                    RoundedRectangle(cornerSize: .init(width: 7, height: 7))
                                        .stroke(Color(K.Colors.justLightGray).opacity(0.5), lineWidth: 1)
                                )
                            }
                            VStack(alignment: .leading, spacing: 20){
                                Text("Phone")
                                    .fontWeight(.semibold)
                                    .font(.system(size: 15))
                                HStack(alignment: .center, spacing: 0.0){
                                    ZStack(alignment: .leading){
                                        iPhoneNumberField("Phone Number", text: $phone)
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
                            
                            
                        }
                        
                        Button(action: {
                            updateFunc()
                            fetchDictionary()
                        }){
                            Text("Update Profile")
                                .foregroundStyle(Color.white)
                                .frame(maxWidth: .infinity)
                        }
                        .padding()
                        .background(Color(K.Colors.mainColor))
                        .cornerRadius(7)
                        .padding(.vertical)
                    }
                    .padding(.horizontal, 15)
                    
                    if errReg != ""{
                        Text(errReg)
                            .foregroundStyle(Color(K.Colors.pink))
                            .padding(.horizontal, 15)
                    }
                }
            }
            .toolbar(content: {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {self.showingEditingProfile.toggle()}){
                        Text("Cancel")
                            .foregroundStyle(Color(K.Colors.mainColor))
                    }
                }
            })
        }
    }
    
    private func updateFunc(){
        viewModel.updateProfile(image: image, name: name, username: username, country: country, phone: phone, documentId: documentId, oldImageLink: profileImage)
        self.showingEditingProfile.toggle()
        self.fetchDictionary()
        errReg = viewModel.err
    }
    
    @Environment(\.defaultMinListRowHeight) var minRowHeight
    
    var settings: some View{
        NavigationStack{
            ZStack{
                ScrollView{
                    HStack(spacing: 19){
                        if profileImage != ""{
                            AsyncImage(url: URL(string: profileImage)){image in
                                image.resizable()
                            }placeholder: {
                                ProgressView()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 40, height: 40)
                            }
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 40, height: 40)
                            .cornerRadius(.infinity)
                            .overlay(
                                Circle().stroke(Color(K.Colors.darkGray).opacity(0.6), lineWidth: 1)
                                )
                            .onTapGesture {
                                withAnimation{
                                    self.width.toggle()
                                }
                            }
                        }else{
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 40, height: 40)
                                .symbolRenderingMode(.multicolor)
                                .foregroundColor(Color(K.Colors.justLightGray))
                                .overlay(
                                    Circle().stroke(Color(K.Colors.darkGray).opacity(0.6), lineWidth: 1)
                                    )
                                .onTapGesture {
                                    withAnimation{
                                        self.width.toggle()
                                    }
                                }
                        }
                        VStack(alignment: .leading){
                            HStack{
                                Text(name)
                                    .font(.system(size: 20))
                                    .fontWeight(.bold)
                                Text(cristian ? "†" : "")
                                        .font(.title2)
                                        .fontWeight(.bold)
                            }
                            Text(email)
                                .foregroundStyle(Color(K.Colors.mainColor))
                                .fontWeight(.light)
                                .font(.system(size: 15))
                        }
                        Spacer()
                    }
                    .padding(.top, 16)
                    .padding(.horizontal, 25)
                    VStack(alignment: .leading, spacing: 20){
                        VStack{
                            NavigationLink(destination: CurrentPersonView(user: .init(name: name, phoneNumber: phone, email: email, cristian: cristian, notes: notes, country: country, profileImage: profileImage, username: username))        .accentColor(Color(K.Colors.darkGray))){
                                HStack(spacing: 29){
                                    Image(systemName: "person")
                                        .font(.system(size: 29))
                                        .fontWeight(.light)
                                    VStack(alignment: .leading, spacing: 5){
                                        Text("Profile Info")
                                            .fontWeight(.semibold)
                                            .font(.system(size: 15))
                                            .foregroundStyle(.primary)
                                        Text("Info, email, username...")
                                            .font(.system(size: 11))
                                            .foregroundStyle(.secondary)
                                    }
                                    Spacer()
                                    Image(systemName: "chevron.forward")
                                        .frame(width: 28)
                                }
                                .padding(.horizontal, 25)
                            }
                            Divider()
                        }
                        VStack{
                            NavigationLink(destination: AllPeopleView()){
                                HStack(spacing: 15){
                                    Image(systemName: "person.3")
                                        .font(.system(size: 25))
                                        .fontWeight(.light)
                                VStack(alignment: .leading, spacing: 5){
                                        Text("People")
                                            .font(.system(size: 15))
                                            .fontWeight(.semibold)
                                            .foregroundStyle(.primary)
                                        Text("New Friend, Invited, Attanded...")
                                            .font(.system(size: 11))
                                            .foregroundStyle(.secondary)
                                    }
                                    Spacer()
                                    Image(systemName: "chevron.forward")
                                        .frame(width: 28)
                                }
                                .padding(.leading, 20)
                                .padding(.trailing, 25)
                            }
                            Divider()
                        }
                        VStack{
                            NavigationLink(destination: SearchView()){
                                HStack(spacing: 29){
                                    Image(systemName: "bell.badge")
                                        .font(.system(size: 29))
                                        .fontWeight(.light)
                                    VStack(alignment: .leading, spacing: 5){
                                        Text("Notifications")
                                            .fontWeight(.semibold)
                                            .font(.system(size: 15))
                                            .foregroundStyle(.primary)
                                        Text("Notifications, reminders...")
                                            .font(.system(size: 11))
                                            .foregroundStyle(.secondary)
                                    }
                                    Spacer()
                                    Image(systemName: "chevron.forward")
                                        .frame(width: 28)
                                }
                                .padding(.horizontal, 25)
                            }
                            Divider()
                        }
                        VStack{
                            NavigationLink(destination: Text("Settings")){
                                HStack(spacing: 29){
                                    Image(systemName: "gearshape")
                                        .font(.system(size: 29))
                                        .fontWeight(.light)
                                    VStack(alignment: .leading, spacing: 5){
                                        Text("Settings")
                                            .fontWeight(.semibold)
                                            .font(.system(size: 15))
                                            .foregroundStyle(.primary)
                                        Text("Theme, color, password...")
                                            .font(.system(size: 11))
                                            .foregroundStyle(.secondary)
                                    }
                                    Spacer()
                                    Image(systemName: "chevron.forward")
                                        .frame(width: 28)
                                }
                                .padding(.horizontal, 25)
                            }
                            Divider()
                        }
                    }
                    .accentColor(Color(K.Colors.lightGray))
                    .padding(.top, 67)
                    Spacer()
                        .frame(height: 300)
                    VStack{
                        Button(action: {
                            self.logoutAlert.toggle()
                        }){
                            HStack(spacing: 29){
                                Image(systemName: "rectangle.portrait.and.arrow.right")
                                    .font(.system(size: 29))
                                    .fontWeight(.light)
                                    Text("Log Out")
                                        .fontWeight(.semibold)
                                        .font(.system(size: 15))
                                        .foregroundStyle(.primary)
                                    
                                Spacer()
                            }
                            .padding(.horizontal, 25)
                        }
                        .accentColor(Color(K.Colors.lightGray))
                        Divider()
                            .padding(.bottom, 25)
                    }
                }
                .alert("Logout", isPresented: $logoutAlert) {
                    Button("Cancel", role: .cancel) {}
                    Button("Yes", role: .destructive) {
                        self.logoutAlert.toggle()
                        viewModel.logOut()
                    }
                }message: {
                    Text("Are you sure?")
                }
                if width{
                    VStack(alignment: .center){
                        if profileImage != ""{
                            AsyncImage(url: URL(string: profileImage)){image in
                                image.resizable()
                            }placeholder: {
                                ProgressView()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                            }
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }else{
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .symbolRenderingMode(.multicolor)
                                .foregroundColor(Color(K.Colors.justLightGray))
                        }
                    }
                    .onAppear{
                        withAnimation{
                            self.tabBar = false
                        }
                    }
                    .onDisappear{
                        withAnimation{
                            self.tabBar = true
                        }
                    }
                    .background(
                        Color.black.opacity(0.9)
                    )
                        .onTapGesture {
                            withAnimation{
                                self.width.toggle()
                            }
                        }
                }
            }
            .toolbar(content: {
                ToolbarItem(placement: .topBarTrailing, content: {
                    Button(action: {viewModel.logOut()}){
                        Image(systemName: "square.and.pencil")
                            .foregroundStyle(Color(K.Colors.mainColor))
                    }
                })
                ToolbarItem(placement: .topBarLeading, content: {
                    Button(action: {self.showingEditingProfile.toggle()}){
                        Image(systemName: "square.and.pencil")
                            .foregroundStyle(Color(K.Colors.mainColor))
                    }
                })
            })
            .frame(maxWidth: .infinity)
        }
        .onAppear{
            fetchDictionary()
        }
        .sheet(isPresented: $showingEditingProfile, onDismiss: {}, content: {
            update
        })
        
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
    
    func fetchDictionary(){
        print("apear")
        if let userID = Auth.auth().currentUser?.uid{
            db.collection("users").document("profiles").collection(userID).getDocuments() { querySnapshot, err in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
//                        print("\(document.documentID) => \(document.data())")
                        let dictionary = document.data()
                        
//                        print("dictionary:   -\(dictionary)")
                        let email = dictionary["email"] as! String
                        let username = dictionary["username"] as! String
                        let profileImage = dictionary["profileImageUrl"] as! String
                        let name = dictionary["name"] as! String
                        let phone = dictionary["phoneNumber"] as! String
                        let country = dictionary["country"] as! String
                        
                        self.profileImage = profileImage
                        
                        self.name = name
                        self.email = email
                        self.username = username
                        self.phone = phone
                        self.documentId = document.documentID
                        self.country = country
                    }
                }
            }
            
        }
    }
}


#Preview {
    AppView()
        .environmentObject(AppViewModel())
        .modelContainer(for: [UserProfile.self, Items.self, ItemsTitle.self])
}


struct SearchView: View {
    @State private var searchText = ""
    let allNames = ["Subh", "Vina", "Melvin", "Sefanie", "Sefanie", "Sefanie", "Sefanie", "Sefanie", "Sefanie", "Sefanie", "Sefanie", "Sefanie", "Sefanie", "Sefanie", "Sefanie", "Sefanie", "Sefanie", "Sefanie", "Sefanie", "Sefanie", "Sefanie", "Sefanie", "Sefanie", "Sefanie", "Sefanie", "Sefanie", "Sefanie", "Sefanie", "Sefanie", "Sefanie", "Sefanie", "Sefanie", "Sefanie", "Sefanie", "Sefanie", "Sefanie", "Sefanie", "Sefanie", "Sefanie"]
    var body: some View {
        NavigationView {
            List(filteredNames, id: \.self) { name in
                Text(name)
            }
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .automatic), prompt: "Look for something")
            .navigationTitle("Searching")
        }
    }

    var filteredNames: [String] {
        if searchText.isEmpty {
            return allNames
        } else {
            return allNames.filter { $0.localizedCaseInsensitiveContains(searchText) }
        }
    }
}


struct CustomTabBarItem: View {
    let iconName: String
    let label: String
    let selection: Binding<Int> // 1
    let tag: Int // 2
    
    var body: some View {
        VStack(alignment: .center) {
            Image(systemName: iconName)
                .frame(minWidth: 25, minHeight: 25)
            Text(label)
                .font(.caption)
        }
        .padding([.top, .bottom], 5)
        .foregroundColor(fgColor()) // 4
        .frame(maxWidth: .infinity)
        .contentShape(Rectangle())
        .onTapGesture {
            self.selection.wrappedValue = self.tag // 3
        }
    }
    
    private func fgColor() -> Color {
        return selection.wrappedValue == tag ? Color(K.Colors.mainColor) : Color(K.Colors.gray)
    }
}
