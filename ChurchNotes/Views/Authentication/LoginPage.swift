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
import iPhoneNumberField
import SwiftData
import AuthenticationServices


struct LoginPage: View {
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
    @State var showResetView = false
    @State var showProgressView = false
    let restrictedUsernameSet = "!@#$%^&*()+?/.>,<~`±§}{[]|\"÷≥≤µ˜∫√ç≈Ω`åß∂ƒ©˙∆˚¬…æ«‘“πøˆ¨¥†®´∑œ§¡™£¢∞§¶•ªº–≠"
    let restrictedEmaileSet = "!#$%^&*()?/>,<~`±§}{[]|\"÷≥≤µ˜∫√ç≈Ω`åß∂ƒ©˙∆˚¬…æ«‘“πøˆ¨¥†®´∑œ§¡™£¢∞§¶•ªº≠"
    let maxLength = 20
    
    @EnvironmentObject var viewModel: AppViewModel
    @EnvironmentObject var googleModel: AuthenticationViewModel
    @StateObject private var appleModel = AuthenticationViewModel()
    @Environment(\.dismiss) var dismiss
    
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
                    Text("Hey 😃")
                        .foregroundStyle(.primary)
                        .font(.title)
                        .fontWeight(.bold)
                    Text("Welcome to")
                        .foregroundStyle(.primary)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Text("Prayer Diary 🙏🏻")
                        .foregroundStyle(.primary)
                        .font(.title)
                        .fontWeight(.bold)
                    HStack{
                        Text("Chose method of authentification")
                            .foregroundStyle(.secondary)
                            .font(.body)
                        Button(action:{
                            self.showWhyAuthInfo.toggle()
                        }){
                            Image(systemName: "info.circle")
                                .foregroundStyle(Color(K.Colors.mainColor))
                        }
                    }
                }
                .padding(.horizontal, 15)
                VStack(alignment: .center, spacing: 15){
                    
                    
                    Button(action: {self.showLogin.toggle()}){
                        Text("Log In")
                            .foregroundStyle(Color.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                    }
                    .background(Color(K.Colors.mainColor))
                    .cornerRadius(7)
                    Button(action: {self.showRegister.toggle()}){
                        Text("Sign Up")
                            .foregroundStyle(Color.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                    }
                    .background(Color(K.Colors.mainColor))
                    .cornerRadius(7)
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
                    .sheet(isPresented: $showResetView, content: {
                        NavigationStack{
                            ResetPasswordView(loginEmail: email)
                            .onDisappear(perform: {
                                self.showResetView = false
                            })
                                .toolbar(content: {
                                    ToolbarItem(placement: .topBarLeading) {
                                        Button(action: {
                                            self.showResetView = false
                                        }){
                                            Image(systemName: "xmark.circle")
                                                .foregroundStyle(Color(K.Colors.mainColor))
                                        }
                                    }
                                })
                        }
                    })
                .sheet(isPresented: $showWhyAuthInfo, content: {
                    NavigationStack{
                        WhyAuthenticateInfoView()
                            .toolbar(content: {
                                ToolbarItem(placement: .topBarTrailing) {
                                    Button(action: {
                                        self.showWhyAuthInfo = false
                                    }){
                                        Image(systemName: "xmark.circle")
                                            .foregroundStyle(Color(K.Colors.mainColor))
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
        .modifier(DismissingKeyboard())
        .frame(maxWidth: .infinity)
    }
    var register: some View {
        
        NavigationStack{
            ScrollView{
                VStack{
                    Spacer()
                    VStack(alignment: .center){
                        VStack(alignment: .center){
                            Text("Sign Up")
                                .font(.title)
                                .fontWeight(.bold)
                                .padding(.bottom, 5)
                            Text("Sign Up with email")
                                .foregroundStyle(.secondary)
                                .font(.system(size: 14))
                                .padding(.bottom, 10)
                        }
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
                                            Circle().stroke(Color(K.Colors.mainColor), lineWidth: 2)
                                        )
                                        .padding(15)
                                    
                                }else{
                                    Image(systemName: "person.fill.viewfinder")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 100)
                                        .foregroundColor(Color(K.Colors.mainColor))
                                        .padding(15)
                                        .fontWeight(.regular)
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
                                        .stroke((username == "" ? Color(K.Colors.justLightGray) : Color(viewModel.isAvailable ? K.Colors.justLightGray : K.Colors.red)).opacity(0.5), lineWidth: 1)
                                )
                                .onChange(of: username, perform: { newValue in
                                    if username != ""{
                                        username = String(newValue.filter { !restrictedUsernameSet.contains($0) })
                                        if username.count > maxLength {
                                            username = String(newValue.prefix(maxLength))
                                        }
                                        print(username)
                                        viewModel.checkUsernameAvailability(username: newValue)
                                    }
                                })
                            }
                            VStack(alignment: .leading, spacing: 20){
                                Text("Email")
                                    .fontWeight(.semibold)
                                    .font(.system(size: 15))
                                HStack(alignment: .center, spacing: 0.0){
                                    ZStack(alignment: .leading){
                                        if email.isEmpty {
                                            Text("Email")
                                                .padding(.leading)
                                                .foregroundColor(Color(K.Colors.lightGray))
                                        }
                                        TextField("", text: $email)
                                            .textCase(.lowercase)
                                            .padding(.leading)
                                            .foregroundColor(Color(K.Colors.lightGray))
                                            .disableAutocorrection(true)
                                            .textInputAutocapitalization(.never)
                                            .opacity(0.75)
                                            .padding(0)
                                            .keyboardType(.emailAddress)
                                            .textContentType(.emailAddress)
                                            .onChange(of: email, perform: { newValue in
                                                if email != ""{
                                                    email = String(newValue.filter { !restrictedEmaileSet.contains($0) })
                                                }
                                            })
                                    }
                                    Spacer()
                                    Button(action: {
                                        if !email.contains("@"){
                                            email += "@gmail.com"
                                        }
                                    }){
                                        Image(systemName: "envelope.fill")
                                            .foregroundStyle(Color(K.Colors.lightGray))
                                            .padding(.trailing)
                                    }
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
                                    Button(action: {
                                        if let countryCode = Locale.current.region?.identifier {
                                            let country = NSLocale.current.localizedString(forRegionCode: countryCode)
                                            let i = K.Countries.countryList.firstIndex(of: country!) ?? 0
                                            self.country = K.Countries.countryList[i]
                                        }
                                    }){
                                        Image(systemName: "flag.fill")
                                            .foregroundStyle(Color(K.Colors.lightGray))
                                            .padding(.trailing)
                                    }
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
                            
                            VStack(alignment: .leading, spacing: 20){
                                Text("Password")
                                    .fontWeight(.semibold)
                                    .font(.system(size: 15))
                                HStack(alignment: .center, spacing: 0.0){
                                    ZStack(alignment: .leading){
                                        if createPassword.isEmpty{
                                            Text("Create Password")
                                                .padding(.leading)
                                                .foregroundColor(Color(K.Colors.lightGray))
                                        }
                                        HStack{
                                            Group{
                                                if !showPassword{
                                                    SecureField("", text: $createPassword)
                                                        .disableAutocorrection(true)
                                                        .textInputAutocapitalization(.never)
                                                        .padding(0)
                                                        .textContentType(.newPassword)
                                                        .padding(.leading)
                                                }else{
                                                    TextField("", text: $createPassword)
                                                        .foregroundColor(Color(K.Colors.lightGray))
                                                        .disableAutocorrection(true)
                                                        .textInputAutocapitalization(.never)
                                                        .padding(0)
                                                        .textContentType(.newPassword)
                                                        .padding(.leading)
                                                }
                                            }
                                            Spacer()
                                            Button(action: {
                                                self.showPassword.toggle()
                                            }){
                                                Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
                                                    .foregroundStyle(Color(K.Colors.lightGray))
                                                    .symbolEffect(.bounce, value: showPassword)
                                                    .padding(.trailing)
                                            }
                                        }
                                    }
                                }
                                .frame(height: 50)
                                .overlay(
                                    RoundedRectangle(cornerSize: .init(width: 7, height: 7))
                                        .stroke(Color(K.Colors.justLightGray).opacity(0.5), lineWidth: 1)
                                )
                            }
                            VStack(alignment: .leading, spacing: 20){
                                HStack(alignment: .center, spacing: 0.0){
                                    ZStack(alignment: .leading){
                                        if repeatPassword.isEmpty{
                                            Text("Repeat Password")
                                                .padding(.leading)
                                                .foregroundColor(Color(K.Colors.lightGray))
                                        }
                                        HStack{
                                            Group{
                                                if !showPassword{
                                                    SecureField("", text: $repeatPassword)
                                                        .disableAutocorrection(true)
                                                        .textInputAutocapitalization(.never)
                                                        .padding(0)
                                                        .textContentType(.newPassword)
                                                        .padding(.leading)
                                                }else{
                                                    TextField("", text: $repeatPassword)
                                                        .foregroundColor(Color(K.Colors.lightGray))
                                                        .disableAutocorrection(true)
                                                        .textInputAutocapitalization(.never)
                                                        .padding(0)
                                                        .textContentType(.newPassword)
                                                        .padding(.leading)
                                                }
                                            }
                                            Spacer()
                                            Button(action: {
                                                self.showPassword.toggle()
                                            }){
                                                Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
                                                    .foregroundStyle(Color(K.Colors.lightGray))
                                                    .symbolEffect(.bounce, value: showPassword)
                                                    .padding(.trailing)
                                            }
                                        }
                                    }
                                }
                                .frame(height: 50)
                                .overlay(
                                    RoundedRectangle(cornerSize: .init(width: 7, height: 7))
                                        .stroke(Color(K.Colors.justLightGray).opacity(0.5), lineWidth: 1)
                                )
                            }
                            
                        }
                        
                        Button(action: {
                            registerFunc()
                            self.showProgressView = true
                        }){
                            Text("Sign Up")
                                .foregroundStyle(Color.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                        }
                        .background(Color(K.Colors.mainColor))
                        .cornerRadius(7)
                    }
                    .padding(.horizontal, 15)
                    
                    if errReg != ""{
                        Text(errReg)
                            .foregroundStyle(Color(K.Colors.red))
                            .padding(.horizontal, 15)
                    }
                    
                    Button(action: {
                        self.showRegister = false
                        self.showLogin = true
                    }){
                        Text("Already have an acount? - Log In")
                            .font(.system(size: 16))
                            .padding(.top, 20)
                            .foregroundColor(Color(K.Colors.mainColor))
                    }
                }
                .onAppear(perform: {
                    if let countryCode = Locale.current.region?.identifier {
                        phone = "+\(K.CountryCodes.countryPrefixes[countryCode] ?? "US")"
                        let country = NSLocale.current.localizedString(forRegionCode: countryCode)
                        let i = K.Countries.countryList.firstIndex(of: country!) ?? 0
                        self.country = K.Countries.countryList[i]
                    }
                })
            }
            .modifier(DismissingKeyboard())
            .toolbar(content: {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {self.showRegister.toggle()}){
                        Text("Cancel")
                            .foregroundStyle(Color(K.Colors.mainColor))
                    }
                }
            })
        }
    }
    
    private func registerFunc(){
        if createPassword == repeatPassword && viewModel.isAvailable == true{
            viewModel.register(email: email, password: createPassword, image: image, name: name, userName: username.lowercased(), country: country, phone: phone)
            errReg = viewModel.err
        }else if name == ""{
            errReg = "Name field is empty, enter your name."
        }else if viewModel.isAvailable == false{
            errReg = "Username is not available, create another one."
        }else if createPassword != repeatPassword{
            errReg = "Passwords do not match."
        }
    }
    var login: some View {
        
        NavigationStack{
            ScrollView{
                VStack{
                    Spacer()
                    VStack(alignment: .center){
                        Text("Log In")
                            .font(.title)
                            .fontWeight(.bold)
                            .padding(.bottom, 5)
                        Text("Sign In with email")
                            .foregroundStyle(.secondary)
                            .padding(.bottom, 40)
                        HStack(alignment: .center, spacing: 0.0){
                            
                            ZStack(alignment: .leading){
                                if email.isEmpty {
                                    Text("Email")
                                        .padding(.leading)
                                        .foregroundColor(Color(K.Colors.lightGray))
                                }
                                TextField("", text: $email)
                                    .padding(.leading)
                                    .foregroundColor(Color(K.Colors.lightGray))
                                    .disableAutocorrection(true)
                                    .textInputAutocapitalization(.never)
                                    .opacity(0.75)
                                    .padding(0)
                                    .keyboardType(.emailAddress)
                                    .textContentType(.emailAddress)
                            }
                            .frame(height: 45)
                            Spacer()
                            Button(action: {
                                if !email.contains("@"){
                                    email += "@gmail.com"
                                }
                            }){
                                Image(systemName: "envelope.fill")
                                    .foregroundStyle(Color(K.Colors.lightGray))
                                    .padding(.trailing)
                            }
                        }
                        .overlay(
                            RoundedRectangle(cornerSize: .init(width: 7, height: 7))
                                .stroke(Color(K.Colors.justLightGray).opacity(0.5), lineWidth: 1)
                        )
                        HStack(alignment: .center, spacing: 0.0){
                            ZStack(alignment: .leading){
                                if password.isEmpty{
                                    Text("Password")
                                        .padding(.leading)
                                        .foregroundColor(Color(K.Colors.lightGray))
                                }
                                HStack{
                                    Group{
                                        if !showPassword{
                                            SecureField("", text: $password)
                                                .foregroundColor(Color(K.Colors.lightGray))
                                                .disableAutocorrection(true)
                                                .textInputAutocapitalization(.never)
                                                .padding(0)
                                                .textContentType(.newPassword)
                                                .padding(.leading)
                                        }else{
                                            TextField("", text: $password)
                                                .foregroundColor(Color(K.Colors.lightGray))
                                                .disableAutocorrection(true)
                                                .textInputAutocapitalization(.never)
                                                .padding(0)
                                                .textContentType(.newPassword)
                                                .padding(.leading)
                                        }
                                    }
                                    .frame(height: 45)
                                    Spacer()
                                    Button(action: {
                                        self.showPassword.toggle()
                                    }){
                                        Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
                                            .foregroundStyle(Color(K.Colors.lightGray))
                                        //                                        .contentTransition(.symbolEffect(.replace))
                                            .symbolEffect(.bounce, value: showPassword)
                                            .padding(.trailing)
                                    }
                                }
                            }
                        }
                        .overlay(
                            RoundedRectangle(cornerSize: .init(width: 7, height: 7))
                                .stroke(Color(K.Colors.justLightGray).opacity(0.5), lineWidth: 1)
                        )
                        HStack{
                            Spacer()
                            Button(action: {
                                self.showRegister = false
                                self.showLogin = false
                                self.showResetView = true
                            }){
                                Text("Forgot password?")
                                    .padding(.vertical, 5)
                                    .font(.system(size: 14))
                                    .foregroundColor(Color(K.Colors.mainColor))
                            }
                        }
                        Button(action: {
                            if email != "" && password != ""{
                                viewModel.login(email: email, password: password)
                                errLog = viewModel.err
                                self.showProgressView = true
                            }else{
                                email = "12@2.com"
                                password = "123456"
                            }
                        }){
                            Text("Log In")
                                .foregroundStyle(Color.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                        }
                        .background(Color(K.Colors.mainColor))
                        .cornerRadius(7)
                        .padding(.vertical)
                    }
                    .padding(.horizontal, 15)
                    if errLog != ""{
                        Text(errLog)
                            .foregroundStyle(Color(K.Colors.pink))
                            .padding(.horizontal, 15)
                    }
                    Spacer()
                    //
                    Button(action: {
                        self.showLogin = false
                        self.showRegister = true
                    }){
                        Text("Don't have an acount? - Rerister")
                            .font(.system(size: 16))
                            .padding(.top, 20)
                            .foregroundColor(Color(K.Colors.mainColor))
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .modifier(DismissingKeyboard())
            .toolbar(content: {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {self.showLogin.toggle()}){
                        Text("Cancel")
                            .foregroundStyle(Color(K.Colors.mainColor))
                    }
                }
            })
            .onChange(of: viewModel.err) {
                errReg = viewModel.err
            }
        }
    }
    
    
}

#Preview {
    LoginPage()
        .environmentObject(AppViewModel())
}