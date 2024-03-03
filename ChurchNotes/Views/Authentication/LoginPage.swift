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


struct LoginPage: View {
    @EnvironmentObject var viewModel: AppViewModel
    @EnvironmentObject var googleModel: AuthenticationViewModel
    @StateObject private var appleModel = AuthenticationViewModel()
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var published: PublishedVariebles
    
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
    
    let restrictedUsernameSet = "!@#$%^&*()+?/.>,<~`±§}{[]|\"÷≥≤µ˜∫√ç≈Ω`åß∂ƒ©˙∆˚¬…æ«‘“πøˆ¨¥†®´∑œ§¡™£¢∞§¶•ªº–≠"
    let restrictedEmaileSet = "!#$%^&*()?/>,<~`±§}{[]|\"÷≥≤µ˜∫√ç≈Ω`åß∂ƒ©˙∆˚¬…æ«‘“πøˆ¨¥†®´∑œ§¡™£¢∞§¶•ªº≠"
    let maxLength = 20
    
    private func signInWithEmailPassword() {
        Task {
            if await googleModel.signInWithEmailPassword() == true {
                dismiss()
            }
        }
    }
    
    private func signInWithGoogle() {
        Task {
            if await googleModel.signInWithGoogle() == true {
                dismiss()
            }
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
                    //                Text("or")
                    //                    .padding(.vertical, 30)
                    //
                    //                VStack(spacing: 15){
                    //                    Button(action:{
                    //
                    //                    }){
                    //                        ZStack{
                    //                            RoundedRectangle(cornerRadius: 7)
                    //                                .frame(maxWidth: .infinity)
                    //                                .foregroundStyle(Color(K.Colors.darkBlue))
                    //                            HStack{
                    //                                Image(systemName: "envelope")
                    //                                    .resizable()
                    //                                    .aspectRatio(contentMode: .fit)
                    //                                    .frame(width: 28)
                    //                                    .foregroundStyle(Color.white)
                    //                                    .padding()
                    //                                Rectangle()
                    //                                    .frame(width: 1, height: 30)
                    //                                    .foregroundStyle(Color.white)
                    //                                Spacer()
                    //                            }
                    //                            Text("Sign with Email Link")
                    //                                .foregroundStyle(Color.white)
                    //                                .padding()
                    //                                .font(.system(size: 18))
                    //                        }
                    //                        .frame(height: 50)
                    //                    }
                    //                    VStack(spacing: 15){
                    //                        Button(action:{
                    //                            appleModel.reset()
                    //                            presentingLoginScreen.toggle()
                    //                        }){
                    //                            ZStack{
                    //                                RoundedRectangle(cornerRadius: 7)
                    //                                    .frame(maxWidth: .infinity)
                    //                                    .foregroundStyle(Color.black)
                    //                                HStack{
                    //                                    Image(systemName: "apple.logo")
                    //                                        .resizable()
                    //                                        .aspectRatio(contentMode: .fit)
                    //                                        .frame(width: 28)
                    //                                        .foregroundStyle(Color.white)
                    //                                        .padding()
                    //                                    Rectangle()
                    //                                        .frame(width: 1, height: 30)
                    //                                        .foregroundStyle(Color.white)
                    //                                    Spacer()
                    //                                }
                    //                                Text("Sign In with Apple")
                    //                                    .foregroundStyle(Color.white)
                    //                                    .padding()
                    //                                    .font(.system(size: 18))
                    //                            }
                    //                            .frame(height: 50)
                    //                        }
                    //
                    //
                    //                        SignInWithAppleButton(
                    //                                        onRequest: { request in
                    //                                            request.requestedScopes = [.fullName, .email]
                    //                                        },
                    //                                        onCompletion: { result in
                    //                                            switch result {
                    //                                            case .success(let authResults):
                    //                                                if let credential = authResults.credential as? ASAuthorizationAppleIDCredential {
                    //                                                    if let appleIDTokenData = credential.identityToken, let appleIDTokenString = String(data: appleIDTokenData, encoding: .utf8) {
                    //                                                        // Retrieve the Apple ID token and set it to the state variable
                    //                                                        appleIDToken = appleIDTokenString
                    //
                    //                                                        // Sign in with Firebase using the Apple ID token.
                    //                                                        let firebaseCredential = OAuthProvider.credential(withProviderID: "apple.com", idToken: appleIDTokenString)
                    //
                    //                                                        Auth.auth().signIn(with: firebaseCredential) { authResult, error in
                    //                                                            if let error = error {
                    //                                                                print("Error signing in with Apple: \(error.localizedDescription)")
                    //                                                            } else {
                    //                                                                // Handle successful sign-in.
                    //                                                                print("Successfully signed in with Apple.")
                    //                                                            }
                    //                                                        }
                    //                                                    } else {
                    //                                                        // Handle other cases if needed.
                    //                                                    }
                    //                                                } else {
                    //                                                    // Handle other cases if needed.
                    //                                                }
                    //                                            case .failure(let error):
                    //                                                // Handle the failure case.
                    //                                                print("Failed to sign in with Apple: \(error.localizedDescription)")
                    //                                            }
                    //                                        }
                    //                                    )
                    //
                    //
                    //
                    //                        Button(action:{
                    //                            signInWithGoogle()
                    //                        }){
                    //                            ZStack{
                    //                                RoundedRectangle(cornerRadius: 7)
                    //                                    .frame(maxWidth: .infinity)
                    //                                    .foregroundStyle(Color(K.Colors.justLightGray))
                    //                                HStack{
                    //                                    Image("google-icon")
                    //                                        .resizable()
                    //                                        .aspectRatio(contentMode: .fit)
                    //                                        .frame(height: 25)
                    //                                        .foregroundStyle(Color(K.Colors.justDarkGray))
                    //                                        .padding()
                    //                                    Rectangle()
                    //                                        .frame(width: 1, height: 30)
                    //                                        .foregroundStyle(Color(K.Colors.justDarkGray))
                    //                                    Spacer()
                    //                                }
                    //                                Text("Sign In with Google")
                    //                                    .foregroundStyle(Color(K.Colors.justDarkGray))
                    //                                    .padding()
                    //                                    .font(.system(size: 18))
                    //                            }
                    //                            .frame(height: 50)
                    //                        }
                    //                    }
                    Spacer()
                        .frame(maxWidth: .infinity)
                    //                }
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
        .frame(maxWidth: .infinity)
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
                                    let i = K.Countries.countryList.firstIndex(of: country!) ?? 0
                                    self.country = K.Countries.countryList[i]
                                }
                            }
                    }
                }
                Section(header: Text("pphone")){
                    HStack{
                        TextField("pphone", text: $phone)
                            .submitLabel(.next)
                            .focused($focus, equals: .phone)
                            .textInputAutocapitalization(.never)
                            .disableAutocorrection(true)
                            .textContentType(.telephoneNumber)
                            .keyboardType(.numberPad)
                        Spacer()
                        Image(systemName: "phone")
                    }
                }
                Section(header: Text("password")){
                    HStack{
                        Group{
                            if !showPassword{
                                SecureField("∙∙∙∙∙∙∙∙", text: $createPassword)
                                    .submitLabel(.next)
                                    .focused($focus, equals: .createPass)
                                    .disableAutocorrection(true)
                                    .textInputAutocapitalization(.never)
                                    .textContentType(.newPassword)
                            }else{
                                TextField("create-password", text: $createPassword)
                                    .submitLabel(.next)
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
                    HStack{
                        Group{
                            if !showPassword{
                                SecureField("∙∙∙∙∙∙∙∙", text: $repeatPassword)
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
                }
                Section{
                    Text("sign-up")
                        .foregroundStyle(Color.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(K.Colors.mainColor)
                        .cornerRadius(10)
                        .onTapGesture {
                            registerFunc()
                        }
                        .listRowInsets(EdgeInsets())
                    Section{
                        if viewModel.err != ""{
                            Text(viewModel.err)
                                .foregroundStyle(Color(K.Colors.red))
                                .padding(.horizontal, 15)
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
                        .listRowInsets(EdgeInsets())
                        .listRowBackground(Color.clear)
                        .textCase(nil)
                        .listRowInsets(EdgeInsets())
                        .frame(maxWidth: .infinity)
                    }
                }
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
                    phone = "+\(K.CountryCodes.countryPrefixes[countryCode] ?? "US")"
                    let country = NSLocale.current.localizedString(forRegionCode: countryCode)
                    let i = K.Countries.countryList.firstIndex(of: country!) ?? 0
                    self.country = K.Countries.countryList[i]
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
        if createPassword == repeatPassword && viewModel.isAvailable == true{
            viewModel.register(email: email, password: createPassword, image: image, name: name, userName: username.lowercased(), country: country, phone: phone)
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
                Section(header: Text("password")){
                    HStack{
                        Group{
                            if !showPassword{
                                SecureField("∙∙∙∙∙∙∙∙", text: $password)
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
                Section(header:
                            HStack{
                                Spacer()
                                    Text("forgot-password")
                                        .font(.subheadline)
                                        .foregroundStyle(K.Colors.mainColor)
                                        .onTapGesture {
                                            self.showForgot.toggle()
                                        }
                            }
                    .padding(.bottom, 10)
                            .navigationDestination(isPresented: $showForgot) {
                                ResetPasswordView(loginEmail: email)
                            }
                    .textCase(nil)
                    .listRowInsets(EdgeInsets())
                    .frame(maxWidth: .infinity)
                ){
                    Text("log-in")
                        .foregroundStyle(Color.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(K.Colors.mainColor)
                        .cornerRadius(10)
                        .onTapGesture {
                            viewModel.login(email: email, password: password)
                            errLog = viewModel.err
                            if viewModel.err == ""{
                                self.showProgressView = true
                            }
                        }
                        .listRowInsets(EdgeInsets())
                }
                Section{
                    if viewModel.err != ""{
                        Text(viewModel.err)
                            .foregroundStyle(Color(K.Colors.pink))
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
            }
            .onSubmit {
                switch focus {
                case .loginEmail:
                    focus = .loginPass
                case .loginPass:
                    viewModel.login(email: email, password: password)
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
            }
            .modifier(DismissingKeyboard())
        }
    }
    
    
    
    enum FocusedField:Hashable{
        case name, username, loginEmail, registerEmail, phone, country, loginPass, createPass, repeatPass
    }
}

#Preview {
    LoginPage()
        .environmentObject(AppViewModel())
}
