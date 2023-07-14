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
import FirebaseDatabase
import iPhoneNumberField

class AppViewModel: ObservableObject{
    var ref: DatabaseReference! = Database.database().reference()
    var db = Firestore.firestore()
    var err = ""
    
    func passSecure(password: String) -> Color{
        var passColor: Color = Color(K.Colors.gray)
        var bigLatter = false
        var smalLatter = false
        var symbol = false
        var numberPass = false
        var passCount = false
        var passwordSecure = 0
        for character in password{
            if "ABCDEFGHIJKLMNOPQRSTUVWXYZ".contains(character){
                bigLatter = true
            }
            if "abcdefghijklmnopqrstuvwxyz".contains(character){
                smalLatter = true
                
            }
            if "!@#$%^&*_-+=§±`~'.,".contains(character){
                symbol = true
                
            }
            if "0123456789".contains(character){
                numberPass = true
                
            }
            if password.count > 7{
                passCount = true
                
            }
        }
        if bigLatter == true{passwordSecure += 1}
        if smalLatter == true{passwordSecure += 1}
        if symbol == true{passwordSecure += 1}
        if numberPass == true{passwordSecure += 1}
        if passCount == true{passwordSecure += 1}
        
        switch passwordSecure{
        case ...0:
            passColor = Color(K.Colors.gray)
        case 1:
            passColor = Color(K.Colors.red)
        case 2:
            passColor = Color.orange
        case 3:
            passColor = Color(K.Colors.yellow)
        case 4:
            passColor = Color(K.Colors.blue)
        case 5...:
            passColor = Color(K.Colors.green)
        default:
            passColor = Color(K.Colors.gray)
        }
        print(passwordSecure)
        return passColor
    }
    
    func login(email: String, password: String){
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            if error != nil {
                self?.err = error!.localizedDescription
            }else{
                
                print("User logined succesfuly!")
            }
        }
    }
    
    func register(email: String, password: String){
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            if error != nil{
                self?.err = error!.localizedDescription
            }else{
                print("User created succesfuly!")
            }
        }
    }
}

struct LoginPage: View {
    @State var phone = ""
    @State var email = ""
    @State var createPassword = ""
    @State var repeatPassword = ""
    @State var showPassword = false
    @State var name = ""
    @State var country = ""
    @State var showLogin = false
    @State var showRegister = false
    @State var password = ""
    @State var image: UIImage?
    @State var showImagePicker = false
    @State var maxSelection: [PhotosPickerItem] = []
    @State var sectedImages: [UIImage] = []
    @EnvironmentObject var viewModel: AppViewModel
    
