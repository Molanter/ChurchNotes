//
//  EditProfileView.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 10/23/23.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import Combine

struct EditProfileView: View {
    @FocusState var focus: FocusedField?

    @State var name = ""
    @State var phone = ""
    @State var email = ""
    @Binding var showingEditingProfile: Bool
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
    @State var firebaseError = false
    @State var firebaseErr = ""
    
    let restrictedUsernameSet = "!@#$%^&*()+?/.>,<~`±§}{[]|\"÷≥≤µ˜∫√ç≈Ω`åß∂ƒ©˙∆˚¬…æ«‘“πøˆ¨¥†®´∑œ§¡™£¢∞§¶•ªº–≠"
    let restrictedEmaileSet = "!@#$%^&*()+?/.>,<~`±§}{[]|\"÷≥≤µ˜∫√ç≈Ω`åß∂ƒ©˙∆˚¬…æ«‘“πøˆ¨¥†®´∑œ§¡™£¢∞§¶•ªº–≠"
    let maxLength = 20
    
    var db = Firestore.firestore()
    var auth = Auth.auth()
    
    @EnvironmentObject var viewModel: AppViewModel
    
    var body: some View {
        NavigationStack{
            ZStack(alignment: email == "" ? .center : .top){
                ScrollView{
                    Spacer()
                    VStack(alignment: .center){
                        VStack(alignment: .center){
                            Text("editing-profile")
                                .font(.title)
                                .fontWeight(.bold)
                                .padding(.bottom, 5)
                            Text("'\(email)'")
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
                                Text("tap-to-change-image")
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
                                Text("full-name")
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
                                            .ignoresSafeArea(.keyboard, edges: .bottom)
                                            .focused($focus, equals: .name)
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
                                Text("username")
                                    .fontWeight(.semibold)
                                    .font(.system(size: 15))
                                HStack(alignment: .center, spacing: 0.0){
                                    ZStack(alignment: .leading){
                                        if username.isEmpty {
                                            Text("username")
                                                .padding(.leading)
                                                .foregroundColor(Color(K.Colors.lightGray))
                                        }
                                        TextField("", text: $username)
                                            .ignoresSafeArea(.keyboard, edges: .bottom)
                                            .focused($focus, equals: .username)
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
                            VStack(alignment: .leading, spacing: 20){
                                Text("country")
                                    .fontWeight(.semibold)
                                    .font(.system(size: 15))
                                HStack(alignment: .center, spacing: 0.0){
                                    ZStack(alignment: .leading){
                                        if country.isEmpty {
                                            Text("country")
                                                .padding(.leading)
                                                .foregroundColor(Color(K.Colors.lightGray))
                                        }
                                        TextField("", text: $country)
                                            .ignoresSafeArea(.keyboard, edges: .bottom)
                                            .focused($focus, equals: .country)
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
                                Text("pphone")
                                    .fontWeight(.semibold)
                                    .font(.system(size: 15))
                                HStack(alignment: .center, spacing: 0.0){
                                    ZStack(alignment: .leading){
                                        if phone.isEmpty {
                                            Text("pphone")
                                                .padding(.leading)
                                                .foregroundColor(Color(K.Colors.lightGray))
                                        }
                                    TextField("pphone", text: $phone)
                                        .ignoresSafeArea(.keyboard, edges: .bottom)
                                        .padding(.leading)
                                        .focused($focus, equals: .phone)
                                        .textInputAutocapitalization(.never)
                                        .disableAutocorrection(true)
                                        .textContentType(.telephoneNumber)
                                        .keyboardType(.numberPad)
                                }
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
                        .onSubmit {
                                    switch focus {
                                    case .name:
                                        focus = .username
                                    case .username:
                                        focus = .country
                                    case .country:
                                        focus = .phone
                                    case .phone:
                                        updateFunc()
                                    default:
                                        break
                                    }
                                }
                        Button(action: {updateFunc()}){
                            Text("save")
                                .foregroundStyle(Color.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color(K.Colors.mainColor))
                                .cornerRadius(7)
                                .padding(.vertical)
                        }
                    }
                    .padding(.horizontal, 15)
                    
                    if errReg != ""{
                        Text(errReg)
                            .foregroundStyle(Color(K.Colors.pink))
                            .padding(.horizontal, 15)
                    }
                }
                .opacity(email == "" ? 0.5 : 1)
                if firebaseError{
                    HStack(alignment: .center){
                        Text(firebaseErr)
                            .foregroundStyle(Color(K.Colors.justDarkGray))
                    }
                    .padding(15)
                    .frame(height: 40)
                    .frame(maxWidth: .infinity)
                    .background(Color(K.Colors.justLightGray))
                    .cornerRadius(7)
                    .onTapGesture(perform: {
                        withAnimation{
                            firebaseError = false
                        }
                    })
                    .padding(.horizontal, 15)
                    .offset(y: firebaseError ? 20 : -150)
                }
                if email == ""{
                    ProgressView()
                        .frame(alignment: .center)
                }
            }
            .onAppear(perform: {
                fetchDictionary()
            })
            .modifier(DismissingKeyboard())
        }
        .toolbar(content: {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {updateFunc()}){
                    Text("save")
                        .foregroundStyle(Color(K.Colors.mainColor))
                }
            }
        })
    }
    
    func fetchDictionary(){
        if let userID = Auth.auth().currentUser?.uid{
            db.collection("users").document(userID).getDocument { querySnapshot, err in
                if let err = err {
                    print("Error getting documents: \(err)")
                    showError(error: err.localizedDescription)
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
                            
                            if self.username != ""{
                                self.viewModel.isProfileFinished = true
                            }
                            
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
    
    func showError(error: String){
        withAnimation{
            firebaseError = true
            firebaseErr = error
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            withAnimation{
                firebaseError = false
                firebaseErr = ""
            }
        }
    }
    
    private func updateFunc(){
        
        if name != "" && username != "" && viewModel.isAvailable{
            viewModel.updateProfile(image: image, name: name, username: username, country: country, phone: phone, documentId: documentId, oldImageLink: profileImage)
            self.fetchDictionary()
            errReg = viewModel.err
            viewModel.isProfileFinished = true
            if errReg == ""{
                self.showingEditingProfile = false
            }
        }else if !viewModel.isAvailable{
            showError(error: "username-is-not-available")
        }else if name != "" && username == ""{
            showError(error: "username-is-empty")
        }else if name == "" && username != ""{
            showError(error: "name-is-empty")
        }else{
            showError(error: "some-fields-are-empty")
        }
    }
    
    enum FocusedField:Hashable{
            case name, username, phone, country
        }
}

//#Preview {
//    EditProfileView()
//}
