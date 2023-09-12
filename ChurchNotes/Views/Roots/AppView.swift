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
    @Environment(\.modelContext) private var modelContext
    @State var name = "name"
    @State var phone = "+1234567890"
    @State var email = "email@gmail.com"
    @State var cristian = true
    @State var showingEditingProfile = false
    @State var width = false
    @State var username = ""
    @State var country = ""
    @State var notes = ""
    @State var notificationTime = Date.now
    @State var notifications = false
    @State var image: UIImage?
    @State var profileImage = ""
    @State var timeStamp = Date.now
    @State var showImagePicker = false
    @State var errReg = ""
    @State var documentId = ""
    @State var logoutAlert = false
    @State var tabBar = true
    @State var accentColor = false
    @State var firebaseError = false
    @State var firebaseErr = ""
    var db = Firestore.firestore()
    var auth = Auth.auth()
    @State private var selection: Int = 0 // 1
    
    @EnvironmentObject var viewModel: AppViewModel
    @EnvironmentObject var networkMonitor: NetworkMonitor

    var body: some View {
        VStack(alignment: .center, spacing: 0) { // 2
            ZStack { // 3
                if (selection == 0) {
                    ItemView()
                } else if (selection == 1) {
                    settings
//                } else if (selection == 2) {
//                    CameraView(recipients: ["3235953205"], message: "Let's goo", item: items)
                }// else if (selection == 3) {
                //                            keypadContent()
                //                        } else if (selection == 4) {
                //                            voicemailContent()
                //                        }
            }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            if !width{
                HStack(alignment: .lastTextBaseline) {
                    CustomTabBarItem(iconName: "list.bullet.clipboard",
                                     label: "Notes",
                                     selection: $selection,
                                     tag: 0, settings: false)
                    CustomTabBarItem(iconName: "gearshape",
                                     label: "Settings",
                                     selection: $selection,
                                     tag: 1, settings: true)
//                    CustomTabBarItem(iconName: "person.crop.circle",
//                                     label: "Contacts",
//                                     selection: $selection,
//                                     tag: 2, settings: false)
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
                        if !width{
                            Rectangle()
                                .fill(Color(K.Colors.background))
                                .frame(width: parentGeometry.size.width, height: 0.5)
                                .position(x: parentGeometry.size.width / 2, y: 0)
                        }
                    }
                )
                .background(Color(K.Colors.background))
                .offset(y: width ? 150 : 0)
            }
        }.frame(maxHeight: .infinity, alignment: .bottom)
        //        .onAppear(){
        //            if itemTitles.isEmpty{
        //                addFirst()
        //            }
        //        }
            .accentColor(accentColor ? Color.white : Color(K.Colors.mainColor))
        
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
                .modifier(DismissingKeyboard())
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
        
    var settings: some View{
        NavigationStack{
            ZStack(alignment: .top){
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
                                NavigationLink(destination: CurrentPersonView(user: .init(name: name, phoneNumber: phone, email: email, cristian: cristian, notes: notes, country: country, profileImage: profileImage, username: username, timeStamp: Date.now))        .accentColor(Color(K.Colors.darkGray))){
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
                                NavigationLink(destination: SettingsPeopleView()){
                                    HStack(spacing: 15){
                                        Image(systemName: "person.3")
                                            .font(.system(size: 25))
                                            .fontWeight(.light)
                                        VStack(alignment: .leading, spacing: 5){
                                            Text("People")
                                                .font(.system(size: 15))
                                                .fontWeight(.semibold)
                                                .foregroundStyle(.primary)
                                            Text("All people, favourite, deleted...")
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
                                NavigationLink(destination: NotificationView(notifications: $notifications, documentId: $documentId, notificationTime: $notificationTime)){
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
                                NavigationLink(destination: SettingsView(profileImage: profileImage, name: name, email: email, username: username, phone: phone, country: country, notes: notes, timeStamp: timeStamp)){
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
                        .accentColor(Color(K.Colors.lightGray))
                        .padding(.top, 67)
                        
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
                    if firebaseError{
                        HStack(alignment: .center){
                            Text(firebaseErr)
                                .foregroundStyle(Color(K.Colors.justDarkGray))
                        }
                        .frame(height: 40)
                        .frame(maxWidth: .infinity)
                        .background(Color(K.Colors.justLightGray))
                        .cornerRadius(7)
                        .onTapGesture(perform: {
                            withAnimation{
                                firebaseError = false
                            }
                        })
                        .offset(y: firebaseError ? 20 : -150)
                    }
                if networkMonitor.isConnected{
                    HStack(alignment: .center){
                        HStack{
                            Image(systemName: "wifi.slash")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 35)
                            Text("No Internet connection!")
                        }
                        .foregroundStyle(Color(K.Colors.justDarkGray))
                    }
                    .frame(height: 40)
                    .frame(maxWidth: .infinity)
                    .background(Color(K.Colors.justLightGray))
                    .cornerRadius(7)
                    .onTapGesture(perform: {
                        withAnimation{
                            firebaseError = false
                        }
                    })
                    .offset(y: firebaseError ? 20 : -150)
                }
                }
                .toolbar(content: {
                    ToolbarItem(placement: .topBarTrailing, content: {
                        Button(action: {viewModel.logOut()}){
                            Image(systemName: "rectangle.portrait.and.arrow.right")
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
            .onAppear{
                fetchDictionary()
            }
            .sheet(isPresented: $showingEditingProfile, onDismiss: {}, content: {
                update
        })
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
    
    func fetchDictionary(){
        if let userID = Auth.auth().currentUser?.uid{
            db.collection("users").document(userID).getDocument { querySnapshot, err in
                if let err = err {
                    print("Error getting documents: \(err)")
                    showFirebaseError(error: err.localizedDescription)
                } else {
                    if let  document = querySnapshot {
                        //                        print("\(document.documentID) => \(document.data())")
                        let dictionary = document.data()
                        
                        //                        print("dictionary:   -\(dictionary)")
                        if let dictionary = dictionary{
                            let email = dictionary["email"] as! String
                            let username = dictionary["username"] as! String
                            let profileImage = dictionary["profileImageUrl"] as! String
                            let name = dictionary["name"] as! String
                            let notes = dictionary["notes"] as! String
                            let phone = dictionary["phoneNumber"] as! String
                            let country = dictionary["country"] as! String
                            let notifications = dictionary["notifications"] as! Bool
                            let notificationTime = (dictionary["notificationTime"] as? Timestamp)?.dateValue() ?? Date()
                            let timeStamp = (dictionary["timeStamp"] as? Timestamp)?.dateValue() ?? Date()
                            
                            self.notes = notes
                            self.timeStamp = timeStamp
                            self.notificationTime = notificationTime
                            self.profileImage = profileImage
                            self.notifications = notifications
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
        
        func showFirebaseError(error: String){
            withAnimation{
                firebaseError = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 7.0) {
                withAnimation{
                    firebaseError = false
                }
                }
        }
    }
}


#Preview {
    AppView()
        .modelContainer(for: [UserProfile.self, Items.self, ItemsTitle.self])
}


struct CustomTabBarItem: View {
    let iconName: String
    let label: String
    let selection: Binding<Int> // 1
    let tag: Int // 2
    let settings: Bool
    @State var backDegree = 0.0
    @State var frontDegree = 0.0
    @State private var angle: Double = 0

    var body: some View {
        VStack(alignment: .center) {
            ZStack{
                if settings{
                    if selection.wrappedValue == tag{
                        Image(systemName: "\(iconName).fill")
                            .rotation3DEffect(Angle(degrees: frontDegree), axis: (x: 0, y: 0, z: 1))
                            .frame(minWidth: 25, minHeight: 25)
                    }else{
                        Image(systemName: iconName)
                            .rotation3DEffect(Angle(degrees: backDegree), axis: (x: 0, y: 0, z: 1))
                            .frame(minWidth: 25, minHeight: 25)
                    }
                }else{
                        Image(systemName: selection.wrappedValue == tag ? "\(iconName).fill" : iconName)
                            .frame(minWidth: 25, minHeight: 25)
                            .contentTransition(.symbolEffect(.replace))
                }
            }
                .onChange(of: selection.wrappedValue) { newValue in
                    if settings{
                        withAnimation(.linear(duration: 0.3)){
                            backDegree = 90
                        }
                        if selection.wrappedValue == tag {
                            withAnimation(.linear(duration: 0.3)/*.delay(0.3)*/){
                                frontDegree = 90
                            }
                        } else {
                            withAnimation(.linear(duration: 0.3)) {
                                frontDegree = 0
                            }
                            withAnimation(.linear(duration: 0.3)/*.delay(0.3)*/){
                                backDegree = 0
                            }
                        }
                    }else{
                        
                    }
                }
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