    var body: some View{
        register
        //        VStack(alignment: .leading, spacing: 10){
        //            Spacer()
        //                .frame(maxWidth: .infinity)
        //            Text("Welcome to")
        //                .foregroundStyle(.primary)
        //                .font(.largeTitle)
        //                .fontWeight(.bold)
        //            Text("Our App")
        //                .foregroundStyle(.primary)
        //                .font(.title)
        //                .fontWeight(.bold)
        //            Text("Chose method of authentification")
        //                .foregroundStyle(.secondary)
        //                .font(.body)
        //        }
        //        .padding(.horizontal, 15)
        //        .frame(maxWidth: .infinity)
        //        VStack(alignment: .center, spacing: 15){
        //
        //
        //            Button(action: {self.showLogin.toggle()}){
        //                Text("Log In")
        //                    .foregroundStyle(Color.white)
        //                    .padding()
        //            }
        //            .frame(maxWidth: .infinity)
        //            .background(Color(K.Colors.bluePurple))
        //            .cornerRadius(7)
        //            Button(action: {self.showRegister.toggle()}){
        //                Text("Sign Up")
        //                    .foregroundStyle(Color.white)
        //                    .padding()
        //            }
        //            .frame(maxWidth: .infinity)
        //            .background(Color(K.Colors.bluePurple))
        //            .cornerRadius(7)
        //            Text("or")
        //                .padding(.vertical, 30)
        //
        //            HStack(spacing: 20){
        //                Button(action:{
        //
        //                }){
        //                    ZStack{
        //                        Circle()
        //                            .frame(width: 55)
        //                            .foregroundColor(Color(K.Colors.darkGray))
        //                        Image(systemName: "envelope")
        //                            .resizable()
        //                            .aspectRatio(contentMode: .fit)
        //                            .frame(width: 30)
        //                            .foregroundColor(Color(K.Colors.lightGray))
        //                            .padding()
        //                            .cornerRadius(.infinity)
        //                    }
        //                }
        //                Button(action:{
        //
        //                }){
        //                    ZStack{
        //                        Circle()
        //                            .frame(width: 55)
        //                            .foregroundColor(.black)
        //                        Image(systemName: "apple.logo")
        //                            .resizable()
        //                            .aspectRatio(contentMode: .fit)
        //                            .frame(width: 25)
        //                            .foregroundColor(.white)
        //                            .padding()
        //                            .cornerRadius(.infinity)
        //                    }
        //                }
        //                .disabled(true)
        //                Button(action:{
        //
        //                }){
        //                    ZStack{
        //                        Circle()
        //                            .frame(width: 55)
        //                            .foregroundColor(Color(K.Colors.darkGray))
        //                        Image(systemName: "iphone.gen3")
        //                            .resizable()
        //                            .aspectRatio(contentMode: .fit)
        //                            .frame(width: 20)
        //                            .foregroundColor(Color(K.Colors.lightGray))
        //                            .padding()
        //                            .cornerRadius(.infinity)
        //                    }
        //                }
        //                .disabled(true)
        //            }
        //        }
        //        .frame(maxWidth: .infinity)
        //        .padding(15)
        //        .sheet(isPresented: $showLogin, content: {
        //            login
        //        })
        //        .sheet(isPresented: $showRegister, content: {
        //            register
        //        })
    }
    var register: some View {
        
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
                            .padding(.bottom, 10)
                    }
                    PhotosPicker(selection: $maxSelection, maxSelectionCount: 1, matching: .any(of: [.images, .not(.videos)])){
                        VStack(alignment: . center){
                            if let image = self.image{
                                Image(uiImage: image)
                                    .resizable()
                                    .frame(width: 150, height: 150)
                                    .cornerRadius(75)
                                    .overlay(
                                        Circle().stroke(Color(K.Colors.bluePurple), lineWidth: 5)
                                    )
                                    .padding(15)
                                
                            }else{
                                Image(systemName: "person.fill.viewfinder")
                                    .resizable()
                                    .frame(width: 150, height: 150)
                                    .foregroundColor(Color(K.Colors.bluePurple))
                                    .padding(15)
                                
                                
                            }
                            Text("tap to change Image")
                                .foregroundColor(Color(K.Colors.bluePurple))
                                .font(.body)
                                .fontWeight(.medium)
                        }
                    }
                    .onChange(of: maxSelection){ newValue in
                        Task{
                            for value in newValue {
                                if let imageData = try? await
                                    value.loadTransferable(type: Data.self), let image = UIImage(data: imageData) {
                                    self.image = image
                                }
                            }
                        }
                    }
                        .padding(.bottom, 30)
                        VStack(alignment: .leading, spacing: 20){
                            VStack(alignment: .leading){
                                Text("Full Name")
                                    .fontWeight(.medium)
                                    .font(.system(size: 18))
                                    .foregroundStyle(.primary)
                                HStack(alignment: .center, spacing: 0.0){
                                    ZStack(alignment: .leading){
                                        if name.isEmpty {
                                            Text("Name")
                                                .padding(.leading)
                                                .foregroundColor(Color(K.Colors.lightGray))
                                        }
                                        TextField("", text: $name)
                                            .padding(.leading)
                                            .foregroundColor(Color(K.Colors.lightGray))
                                            .disableAutocorrection(true)
                                            .textInputAutocapitalization(.never)
                                            .opacity(0.75)
                                            .padding(0)
                                            .keyboardType(.namePhonePad)
                                            .textContentType(.name)
                                    }
                                    .frame(height: 45)
                                    Spacer()
                                    Image(systemName: "person.fill")
                                        .foregroundStyle(Color(K.Colors.lightGray))
                                        .padding(.trailing)
                                }
                                .overlay(
                                    RoundedRectangle(cornerSize: .init(width: 7, height: 7))
                                        .stroke(Color(K.Colors.justLightGray).opacity(0.5), lineWidth: 1)
                                    //                            .shadow(color: Color(K.Colors.lightGray), radius: 4, x: 0, y: 8)
                                )
                            }
                            VStack(alignment: .leading){
                                Text("Email")
                                    .fontWeight(.medium)
                                    .font(.system(size: 18))
                                    .foregroundStyle(.primary)
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
                                        }else if !email.contains("@."){
                                            email += ".com"
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
                                    //                            .shadow(color: Color(K.Colors.lightGray), radius: 4, x: 0, y: 8)
                                )
                            }
                            VStack(alignment: .leading){
                                Text("Country")
                                    .fontWeight(.medium)
                                    .font(.system(size: 18))
                                    .foregroundStyle(.primary)
                                HStack(alignment: .center, spacing: 0.0){
                                    ZStack(alignment: .leading){
                                        if country.isEmpty {
                                            Text("Country")
                                                .padding(.leading)
                                                .foregroundColor(Color(K.Colors.lightGray))
                                        }
                                        TextField("", text: $country)
                                            .padding(.leading)
                                            .foregroundColor(Color(K.Colors.lightGray))
                                            .disableAutocorrection(true)
                                            .textInputAutocapitalization(.never)
                                            .opacity(0.75)
                                            .padding(0)
                                            .textContentType(.countryName)
                                    }
                                    .frame(height: 45)
                                    Spacer()
                                    Image(systemName: "flag.fill")
                                        .foregroundStyle(Color(K.Colors.lightGray))
                                        .padding(.trailing)
                                }
                                .overlay(
                                    RoundedRectangle(cornerSize: .init(width: 7, height: 7))
                                        .stroke(Color(K.Colors.justLightGray).opacity(0.5), lineWidth: 1)
                                    //                            .shadow(color: Color(K.Colors.lightGray), radius: 4, x: 0, y: 8)
                                )
                            }
                            VStack(alignment: .leading){
                                Text("Phone")
                                    .fontWeight(.medium)
                                    .font(.system(size: 18))
                                    .foregroundStyle(.primary)
                                HStack(alignment: .center, spacing: 0.0){
                                    ZStack(alignment: .leading){
                                        iPhoneNumberField("Phone Number", text: $phone)
                                            .maximumDigits(15)
                                            .prefixHidden(false)
                                            .flagHidden(false)
                                            .flagSelectable(true)
                                            .placeholderColor(Color(K.Colors.lightGray))
                                            .foregroundColor(Color(K.Colors.lightGray)).frame(height: 45).disableAutocorrection(true).fontDesign(.monospaced).textInputAutocapitalization(.never).padding(0)
                                            .textContentType(.telephoneNumber)
                                        
                                        
                                    }
                                    .padding(.leading)
                                    .frame(height: 45)
                                    Spacer()
                                    Image(systemName: "phone.fill")
                                        .foregroundStyle(Color(K.Colors.lightGray))
                                        .padding(.trailing)
                                }
                                .overlay(
                                    RoundedRectangle(cornerSize: .init(width: 7, height: 7))
                                        .stroke(Color(K.Colors.justLightGray).opacity(0.5), lineWidth: 1)
                                    //                            .shadow(color: Color(K.Colors.lightGray), radius: 4, x: 0, y: 8)
                                )
                            }
                            
