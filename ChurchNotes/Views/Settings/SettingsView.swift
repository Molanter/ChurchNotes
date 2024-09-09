//
//  SettingsView.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 12/26/23.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import SwiftData

struct SettingsView: View {
    @EnvironmentObject var published: PublishedVariebles
    @EnvironmentObject var viewModel: AppViewModel
    @EnvironmentObject var networkMonitor: NetworkMonitor
    @Environment(\.modelContext) var modelContext
    
//    @State private var viewModel = PeopleViewModel()

    @StateObject var manager = ReminderManager()

    @Query var credentials: [Credential]
    @Query var ints: [IntDataModel]
    @Query var strings: [StringDataModel]
    @Query var bools: [BoolDataModel]

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
    @State private var pass = ""
    @State private var showAskPass = false
    @State var emailToLogin = ""
    @State var passToLogin = ""
    @State var wrongPass = 0
    
    var db = Firestore.firestore()
    var auth = Auth.auth()
    let buttonWidth = UIScreen.screenWidth / 5
    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    let settingsNLs = SettingsNLs()
    
    var appPass: String {
        if let boolModel = strings.first(where: { $0.name == "appPass" }), let str = published.decrypt(boolModel.string) {
            return str
        } else {
            return ""
        }
    }
    var appPassType: Int {
        if let intModel = ints.first(where: { $0.name == "appPassType" }) {
            return Int(intModel.int)
        }else {
            return 1
        }
    }
    
    var secure: Bool {
        if let boolModel = bools.first(where: { $0.name == "appSecure" }) {
            return boolModel.bool
        } else {
            return false
        }
    }
    
    var backgroundType: String {
        if let strModel = strings.first(where: { $0.name == "backgroundType" }) {
            return strModel.string
        }else {
            return "none"
        }
    }
    
    var rowStyle: Int {
        if let intModel = ints.first(where: { $0.name == "rowStyle" }) {
            return intModel.int
        }else {
            return 0
        }
    }
    
    var bioAuthEnabled: Bool {
        if let boolModel = bools.first(where: { $0.name == "bioAuthEnabled" }) {
            return boolModel.bool
        }else {
            let newBool = BoolDataModel(name: "bioAuthEnabled", bool: false)
            modelContext.insert(newBool)
            return false
        }
    }
    
    var body: some View{
        NavigationStack{
            ZStack(alignment: .top){
                List{
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
                                        .font(.title3)
                                        .fontWeight(.bold)
                                    Text(cristian ? "†" : "")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                }
                                HStack(spacing: 10){
                                    if viewModel.currentUser?.badge != "" {
                                        BadgeView(width: 11)
                                        Divider()
                                    }
                                    Text(username)
                                        .foregroundStyle(K.Colors.mainColor)
                                        .fontWeight(.light)
                                        .font(.body)
                                }
                            }
                        }
                        Spacer()
                    }
                    .padding(.vertical, 5)
                    //                    .frame(maxWidth: .infinity)
                    .listRowBackground(
                        GlassListRow()
                    )
                    Section{
                        ScrollView(.horizontal){
                            HStack(spacing: 15){
                                NavigationLink(destination: AllPeopleView()
                                               
                                    .onAppear(perform: {
                                        if published.device == .phone {
                                            published.tabsAreHidden = true
                                        }
                                    })
                                               //                                            .toolbar(.hidden, for: .tabBar)
                                               
                                ){
                                    VStack(alignment: .leading, spacing: 5){
                                        
                                        Text(String(viewModel.peopleArray.count))
                                            .font(.headline)
                                            .fontWeight(.semibold)
                                        Text("people")
                                            .font(.footnote)
                                    }
                                    .foregroundStyle(Color(K.Colors.text))
                                }
                                Divider()
                                NavigationLink(destination: AchievementsMainView()
                                    .onAppear(perform: {
                                        if published.device == .phone {
                                            published.tabsAreHidden = true
                                        }
                                    })
                                               //                                            .toolbar(.hidden, for: .tabBar)
                                               
                                ){
                                    VStack(alignment: .leading, spacing: 5){
                                        Text(String(viewModel.badgesArray.count))
                                            .font(.headline)
                                            .fontWeight(.semibold)
                                        Text("bbadges")
                                            .font(.footnote)
                                    }
                                    .foregroundStyle(Color(K.Colors.text))
                                }
                                Divider()
                                Button(action: {
                                    self.published.showEditProfileSheet = true
                                }){
                                    Image(systemName: "square.and.pencil")
                                        .font(.system(size: 22))
                                        .foregroundStyle(Color.white)
                                        .padding(10)
                                        .background(K.Colors.mainColor)
                                        .cornerRadius(7)
                                }
                            }
                            .padding(.vertical, 10)
                            .padding(.horizontal, 25)
                        }
                        .scrollIndicators(.hidden)
                        .listRowInsets(EdgeInsets())
                    }
                    .listSectionSpacing(15)
                    .listRowBackground(
                        GlassListRow()
                    )
                    
