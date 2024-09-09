//
//  LoginPage.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 7/8/23.
//
import PhotosUI
import SwiftUI
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import AuthenticationServices
import Combine
import iPhoneNumberField
import SwiftData
import LocalAuthentication

struct LoginPage: View {
    @EnvironmentObject var viewModel: AppViewModel
//    @State private var authModel = AuthViewModel()
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var published: PublishedVariebles
    @Environment(\.modelContext) var modelContext
    
    @Query var credentials: [Credential]
    @Query var ints: [IntDataModel]
    @Query var strings: [StringDataModel]
    @Query var bools: [BoolDataModel]

    @FocusState var focus: FocusedField?

    @State var phone = ""
    @State var email = ""
    @State var createPassword = ""
    @State var repeatPassword = ""
    @State var showPassword = false
    @State var name = ""
    @State var username = ""
    @State var country = ""
    @State var showLogin = false
    @State var showRegister = false
    @State var password = ""
    @State var image: UIImage?
    @State var showImagePicker = false
    @State var maxSelection: [PhotosPickerItem] = []
    @State var sectedImages: [UIImage] = []
    @State var errReg = ""
    @State var errLog = ""
    @State private var appleIDToken: String = ""
    @State private var presentingLoginScreen = false
    @State private var presentingProfileScreen = false
    @State var showWhyAuthInfo = false
    @State var showProgressView = false
    @State var showForgot = false
    @State private var isAuthorized = false
    @State private var pass = ""
    @State private var showAskPass = false
    @State private var emailToLogin = ""
    @State private var passToLogin = ""
    @State var wrongPass = 0

    let restrictedUsernameSet = "!@#$%^&*()+?/.>,<~`±§}{[]|\"÷≥≤µ˜∫√ç≈Ω`åß∂ƒ©˙∆˚¬…æ«‘“πøˆ¨¥†®´∑œ§¡™£¢∞§¶•ªº–≠"
    let restrictedEmaileSet = "!#$%^&*()?/>,<~`±§}{[]|\"÷≥≤µ˜∫√ç≈Ω`åß∂ƒ©˙∆˚¬…æ«‘“πøˆ¨¥†®´∑œ§¡™£¢∞§¶•ªº≠"
    let maxLength = 20
    
    let width = UIScreen.screenWidth / 5

    var appPass: String {
        if let boolModel = strings.first(where: { $0.name == "appPass" }), let str = published.decrypt(boolModel.string) {
            return str
        } else {
            return ""
        }
    }
    
    var secure: Bool {
        if let boolModel = bools.first(where: { $0.name == "appSecure" }) {
            return boolModel.bool
        } else {
            return false
        }
    }
    
    var appPassType: Int {
        if let intModel = ints.first(where: { $0.name == "appPassType" }) {
            return Int(intModel.int)
        }else {
            return 1
        }
    }
    
    var backgroundType: String {
        if let strModel = strings.first(where: { $0.name == "backgroundType" }) {
            return strModel.string
        }else {
            return "none"
        }
    }
    