                            VStack(alignment: .leading){
                                Text("Password")
                                    .fontWeight(.medium)
                                    .font(.system(size: 18))
                                    .foregroundStyle(.primary)
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
                                                        .foregroundColor(Color(K.Colors.lightGray))
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
                                    //                            .shadow(color: Color(K.Colors.lightGray), radius: 4, x: 0, y: 8)
                                )
                            }
                            VStack(alignment: .leading){
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
                                                        .foregroundColor(Color(K.Colors.lightGray))
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
                                    //                            .shadow(color: Color(K.Colors.lightGray), radius: 4, x: 0, y: 8)
                                    
                                )
                            }
                            
                        }
                        
                        Button(action: {
                            if createPassword == repeatPassword{
                                viewModel.register(email: email, password: createPassword)
                            }
                        }){
                            Text("Sign Up")
                                .foregroundStyle(Color.white)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(K.Colors.bluePurple))
                        .cornerRadius(7)
                        .padding(.vertical)
                    }
                        .padding(.top, 30)
                        .padding(.horizontal, 15)
                              
                              Text(viewModel.err)
                        .foregroundStyle(Color(K.Colors.pink))
                        .padding(.horizontal, 15)
                              
                              Button(action: {
                        
                    }){
                        Text("Already have acount? Log In")
                            .font(.system(size: 16))
                            .padding(.top, 20)
                            .foregroundColor(Color(K.Colors.bluePurple))
                    }
                              }
                        .onAppear(perform: {
                            let countryCode = Locale.current.regionCode
                            phone = "+\(K.CountryCodes.countryPrefixes[countryCode!] ?? "US")"
                        })
                              }
                            .background(Color.white)
                              }
                              
                              
                              var login: some View {
                        
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
                                            }else if !email.contains("@."){
                                                email += ".com"
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
                                            if createPassword.isEmpty{
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
                                        Button(action: {}){
                                            Text("Forgot password?")
                                                .padding(.vertical, 5)
                                                .font(.system(size: 14))
                                                .foregroundColor(Color(K.Colors.bluePurple))
                                        }
                                    }
                                    Button(action: {
                                        viewModel.login(email: email, password: password)
                                    }){
                                        Text("Log In")
                                            .foregroundStyle(Color.white)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color(K.Colors.bluePurple))
                                    .cornerRadius(7)
                                    .padding(.vertical)
                                }
                                .padding(.top, 30)
                                .padding(.horizontal, 15)
                                Text(viewModel.err)
                                    .foregroundStyle(Color(K.Colors.pink))
                                    .padding(.horizontal, 15)
                                Spacer()
                                //
                                Button(action: {
                                    
                                }){
                                    Text("Does't have acount? Rerister")
                                        .font(.system(size: 16))
                                        .padding(.top, 20)
                                        .foregroundColor(Color(K.Colors.bluePurple))
                                }
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                        .background(Color.white)
                        
                    }
                              }
                              
                              #Preview {
                        LoginPage()
                            .environmentObject(AppViewModel())
                    }