                    ForEach(settingsNLs.nlArray, id: \.self) { array in
                                    Section {
                                        ForEach(array, id: \.self) { item in
                                            NavigationLink(destination: item.destination, label: {
                                                NavigationLinkModel(name: item.name, info: item.info, systemImageName: item.systemImage, leading: item.leading)
                                            })
                                        }
                                    }
                                    .listSectionSpacing(15)
                                    .listRowBackground(
                                        GlassListRow()
                                    )
                                }
                    Section{
                        VStack{
                            Button(action: {
                                self.logoutAlert.toggle()
                            }){
                                if rowStyle == 1 {
                                    HStack(spacing: 20) {
                                        ZStack(alignment: .center) {
                                            RoundedRectangle(cornerRadius: 5)
                                                .fill(Color.clear)
                                                .frame(width: 30, height: 30)
                                            Image(systemName: "rectangle.portrait.and.arrow.right")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .foregroundStyle(Color.red)
                                                .frame(width: 20, height: 20)
                                                .padding(.leading, 5)
//                                                .fontWeight(.bold)
                                        }
                                        Text("log-out")
                                            .font(.body)
                                            .foregroundStyle(K.Colors.mainColor)
                                    }
                                }else if rowStyle == 0 {
                                    HStack(alignment: .center, spacing: 29){
                                        Image(systemName: "rectangle.portrait.and.arrow.right")
                                            .symbolRenderingMode(.palette)
                                            .foregroundStyle(Color(K.Colors.text))
                                            .font(.system(size: 29))
                                            .fontWeight(.light)
                                        Text("log-out")
                                            .fontWeight(.semibold)
                                            .font(.subheadline)
                                            .foregroundStyle(.primary)
                                        
                                        Spacer()
                                    }
                                    .padding(.leading, 5)
                                    .padding(.vertical, 3)
                                }
                            }
                            .accentColor(Color(K.Colors.text))
                        }
                        .confirmationDialog("", isPresented: $logoutAlert, titleVisibility: .hidden) {
                            Button("logout", role: .destructive) {
                                self.logoutAlert.toggle()
                                viewModel.logOut()
                                viewModel.deleteFcmToken(token: published.fcm)
                            }
                            Button("cancel", role: .cancel) {
                            }
                        }
                    }footer: {
                        if let appVersion = appVersion {
                            HStack {
                                Spacer()
                                Text("version \(appVersion) 2024 © molanter Inc")
                                Spacer()
                            }
                        }
                    }
                    .listSectionSpacing(20)
                    .listRowBackground(
                        GlassListRow()
                    )
                    if published.device != .phone {
                        Section {
                            Spacer()
                        }
                        .listRowBackground(Color.clear)
                        .frame(height: 35)
                    }
                }
                .listStyle(.insetGrouped)
                .scrollContentBackground(backgroundType == "none" ? .visible : .hidden)
                .background {
                    ListBackground()
                }

                .refreshable {
                    viewModel.fetchUser()
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
            }