    var body: some View{
        ZStack(alignment: .center){
            VStack(alignment: .leading){
                Spacer()
                    .frame(maxWidth: .infinity)
                VStack(alignment: .leading, spacing: 10){
                    Text("hey-login")
                        .foregroundStyle(.primary)
                        .font(.title)
                        .fontWeight(.bold)
                    Text("welcome-to-login")
                        .foregroundStyle(.primary)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Text("app-name-login")
                        .foregroundStyle(.primary)
                        .font(.title)
                        .fontWeight(.bold)
                    HStack{
                        Text("why-authentificate")
                            .foregroundStyle(.secondary)
                            .font(.body)
                        Button(action:{
                            self.showWhyAuthInfo.toggle()
                        }){
                            Image(systemName: "info.circle")
                                .foregroundStyle(K.Colors.mainColor)
                        }
                    }
                }
                .padding(.horizontal, 15)
                VStack(alignment: .center, spacing: 15){
                    
                    
                    Button(action: {self.showLogin.toggle()}){
                        Text("log-in")
                            .foregroundStyle(Color.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                    }
                    .background(K.Colors.mainColor)
                    .cornerRadius(10)
                    Button(action: {self.showRegister.toggle()}){
                        Text("sign-up")
                            .foregroundStyle(Color.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                    }
                    .background(K.Colors.mainColor)
                    .cornerRadius(10)
                    if !credentials.isEmpty {
                        Text("or")
                            .padding(.vertical, 30)
                        if credentials.count >= 5 {
                            ScrollView(.horizontal) {
                                HStack(alignment: .center) {
                                    ForEach(credentials, id: \.self) { cred in
                                        Menu {
                                            Button(role: .destructive) {
                                                let array = credentials.filter { cr in
                                                cr.email == cred.email
                                                }
                                                for model in array {
                                                    self.modelContext.delete(model)
                                                }
                                            }label: {
                                                Label("delete", systemImage: "trash")
                                            }
                                            Button {
                                                showAskPass = true
                                                if let email = published.decrypt(cred.email), let pass = published.decrypt(cred.password) {
                                                    emailToLogin = email
                                                    passToLogin = pass
                                                }
                                            }label: {
                                                Label("sign-in", systemImage: "arrow.right")
                                            }
                                            if let email = published.decrypt(cred.email) {
                                                Text(email.lowercased())
                                            }
                                        }label: {
                                            VStack(alignment: .center, spacing: 0) {
                                                if let img = cred.image {
                                                    Image(uiImage: UIImage(data: img)!)
                                                        .resizable()
                                                        .aspectRatio(contentMode: .fill)
                                                        .frame(width: 50, height: 50)
                                                        .clipShape(.circle)
                                                }else {
                                                    Image(systemName: "person.crop.circle.fill")
                                                        .resizable()
                                                        .symbolRenderingMode(.multicolor)
                                                        .foregroundStyle(Color(K.Colors.lightGray), .white)
                                                        .aspectRatio(contentMode: .fit)
                                                        .frame(width: 50, height: 50)
                                                        .clipShape(.circle)
                                                }
                                                Text("\(cred.username.prefix(10).lowercased())\(cred.username.count > 10 ? "..." : "")")
                                                    .bold()
                                                    .foregroundStyle(Color(K.Colors.text))
                                                    .lineLimit(1)
                                                    .truncationMode(.tail)
                                                    .padding()
                                                
                                            }
                                        }
                                    }
                                }
                            }
                        }else {
                            HStack(alignment: .center) {
                                ForEach(credentials, id: \.self) { cred in
                                    Menu {
                                        Button(role: .destructive) {
                                            let array = credentials.filter { cr in
                                                cr.email == cred.email
                                            }
                                            for model in array {
                                                self.modelContext.delete(model)
                                            }
                                        }label: {
                                            Label("delete", systemImage: "trash")
                                        }
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
                                            Label("sign-in", systemImage: "arrow.right")
                                        }
                                        if let email = published.decrypt(cred.email) {
                                            Text(email.lowercased())
                                        }
                                    }label: {
                                        VStack(alignment: .center, spacing: 0) {
                                            if let img = cred.image {
                                                Image(uiImage: UIImage(data: img)!)
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fill)
                                                    .frame(width: 50, height: 50)
                                                    .clipShape(.circle)
                                            }else {
                                                Image(systemName: "person.crop.circle.fill")
                                                    .resizable()
                                                    .symbolRenderingMode(.multicolor)
                                                    .foregroundStyle(Color(K.Colors.lightGray), .white)
                                                    .aspectRatio(contentMode: .fit)
                                                    .frame(width: 50, height: 50)
                                                    .clipShape(.circle)
                                            }
                                            Text("\(cred.username.prefix(10).lowercased())\(cred.username.count > 10 ? "..." : "")")
                                                .bold()
                                                .foregroundStyle(Color(K.Colors.text))
                                                .lineLimit(1)
                                                .truncationMode(.tail)
                                                .padding()
                                            
                                        }
                                    }
                                }
                            }
                        }
                    }
                    Spacer()
                        .frame(maxWidth: .infinity)
                }
                .sheet(isPresented: $showWhyAuthInfo, content: {
                    NavigationStack{
                        WhyAuthenticateInfoView()
                            .toolbar(content: {
                                ToolbarItem(placement: .topBarTrailing) {
                                    Button(action: {
                                        self.showWhyAuthInfo = false
                                    }){
                                        Text("done")
                                            .foregroundStyle(K.Colors.mainColor)
                                    }
                                }
                            })
                    }
                })
                .padding(15)
                .sheet(isPresented: $showLogin, content: {
                    login
                })
                .sheet(isPresented: $showRegister, content: {
                    register
                })
            }
            .opacity(showProgressView ? 0.5 : 1)
            if showProgressView{
                ProgressView()
            }
        }
        .accentColor(K.Colors.mainColor)
        .modifier(DismissingKeyboard())
        .frame(minWidth: 200, idealWidth: 500, maxWidth: 700)
        .fullScreenCover(isPresented: $showAskPass, content: {
            PassOrBiometricView(
                isPresented: $showAskPass,
                pass: $pass,
                wrongPass: $wrongPass,
                appPass: appPass,
                appPassType: appPassType,
                width: width,
                addToCheckPass: addToCheckPass
            )
        })
    }
    var register: some View {
        
        NavigationStack{
            List{
                Section(header:
                            VStack(alignment: .center){
                    Text("sign-up")
                        .font(.title)
                        .fontWeight(.bold)
                    Text("sign-up-with-email")
                        .foregroundStyle(.secondary)
                        .font(.callout)
                }
                    .textCase(nil)
                    .listRowInsets(EdgeInsets())
                    .frame(maxWidth: .infinity)
                ){}
                    .listRowBackground(
                        GlassListRow()
                    )
                Section(header:
                            Button (action: {
                    showImagePicker.toggle()
                }){
                    VStack(alignment: . center){
                        if let image = self.image{
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 100, height: 100)
                                .cornerRadius(50)
                                .overlay(
                                    Circle().stroke(K.Colors.mainColor, lineWidth: 2)
                                )
                                .padding(15)
                            
                        }else{
                            Image(systemName: "person.fill.viewfinder")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 100)
                                .foregroundColor(K.Colors.mainColor)
                                .padding(15)
                                .fontWeight(.regular)
                        }
                        Text("tap-to-change-image")
                            .foregroundColor(K.Colors.mainColor)
                            .font(.callout)
                            .fontWeight(.regular)
                    }
                }
                    .textCase(nil)
                    .listRowInsets(EdgeInsets())
                    .frame(maxWidth: .infinity)
                ){}
                    .listRowBackground(
                        GlassListRow()
                    )
                Section(header: Text("full-name")){
                    HStack{
                        TextField("name", text: $name)
                            .submitLabel(.next)
                            .focused($focus, equals: .name)
                            .disableAutocorrection(true)
                            .textInputAutocapitalization(.words)
                            .textContentType(.name)
                        Spacer()
                        Image(systemName: "person")
                    }
                }
                .listRowBackground(
                    GlassListRow()
                )
                Section(header: Text("create-username")){
                    HStack{
                        TextField("username-low", text: $username)
                            .submitLabel(.next)
                            .focused($focus, equals: .username)
                            .disableAutocorrection(true)
                            .textInputAutocapitalization(.never)
                            .keyboardType(.namePhonePad)
                            .textCase(.lowercase)
                            .textContentType(.username)
                            .foregroundStyle(username == "" ? Color(K.Colors.text) : (viewModel.isAvailable ? Color( K.Colors.text) : Color(red: 1, green: 0.39, blue: 0.49)))
                        Spacer()
                        Image(systemName: "at")
                    }
                    .onReceive(Just(username)) { newText in
                        username = newText.filter { $0.isEnglishCharacter || $0.isNumber || $0.isAllowedSymbol }
                    }
                    .onChange(of: username, perform: { newValue in
                        if username != ""{
                            username = String(newValue.filter { !restrictedUsernameSet.contains($0) })
                            if username.count > maxLength {
                                username = String(newValue.prefix(maxLength))
                            }
                            viewModel.checkUsernameAvailability(username: newValue)
                        }
                    })
                }
                .listRowBackground(
                    GlassListRow()
                )
                Section(header: Text("eemail")){
                    HStack{
                        TextField(String("email@example.com"), text: $email)
                            .submitLabel(.next)
                            .focused($focus, equals: .registerEmail)
                            .textCase(.lowercase)
                            .disableAutocorrection(true)
                            .textInputAutocapitalization(.never)
                            .keyboardType(.emailAddress)
                            .textContentType(.emailAddress)
                            .onChange(of: email, perform: { newValue in
                                if email != ""{
                                    email = String(newValue.filter { !restrictedEmaileSet.contains($0) })
                                }
                            })
                        Spacer()
                        Image(systemName: "envelope")
                            .onTapGesture{
                                if !email.contains("@"){
                                    email += "@gmail.com"
                                }
                            }
                    }
                }
                .listRowBackground(
                    GlassListRow()
                )
                Section(header: Text("country")){
                    HStack{
                        TextField("country", text: $country)
                            .submitLabel(.next)
                            .focused($focus, equals: .country)
                            .disableAutocorrection(true)
                            .textInputAutocapitalization(.never)
                            .textContentType(.countryName)
                        Spacer()
                        Image(systemName: "flag")
                            .onTapGesture{
                                if let countryCode = Locale.current.region?.identifier {
                                    let country = NSLocale.current.localizedString(forRegionCode: countryCode)
                                    let i = Countries.countryList.firstIndex(of: country!) ?? 0
                                    self.country = Countries.countryList[i]
                                }
                            }
                    }
                }
                .listRowBackground(
                    GlassListRow()
                )
                Section(header: Text("pphone")){
                    HStack{
                        iPhoneNumberField(String(localized: "pphone"), text: $phone)
                            .flagHidden(false)
                            .flagSelectable(true)
                            .maximumDigits(10)
                            .prefixHidden(false)
                            .ignoresSafeArea(.keyboard, edges: .bottom)
                            .focused($focus, equals: .phone)
                            .textInputAutocapitalization(.never)
                            .disableAutocorrection(false)
                            .textContentType(.telephoneNumber)
                            .keyboardType(.numberPad)
                            .textSelection(.enabled)
                        Spacer()
                        Image(systemName: "phone")
                    }
                }
                .listRowBackground(
                    GlassListRow()
                )
                Section(header: Text("password")){
                    HStack{
                        Group{
                            if !showPassword{
                                SecureField("••••••••", text: $createPassword)
                                    .submitLabel(.next)
                                    .focused($focus, equals: .createPass)
                                    .disableAutocorrection(true)
                                    .textInputAutocapitalization(.never)
                                    .textContentType(.newPassword)
                            }else{
                                TextField("create-password", text: $createPassword)
                                    .submitLabel(.next)
                                    .foregroundColor(published.passwordSecure ? Color(K.Colors.lightGray) : Color.red)
                                    .disableAutocorrection(true)
                                    .textInputAutocapitalization(.never)
                                    .textContentType(.newPassword)
                            }
                        }
                        Spacer()
                        Image(systemName: showPassword ? "eye.slash" : "eye")
                            .symbolEffect(.bounce, value: showPassword)
                            .onTapGesture {
                                withAnimation{
                                    self.showPassword.toggle()
                                }
                            }
                    }
                    if !createPassword.isEmpty {
                        PasswordRules(pass: $createPassword)
                    }
                    HStack{
                        Group{
                            if !showPassword{
                                SecureField("••••••••", text: $repeatPassword)
                                    .submitLabel(.done)
                                    .focused($focus, equals: .repeatPass)
                                    .disableAutocorrection(true)
                                    .textInputAutocapitalization(.never)
                                    .textContentType(.newPassword)
                            }else{
                                TextField("repeat-password", text: $repeatPassword)
                                    .submitLabel(.done)
                                    .foregroundColor(Color(K.Colors.lightGray))
                                    .disableAutocorrection(true)
                                    .textInputAutocapitalization(.never)
                                    .textContentType(.newPassword)
                            }
                        }
                        Spacer()
                        Image(systemName: showPassword ? "eye.slash" : "eye")
                            .symbolEffect(.bounce, value: showPassword)
                            .onTapGesture {
                                withAnimation{
                                    self.showPassword.toggle()
                                }
                            }
                    }
                    if !createPassword.isEmpty, !repeatPassword.isEmpty {
                        Label("pass-match", systemImage: createPassword == repeatPassword ? "checkmark" : "xmark")
                            .foregroundStyle(createPassword == repeatPassword ? Color.green : Color.red)
                            .font(.caption)
                    }
                }
                .listRowBackground(
                    GlassListRow()
                )
                Section{
                    Text("sign-up")
                        .foregroundStyle(email.isEmpty && username.isEmpty && !published.passwordSecure && createPassword != repeatPassword ? Color.white : Color.black)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(!email.isEmpty && !username.isEmpty && published.passwordSecure && createPassword == repeatPassword ? K.Colors.mainColor : Color.secondary)
                        .cornerRadius(10)
                        .onTapGesture {
                            if !email.isEmpty,!username.isEmpty, published.passwordSecure, createPassword == repeatPassword {
                                registerFunc()
                            }
                        }
                        .listRowInsets(EdgeInsets())
                    Section{
                        if viewModel.err != "" {
                            Text(viewModel.err)
                                .foregroundStyle(Color(K.Colors.red))
                                .padding(.horizontal, 15)
                                .listRowBackground(Color.clear)
                                .textCase(nil)
                                .listRowInsets(EdgeInsets())
                                .frame(maxWidth: .infinity)
                            
                        }
                    }footer: {
                        HStack{
                            Spacer()
                            Text("already-acount")
                                .font(.subheadline)
                                .foregroundColor(K.Colors.mainColor)
                                .onTapGesture {
                                    self.showRegister = false
                                    self.showLogin = true
                                    viewModel.err = ""
                                }
                            Spacer()
                        }
                        .listRowBackground(Color.clear)
                        .textCase(nil)
                        .listRowInsets(EdgeInsets())
                        .frame(maxWidth: .infinity)
                    }
                }
                .listRowBackground(
                    GlassListRow()
                )
            }
            .scrollContentBackground(backgroundType == "none" ? .visible : .hidden)
            .background {
                ListBackground()
            }
            .onSubmit {
                switch focus {
                case .name:
                    focus = .username
                case .username:
                    focus = .registerEmail
                case .registerEmail:
                    focus = .country
                case .country:
                    focus = .phone
                case .phone:
                    focus = .createPass
                case .createPass:
                    focus = .repeatPass
                case .repeatPass:
                    registerFunc()
                default:
                    break
                }
            }
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(image: $image)
            }
            .onAppear(perform: {
                if let countryCode = Locale.current.region?.identifier {
                    phone = "+\(CountryCodes.countryPrefixes[countryCode] ?? "US")"
                    let country = NSLocale.current.localizedString(forRegionCode: countryCode)
                    let i = Countries.countryList.firstIndex(of: country!) ?? 0
                    self.country = Countries.countryList[i]
                }
            })
            .toolbar(content: {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {self.showRegister.toggle()}){
                        Text("cancel")
                            .foregroundStyle(K.Colors.mainColor)
                    }
                }
            })
            .background(Color(K.Colors.listBg))
            .modifier(DismissingKeyboard())
        }
        
    }
    
    private func registerFunc(){
        if createPassword == repeatPassword, viewModel.isAvailable == true, published.passwordSecure {
            viewModel.register(email: email, password: createPassword, image: image, name: name, userName: username.lowercased(), country: country, phone: phone, modelContext: modelContext)
            errReg = viewModel.err
            self.showProgressView = true
        }else if name == ""{
            //            viewModel.err = "name-field-is-empty"
            Toast.shared.present(
                title: String(localized: "name-field-is-empty"),
                symbol: "questionmark.square",
                isUserInteractionEnabled: true,
                timing: .long
            )
        }else if viewModel.isAvailable == false{
            //            viewModel.err = "username-is-not-available"
            Toast.shared.present(
                title: String(localized: "username-is-not-available"),
                symbol: "exclamationmark.circle.fill",
                isUserInteractionEnabled: true,
                timing: .long
            )
        }else if createPassword != repeatPassword{
            //            viewModel.err = "passwords-do-not-match"
            Toast.shared.present(
                title: String(localized: "passwords-do-not-match"),
                symbol: "lock.rectangle.on.rectangle",
                isUserInteractionEnabled: true,
                timing: .long
            )
        }else if !published.passwordSecure {
            Toast.shared.present(
                title: String(localized: "passwords-is-not-secure"),
                symbol: "exclamationmark.lock",
                isUserInteractionEnabled: true,
                timing: .medium
            )
        }
    }
    var login: some View {
        
        NavigationStack{
            List{
                Section(header:
                            VStack(alignment: .center){
                    Text("log-in")
                        .font(.title)
                        .fontWeight(.bold)
                    Text("sign-in-with-email")
                        .foregroundStyle(.secondary)
                }
                    .textCase(nil)
                    .listRowInsets(EdgeInsets())
                    .frame(maxWidth: .infinity)
                ){}
                    .listRowBackground(
                        GlassListRow()
                    )
                Section(header: Text("eemail")){
                    HStack{
                        TextField(String("email@example.com"), text: $email)
                            .submitLabel(.next)
                            .focused($focus, equals: .loginEmail)
                            .disableAutocorrection(true)
                            .textInputAutocapitalization(.never)
                            .keyboardType(.emailAddress)
                            .textContentType(.emailAddress)
                            .onSubmit {focus = .loginPass}
                        Spacer()
                        Image(systemName: "envelope")
                            .onTapGesture {
                                if !email.contains("@"){
                                    email += "@gmail.com"
                                }
                            }
                    }
                }
                .listRowBackground(
                    GlassListRow()
                )
                Section(header: Text("password")){
                    HStack{
                        Group{
                            if !showPassword{
                                SecureField("••••••••", text: $password)
                                    .submitLabel(.done)
                                    .focused($focus, equals: .loginPass)
                                    .disableAutocorrection(true)
                                    .textInputAutocapitalization(.never)
                                    .textContentType(.newPassword)
                            }else{
                                TextField("password", text: $password)
                                    .submitLabel(.done)
                                    .disableAutocorrection(true)
                                    .textInputAutocapitalization(.never)
                                    .textContentType(.newPassword)
                            }
                            Spacer()
                            Image(systemName: showPassword ? "eye.slash" : "eye")
                                .symbolEffect(.bounce, value: showPassword)
                                .onTapGesture {
                                    self.showPassword.toggle()
                                }
                        }
                    }
                }
                .listRowBackground(
                    GlassListRow()
                )
                Section(header:
                            HStack{
                    Spacer()
                    Text("forgot-password")
                        .font(.subheadline)
                        .foregroundStyle(K.Colors.mainColor)
                        .onTapGesture {
                            self.showForgot.toggle()
                        }
                        .navigationDestination(isPresented: $showForgot) {
                            ResetPasswordView(loginEmail: email)
                        }
                }
                    .padding(.bottom, 10)
                    .textCase(nil)
                    .listRowInsets(EdgeInsets())
                    .frame(maxWidth: .infinity)
                ){
                        Text("log-in")
                            .foregroundStyle(Color.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                    .background(email.isEmpty && password.isEmpty ? .secondary : K.Colors.mainColor)
                        .cornerRadius(10)
                        .listRowInsets(EdgeInsets())
                        .disabled(email.isEmpty && password.isEmpty)
                        .onTapGesture {
                            print("Login pressed")
                            if !email.isEmpty, !password.isEmpty {
                                viewModel.login(email: email, password: password, modelContext: modelContext)
                                errLog = viewModel.err
                                if viewModel.err == ""{
                                    self.showProgressView = true
                                }
                            }
                        }
                }
                .listRowBackground(
                    GlassListRow()
                )
                Section{
                    if viewModel.err != ""{
                        Text(viewModel.err)
                            .foregroundStyle(Color(K.Colors.pink))
                            .listRowBackground(Color.clear)
                            .textCase(nil)
                            .listRowInsets(EdgeInsets())
                            .frame(maxWidth: .infinity)
                    }
                }footer: {
                    HStack{
                        Spacer()
                        Text("do-not-have-an-account")
                            .font(.subheadline)
                            .foregroundColor(K.Colors.mainColor)
                            .onTapGesture {
                                self.showLogin = false
                                self.showRegister = true
                                viewModel.err = ""
                            }
                        Spacer()
                    }
                    .listRowInsets(EdgeInsets())
                    .listRowBackground(Color.clear)
                    .textCase(nil)
                    .listRowInsets(EdgeInsets())
                    .frame(maxWidth: .infinity)
                }
                .listRowBackground(
                    GlassListRow()
                )
            }
            .scrollContentBackground(backgroundType == "none" ? .visible : .hidden)
            .background {
                ListBackground()
            }
            .onSubmit {
                switch focus {
                case .loginEmail:
                    focus = .loginPass
                case .loginPass:
                    viewModel.login(email: email, password: password, modelContext: modelContext)
                    errLog = viewModel.err
                    if viewModel.err == ""{
                        self.showProgressView = true
                    }
                default:
                    break
                }
            }
            .toolbar(content: {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {self.showLogin.toggle()}){
                        Text("cancel")
                            .foregroundStyle(K.Colors.mainColor)
                    }
                }
            })
            .onChange(of: viewModel.err) {
                errReg = viewModel.err
                if !errLog.isEmpty || !errReg.isEmpty {
                    self.showProgressView = false
                }
            }
            .modifier(DismissingKeyboard())
        }
    }
    
    enum FocusedField:Hashable{
        case name, username, loginEmail, registerEmail, phone, country, loginPass, createPass, repeatPass
    }
    
    func addToCheckPass(_ str: String) {
        print("cheekiing...")
        let limit = appPassType == 1 ? 4 : (appPassType == 2 ? 6 : 100)
        if limit == 100 || str == "123" {
            if pass == appPass {
                print("here 2")
                pass = ""
                wrongPass = 0
                showAskPass = false
                loginAfterAuth()
            }else {
                if wrongPass <= 9 {
                    wrongPass += 1
                    Toast.shared.present(
                        title: String(localized: "wrong-current-pass"),
                        symbol: "wrongwaysign",
                        isUserInteractionEnabled: true,
                        timing: .short
                    )
                }else {
//                    if let userId = viewModel.currentUser?.uid {
//                        viewModel.updateStatus(status: "block", uid: userId)
//                    }
                }
            }
        }else {
            if pass.count < limit - 1 {
                pass += str
            }else if pass.count == limit - 1 {
                pass += str
                if pass == appPass {
                    print("here 1")
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
                    }else {
//                        if let userId = viewModel.currentUser?.uid {
//                            viewModel.updateStatus(status: "block", uid: userId)
//                        }
                    }
                }
            }
        }
    }

    
    
    
    private func loginAfterAuth() {
        print("here 3")
        viewModel.login(email: emailToLogin, password: passToLogin, createIcon: false, modelContext: modelContext)
    }
}

#Preview {
    LoginPage()
        .environmentObject(AppViewModel())
}
