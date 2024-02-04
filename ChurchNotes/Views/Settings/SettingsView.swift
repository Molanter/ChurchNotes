//
//  SettingsView.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 12/26/23.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore


struct SettingsView: View {
    @State var name = "name"
    @State var phone = "+1234567890"
    @State var email = "email@gmail.com"
    @State var cristian = true
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
    
    @StateObject var manager = NotificationsManager()
    
    @EnvironmentObject var published: PublishedVariebles
    @EnvironmentObject var viewModel: AppViewModel
    @EnvironmentObject var networkMonitor: NetworkMonitor
    
    var body: some View{
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
                                    .frame(width: bigPhoto ? .infinity : 50, height: bigPhoto ? .infinity : 50)
                            }
                            .aspectRatio(contentMode: .fill)
                            .frame(width: bigPhoto ? .infinity : 50, height: bigPhoto ? .infinity : 50)
                            .cornerRadius(bigPhoto ? 0 : .infinity)
                            .overlay(
                                Circle().stroke(bigPhoto ? Color.clear : Color(K.Colors.darkGray).opacity(0.6), lineWidth: 1)
                            )
                            .onTapGesture {
                                withAnimation{
                                    self.width = true
                                }
                            }
                        }else{
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: bigPhoto ? .infinity : 50, height: bigPhoto ? .infinity : 50)
                                .symbolRenderingMode(.multicolor)
                                .foregroundColor(Color(K.Colors.justLightGray))
                                .overlay(
                                    Circle().stroke(bigPhoto ? Color.clear : Color(K.Colors.darkGray).opacity(0.6), lineWidth: 1)
                                )
                                .onTapGesture {
                                    withAnimation{
                                        self.width = true
                                    }
                                }
                        }
                        if !bigPhoto{
                            VStack(alignment: .leading, spacing: 0){
                                HStack{
                                    Text(name)
                                        .font(.system(size: 20))
                                        .fontWeight(.bold)
                                    Text(cristian ? "†" : "")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                }
                                HStack(spacing: 10){
                                    ZStack{
                                        if let badg = viewModel.currentUser?.badge{
                                            if let b = K.Badges().getBadgeArray()[badg] as? Badge{
                                                if b.string != ""{
                                                    Text(b.string)
                                                        .foregroundStyle(Color.white)
                                                        .font(.system(size: 11))
                                                        .padding(4)
                                                        .background(
                                                            Circle()
                                                                .fill(Color(K.Colors.mainColor))
                                                                .opacity(0.7)
                                                        )                                            }else{
                                                    Image(systemName: b.image)
                                                                .foregroundStyle(Color.white)
                                                        .font(.system(size: 11))
                                                        .padding(4)
                                                        .background(
                                                            Circle()
                                                                .fill(Color(K.Colors.mainColor))
                                                                .opacity(0.7)
                                                        )
                                                }
                                            }
                                        }
                                    }
                                    Divider()
                                    Text(email)
                                        .foregroundStyle(Color(K.Colors.mainColor))
                                        .fontWeight(.light)
                                        .font(.system(size: 15))
                                }
                            }
                        }
                        Spacer()
                    }
                    .padding(.top, 16)
                    .padding(.horizontal, bigPhoto ? 0 : 25)
                    VStack(alignment: .leading, spacing: 20){
                        VStack{
                            NavigationLink(destination: CurrentPersonView().onAppear(perform: {
                                published.tabsAreHidden = true
                            })
                                .toolbar(.hidden, for: .tabBar)
                                .navigationBarTitleDisplayMode(.inline)
                            ){
                                            HStack(spacing: 29){
                                                Image(systemName: "person")
                                                    .font(.system(size: 29))
                                                    .fontWeight(.light)
                                                VStack(alignment: .leading, spacing: 5){
                                                    Text("profile-info")
                                                        .fontWeight(.semibold)
                                                        .font(.system(size: 15))
                                                        .foregroundStyle(.primary)
                                                    Text("info-email-username")
                                                        .font(.system(size: 11))
                                                        .foregroundStyle(.secondary)
                                                }
                                                Spacer()
                                                Image(systemName: "chevron.forward")
                                                    .frame(width: 28)
                                            }
                                            .padding(.horizontal, 25)
                                        }
                            .navigationDestination(
                                isPresented: Binding(
                                    get: { published.currentSettingsNavigationLink == "profile-info" },
                                    set: { newValue in
                                        published.currentSettingsNavigationLink = newValue ? "profile-info" : nil
                                    }
                                )
                            ) {
                                CurrentPersonView()
                                    .onAppear(perform: {
                                        published.tabsAreHidden = true
                                    })
                                        .toolbar(.hidden, for: .tabBar)
                                    .navigationBarTitleDisplayMode(.inline)
                            }
                            Divider()
                        }
                        VStack{
                            NavigationLink(destination: SettingsPeopleView()
                                .onAppear(perform: {
                                    published.tabsAreHidden = true
                                })
                                    .toolbar(.hidden, for: .tabBar)
                                .navigationBarTitleDisplayMode(.inline)
                            ){
                                            HStack(spacing: 15){
                                                Image(systemName: "person.3")
                                                    .font(.system(size: 25))
                                                    .fontWeight(.light)
                                                VStack(alignment: .leading, spacing: 5){
                                                    Text("people")
                                                        .font(.system(size: 15))
                                                        .fontWeight(.semibold)
                                                        .foregroundStyle(.primary)
                                                    Text("all-people-favourite-deleted")
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
                            .navigationDestination(
                                isPresented: Binding(
                                    get: { published.currentSettingsNavigationLink == "people" },
                                    set: { newValue in
                                        published.currentSettingsNavigationLink = newValue ? "people" : nil
                                    }
                                )
                            ) {
                                SettingsPeopleView()
                                    .onAppear(perform: {
                                        published.tabsAreHidden = true
                                    })
                                        .toolbar(.hidden, for: .tabBar)
                                    .navigationBarTitleDisplayMode(.inline)
                            }
                            Divider()
                        }
                        VStack{
                            NavigationLink(destination: AchievementsMainView()
                                .onAppear(perform: {
                                    published.tabsAreHidden = true
                                })
                                    .toolbar(.hidden, for: .tabBar)
                                .navigationBarTitleDisplayMode(.inline)
                            ){
                                            HStack(spacing: 29){
                                                Image(systemName: "medal")
                                                    .font(.system(size: 29))
                                                    .fontWeight(.light)
                                                VStack(alignment: .leading, spacing: 5){
                                                    Text("achievements")
                                                        .font(.system(size: 15))
                                                        .fontWeight(.semibold)
                                                        .foregroundStyle(.primary)
                                                    Text("your-achievements-score")
                                                        .font(.system(size: 11))
                                                        .foregroundStyle(.secondary)
                                                }
                                                Spacer()
                                                Image(systemName: "chevron.forward")
                                                    .frame(width: 28)
                                            }
                                            .padding(.horizontal, 25)
                                        }
                                .navigationDestination(
                                    isPresented: Binding(
                                        get: { published.currentSettingsNavigationLink == "achievements" },
                                        set: { newValue in
                                            published.currentSettingsNavigationLink = newValue ? "achievements" : nil
                                        }
                                    )
                                ) {
                                    AchievementsMainView()
                                        .onAppear(perform: {
                                            published.tabsAreHidden = true
                                        })
                                            .toolbar(.hidden, for: .tabBar)
                                        .navigationBarTitleDisplayMode(.inline)
                                }
                            Divider()
                        }
                        VStack{
                            NavigationLink(destination: NotificationView()
                                .onAppear(perform: {
                                    published.tabsAreHidden = true
                                })
                                    .toolbar(.hidden, for: .tabBar)
                                .navigationBarTitleDisplayMode(.inline)
                            ){
                                            HStack(spacing: 29){
                                                Image(systemName: "bell.badge")
                                                    .symbolRenderingMode(.palette)
                                                    .foregroundStyle(Color(K.Colors.mainColor), Color(K.Colors.lightGray))
                                                    .font(.system(size: 29))
                                                    .fontWeight(.light)
                                                VStack(alignment: .leading, spacing: 5){
                                                    Text("notifications")
                                                        .fontWeight(.semibold)
                                                        .font(.system(size: 15))
                                                        .foregroundStyle(.primary)
                                                    Text("notifications-reminders")
                                                        .font(.system(size: 11))
                                                        .foregroundStyle(.secondary)
                                                }
                                                Spacer()
                                                Image(systemName: "chevron.forward")
                                                    .frame(width: 28)
                                            }
                                            .padding(.horizontal, 25)
                                        }
                            .navigationDestination(
                                isPresented: Binding(
                                    get: { published.currentSettingsNavigationLink == "notifications" },
                                    set: { newValue in
                                        published.currentSettingsNavigationLink = newValue ? "notifications" : nil
                                    }
                                )
                            ) {
                                NotificationView()
                                    .onAppear(perform: {
                                        published.tabsAreHidden = true
                                    })
                                        .toolbar(.hidden, for: .tabBar)
                                    .navigationBarTitleDisplayMode(.inline)
                            }
                            Divider()
                        }
                        VStack{
                            NavigationLink(destination: AppearanceView(profileImage: profileImage, name: name, email: email, username: username, phone: phone, country: country, notes: notes, timeStamp: timeStamp)
                                .onAppear(perform: {
                                    published.tabsAreHidden = true
                                })
                                    .toolbar(.hidden, for: .tabBar)
                                .navigationBarTitleDisplayMode(.inline)
                            ){
                                            HStack(spacing: 29){
                                                Image(systemName: "paintbrush")
                                                    .font(.system(size: 29))
                                                    .fontWeight(.light)
                                                VStack(alignment: .leading, spacing: 5){
                                                    Text("appearance")
                                                        .fontWeight(.semibold)
                                                        .font(.system(size: 15))
                                                        .foregroundStyle(.primary)
                                                    Text("theme-color")
                                                        .font(.system(size: 11))
                                                        .foregroundStyle(.secondary)
                                                }
                                                Spacer()
                                                Image(systemName: "chevron.forward")
                                                    .frame(width: 28)
                                            }
                                            .padding(.horizontal, 25)
                                        }
                            .navigationDestination(
                                isPresented: Binding(
                                    get: { published.currentSettingsNavigationLink == "appearance" },
                                    set: { newValue in
                                        published.currentSettingsNavigationLink = newValue ? "appearance" : nil
                                    }
                                )
                            ) {
                                AppearanceView(profileImage: profileImage, name: name, email: email, username: username, phone: phone, country: country, notes: notes, timeStamp: timeStamp)
                                    .onAppear(perform: {
                                        published.tabsAreHidden = true
                                    })
                                        .toolbar(.hidden, for: .tabBar)
                                    .navigationBarTitleDisplayMode(.inline)
                            }
                            Divider()
                        }
                        VStack{
                            NavigationLink(destination: AccountSettingsView()
                                .onAppear(perform: {
                                    published.tabsAreHidden = true
                                })
                                    .toolbar(.hidden, for: .tabBar)
                                .navigationBarTitleDisplayMode(.inline)
                            ){
                                            HStack(spacing: 29){
                                                Image(systemName: "gearshape")
                                                    .font(.system(size: 29))
                                                    .fontWeight(.light)
                                                VStack(alignment: .leading, spacing: 5){
                                                    Text("settings")
                                                        .fontWeight(.semibold)
                                                        .font(.system(size: 15))
                                                        .foregroundStyle(.primary)
                                                    Text("change-password-email")
                                                        .font(.system(size: 11))
                                                        .foregroundStyle(.secondary)
                                                }
                                                Spacer()
                                                Image(systemName: "chevron.forward")
                                                    .frame(width: 28)
                                            }
                                            .padding(.horizontal, 25)
                                        }
                            .navigationDestination(
                                isPresented: Binding(
                                    get: { published.currentSettingsNavigationLink == "settings" },
                                    set: { newValue in
                                        published.currentSettingsNavigationLink = newValue ? "settings" : nil
                                    }
                                )
                            ) {
                                AccountSettingsView()
                                    .onAppear(perform: {
                                        published.tabsAreHidden = true
                                    })
                                        .toolbar(.hidden, for: .tabBar)
                                    .navigationBarTitleDisplayMode(.inline)
                            }
                            Divider()
                        }
                        if K.testFeatures{
                            VStack{
                                NavigationLink(destination: SupportMainView()
                                    .onAppear(perform: {
                                        published.tabsAreHidden = true
                                    })
                                        .toolbar(.hidden, for: .tabBar)
                                    .navigationBarTitleDisplayMode(.inline)
                                ){
                                                HStack(spacing: 29){
                                                    Image(systemName: "wrench.and.screwdriver")
                                                        .font(.system(size: 25))
                                                        .fontWeight(.light)
                                                    VStack(alignment: .leading, spacing: 5){
                                                        Text("ssupport")
                                                            .font(.system(size: 15))
                                                            .fontWeight(.semibold)
                                                            .foregroundStyle(.primary)
                                                        Text("support-reports-questions")
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
                                .navigationDestination(
                                    isPresented: Binding(
                                        get: { published.currentSettingsNavigationLink == "support" },
                                        set: { newValue in
                                            published.currentSettingsNavigationLink = newValue ? "support" : nil
                                        }
                                    )
                                ) {
                                    SupportMainView()
                                        .onAppear(perform: {
                                            published.tabsAreHidden = true
                                        })
                                            .toolbar(.hidden, for: .tabBar)
                                        .navigationBarTitleDisplayMode(.inline)
                                }
                                Divider()
                            }
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
                                    Text("log-out")
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
                .alert("logout", isPresented: $logoutAlert) {
                    Button("cancel", role: .cancel) {}
                    Button("yes", role: .destructive) {
                        self.logoutAlert.toggle()
                        viewModel.logOut()
                        viewModel.deleteFcmToken(token: published.fcm)
                    }
                }message: {
                    Text("are-you-sure")
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
//                if networkMonitor.isConnected{
//                    HStack(alignment: .center){
//                        HStack{
//                            Image(systemName: "wifi.slash")
//                                .resizable()
//                                .aspectRatio(contentMode: .fit)
//                                .frame(height: 35)
//                            Text("no-internet-connection")
//                        }
//                        .foregroundStyle(Color(K.Colors.justDarkGray))
//                    }
//                    .frame(height: 40)
//                    .frame(maxWidth: .infinity)
//                    .background(Color(K.Colors.justLightGray))
//                    .cornerRadius(7)
//                    .onTapGesture(perform: {
//                        withAnimation{
//                            firebaseError = false
//                        }
//                    })
//                    .offset(y: firebaseError ? 20 : -150)
//                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(content: {
                if viewModel.currentUser?.role ?? "" == "jedai" || email == "123@2.com"{
                    ToolbarItem(placement: .topBarTrailing) {
                        NavigationLink(destination: ControlVolunteer()){
                                        Image(systemName: "apple.terminal")
                                    }
                    }
                }
            })
            .frame(maxWidth: .infinity)
            .onAppear{
                fetchDictionary()
                if !manager.hasPermission{
                    Task{
                        await manager.request()
                    }
                }
                if published.currentTabView == 3{
                    published.tabsAreHidden = false
                }
            }
            .onDisappear(perform: {
                if published.currentTabView == 3{
                    published.tabsAreHidden = true
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
    SettingsView()
}