//            .navigationBarTitleDisplayMode(.large)
//            .navigationTitle("settings")
            .toolbar(content: {
                ToolbarItem(placement: .topBarLeading) {
                    Menu {
                        ForEach(credentials, id: \.self) { cred in
                            if viewModel.currentUser?.username != cred.username {
                                Button {
                                    if let email = published.decrypt(cred.email), let pass = published.decrypt(cred.password) {
                                        emailToLogin = email
                                        passToLogin = pass
                                        if secure {
                                            showAskPass = true
                                        }else {
                                            loginAfterAuth()
                                        }
                                    }
                                }label: {
                                        HStack(spacing: 5) {
                                            if let data = cred.image, let img = UIImage(data: data) {
                                                Image(uiImage: img)
                                                
                                            }else {
                                                Image(systemName: "person.crop.circle.fill")
                                                    .symbolRenderingMode(.multicolor)
                                                    .foregroundStyle(.white, Color(K.Colors.lightGray))
                                            }
                                            Text(cred.username)
                                        }
                                }
                            }
                        }
                        Section {
                            Button(role: .destructive) {
                                self.logoutAlert.toggle()
                            }label: {
                                Label("logout", systemImage: "rectangle.portrait.and.arrow.right")
                            }
                            .confirmationDialog("", isPresented: $logoutAlert, titleVisibility: .hidden) {
                                Button("logout", role: .destructive) {
                                    self.logoutAlert.toggle()
                                    viewModel.logOut()
                                    viewModel.deleteFcmToken(token: published.fcm)
                                }
                                Button("cancel", role: .cancel) {
                                }
                            }
                        }
                    } label: {
                        HStack(spacing: 5) {
                            Text(viewModel.currentUser?.username ?? "reopen app")
                                .font(.system(size: 24))
                                .bold()
                            Image(systemName: "chevron.down.circle.fill")
                                .symbolRenderingMode(.hierarchical)
                        }
                        .foregroundStyle(Color(K.Colors.text))
                    }

                }
                if viewModel.currentUser?.role ?? "user" == "jedai" || email == "e.yarmolatiy@gmail.com"{
                    ToolbarItem(placement: .topBarTrailing) {
                        NavigationLink(destination: ControlVolunteer()){
                            Image(systemName: "apple.terminal")
                                .foregroundStyle(K.Colors.mainColor)
                        }
                    }
                }
                if published.device == .phone{
                    ToolbarItem(placement: .topBarTrailing, content: {
                        Button {
                            published.currentProfileMainView = 2
                        } label: {
                            Image(systemName: "bell.fill")
                                .foregroundStyle(K.Colors.mainColor)
                                .overlay(viewModel.notificationArray.isEmpty ? nil : BadgeCount(count: viewModel.notificationArray.count).padding(.trailing, 5))
                        }
                        .navigationDestination(
                            isPresented: Binding(
                                get: { published.currentProfileMainView == 2 },
                                set: { newValue in
                                    published.currentProfileMainView = newValue ? 2 : nil
                                }
                            )
                        ) {
                            NotificationsView()
                                .onAppear(perform: {
                                    published.tabsAreHidden = true
                                })
                        }
                        
                    })
                }
            })
            .frame(maxWidth: .infinity)
            .onAppear{
                viewModel.fetchUser()
                print(UUID().uuidString)
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
            .sheet(isPresented: $published.showEditProfileSheet, onDismiss: {}, content: {
                NavigationStack{
                    EditProfileView(showingEditingProfile: $published.showEditProfileSheet)
                        .toolbar(content: {
                            ToolbarItem(placement: .topBarLeading) {
                                Button(action: {self.published.showEditProfileSheet = false}){
                                    Text("cancel")
                                        .foregroundStyle(K.Colors.mainColor)
                                }
                            }
                        })
                }
            })
            .fullScreenCover(isPresented: $showAskPass, content: {
                PassOrBiometricView(
                    isPresented: $showAskPass,
                    pass: $pass,
                    wrongPass: $wrongPass,
                    appPass: appPass,
                    appPassType: appPassType,
                    width: buttonWidth,
                    addToCheckPass: addToCheckPass,
                    tryBiom: bioAuthEnabled
                )
            })
        }
        
    }
    
    func addToCheckPass(_ str: String) {
        print("cheekiing...")
        let limit = appPassType == 1 ? 4 : (appPassType == 2 ? 6 : 100)
        if limit == 100 || str == "123" {
            if pass == appPass {
                pass = ""
                wrongPass = 0
                showAskPass = false
                loginAfterAuth()
                print("here 1")
            }else {
                if wrongPass <= 9 {
                    wrongPass += 1
                    Toast.shared.present(
                        title: String(localized: "wrong-current-pass"),
                        symbol: "wrongwaysign",
                        isUserInteractionEnabled: true,
                        timing: .short
                    )
                    pass = ""
                }else {
                    if let userId = viewModel.currentUser?.uid {
                        viewModel.updateStatus(status: "block", uid: userId)
                    }
                }
            }
        }else {
            if pass.count < limit - 1 {
                pass += str
            }else if pass.count == limit - 1 {
                pass += str
                if pass == appPass {
                    print("here 2")
                    pass = ""
                    wrongPass = 0
                    showAskPass = false
                    loginAfterAuth()
                }else {
                    print(wrongPass + 1)
                    if wrongPass <= 9 {
                        wrongPass += 1
                        Toast.shared.present(
                            title: String(localized: "wrong-current-pass"),
                            symbol: "wrongwaysign",
                            isUserInteractionEnabled: true,
                            timing: .short
                        )
                        pass = ""
                    }else {
                        if let userId = viewModel.currentUser?.uid {
                            viewModel.updateStatus(status: "block", uid: userId)
                        }
                    }
                }
            }
        }
    }

    
    
    
    func loginAfterAuth() {
        viewModel.logOut()
        print("here 3")
//        DispatchQueue.main.async {
            viewModel.login(email: emailToLogin, password: passToLogin, createIcon: false, modelContext: modelContext)
            print("here 4")
            Toast.shared.present(
                title: String(localized: "logged-in"),
                symbol: "figure.walk.diamond",
                isUserInteractionEnabled: true,
                timing: .long
            )
//        }
        
        
//        if let email = self.published.decrypt(cred.email), let pass = self.published.decrypt(cred.password) {
//            viewModel.logOut()
//            DispatchQueue.main.async {
//                viewModel.login(email: email, password: pass, createIcon: false, modelContext: modelContext)
//                Toast.shared.present(
//                    title: String(localized: "logged-in"),
//                    symbol: "figure.walk.diamond",
//                    isUserInteractionEnabled: true,
//                    timing: .long
//                )
//            }
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

//#Preview {
//    SettingsView()
//}

