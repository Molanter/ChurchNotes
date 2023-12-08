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
    @State var accentColor = false
    @State var firebaseError = false
    @State var firebaseErr = ""
    @State var bigPhoto = false
    var db = Firestore.firestore()
    var auth = Auth.auth()
    @State private var selection: Int = 0
    
    @EnvironmentObject var published: PublishedVariebles
    @EnvironmentObject var viewModel: AppViewModel
    @EnvironmentObject var networkMonitor: NetworkMonitor
    
    var body: some View {
        ZStack(alignment: .bottom){
            TabView(selection: $selection){
                
                ItemView()
                    .searchable(text: $published.searchText,
                                placement: .navigationBarDrawer(displayMode: .automatic),
                                prompt: "Search Name")
                    .tag(0)
                settings
                    .tag(1)
            }
            .accentColor(accentColor ? Color.white : Color(K.Colors.mainColor))
            if !published.tabsAreHidden{
                HStack(alignment: .lastTextBaseline) {
                    CustomTabBarItem(iconName: "list.bullet.clipboard",
                                     label: "People",
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
                .frame(height: 45)
                .frame(maxWidth: .infinity)
                .background(Color(K.Colors.background).opacity(0))
                .opacity(published.tabsAreHidden ? 0 : 1)
            }
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
                                    .frame(width: bigPhoto ? .infinity : 40, height: bigPhoto ? .infinity : 40)
                            }
                            .aspectRatio(contentMode: .fill)
                            .frame(width: bigPhoto ? .infinity : 40, height: bigPhoto ? .infinity : 40)
                            .cornerRadius(bigPhoto ? 0 : .infinity)
                            .overlay(
                                Circle().stroke(bigPhoto ? Color.clear : Color(K.Colors.darkGray).opacity(0.6), lineWidth: 1)
                            )
                            .onTapGesture {
                                withAnimation{
                                    self.width = true
                                    published.tabsAreHidden = true
                                }
                            }
                        }else{
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: bigPhoto ? .infinity : 40, height: bigPhoto ? .infinity : 40)
                                .symbolRenderingMode(.multicolor)
                                .foregroundColor(Color(K.Colors.justLightGray))
                                .overlay(
                                    Circle().stroke(bigPhoto ? Color.clear : Color(K.Colors.darkGray).opacity(0.6), lineWidth: 1)
                                )
                                .onTapGesture {
                                    withAnimation{
                                        self.width = true
                                        published.tabsAreHidden.toggle()
                                    }
                                }
                        }
                        if !bigPhoto{
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
                        }
                        Spacer()
                    }
                    .padding(.top, 16)
                    .padding(.horizontal, bigPhoto ? 0 : 25)
                    VStack(alignment: .leading, spacing: 20){
                        VStack{
                            NavigationLink(destination: CurrentPersonView(cristian: cristian, name: name, phone: phone, email: email, country: country, notes: notes, profileImage: profileImage, username: username, timeStamp: timeStamp)        .accentColor(Color(K.Colors.darkGray))){
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
                            NavigationLink(destination: AchievementsMainView()){
                                HStack(spacing: 29){
                                    Image(systemName: "medal")
                                        .font(.system(size: 29))
                                        .fontWeight(.light)
                                    VStack(alignment: .leading, spacing: 5){
                                        Text("Achievements")
                                            .font(.system(size: 15))
                                            .fontWeight(.semibold)
                                            .foregroundStyle(.primary)
                                        Text("Your achievements, score")
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
                            NavigationLink(destination: NotificationView()){
                                HStack(spacing: 29){
                                    Image(systemName: "bell.badge")
                                        .symbolRenderingMode(.palette)
                                        .foregroundStyle(Color(K.Colors.mainColor), Color(K.Colors.lightGray))
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
                            NavigationLink(destination: AppearanceView(profileImage: profileImage, name: name, email: email, username: username, phone: phone, country: country, notes: notes, timeStamp: timeStamp)){
                                HStack(spacing: 29){
                                    Image(systemName: "paintbrush")
                                        .font(.system(size: 29))
                                        .fontWeight(.light)
                                    VStack(alignment: .leading, spacing: 5){
                                        Text("Appearance")
                                            .fontWeight(.semibold)
                                            .font(.system(size: 15))
                                            .foregroundStyle(.primary)
                                        Text("Theme, color")
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
                            NavigationLink(destination: SettingsView()){
                                HStack(spacing: 29){
                                    Image(systemName: "gearshape")
                                        .font(.system(size: 29))
                                        .fontWeight(.light)
                                    VStack(alignment: .leading, spacing: 5){
                                        Text("Settings")
                                            .fontWeight(.semibold)
                                            .font(.system(size: 15))
                                            .foregroundStyle(.primary)
                                        Text("Change password")
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
                                        .symbolRenderingMode(.palette)
                                        .foregroundStyle(Color(K.Colors.lightGray), Color(K.Colors.lightGray))
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
                    .padding(.top, bigPhoto ? 10 : 67)
                    //                    .background(GeometryReader {
                    //                        Color.clear.preference(key: ViewOffsetKey.self,
                    //                                               value: -$0.frame(in: .named("scroll")).origin.y)
                    //                    })
                    //                    .onPreferenceChange(ViewOffsetKey.self) {
                    //                        print("offset >> \($0)")
                    //                        if $0 <= -235 {
                    //                            withAnimation{
                    //                                bigPhoto = true
                    //                            }
                    //                        }else if bigPhoto == true && $0 >= -310{
                    //                            withAnimation{
                    //                                bigPhoto = false
                    //                            }
                    //                        }else if $0 <= -160{
                    //                            withAnimation{
                    //                                bigPhoto = false
                    //                            }
                    //                        }
                    //                    }
                    
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
                    .background(
                        Color
                            .black
                            .ignoresSafeArea(.all)
                            .opacity(0.9)
                    )
                    .onTapGesture {
                        withAnimation{
                            self.width = false
                            published.tabsAreHidden = false
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
                NavigationStack{
                    EditProfileView(showingEditingProfile: $showingEditingProfile)
                        .toolbar(content: {
                            ToolbarItem(placement: .topBarLeading) {
                                Button(action: {self.showingEditingProfile = false}){
                                    Text("Cancel")
                                        .foregroundStyle(Color(K.Colors.mainColor))
                                }
                            }
                        })
                }
            })
        }
        
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
        
    }
    
    func showFirebaseError(error: String){
        withAnimation{
            firebaseError = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            withAnimation{
                firebaseError = false
            }
        }
    }
}


#Preview {
    AppView()
}


