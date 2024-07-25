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
import iPhoneNumberField
import SwiftData

struct EditProfileView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var published: PublishedVariebles
    @EnvironmentObject var viewModel: AppViewModel
    @State private var authModel = AuthViewModel()

    @Query var strings: [StringDataModel]

    @FocusState var focus: FocusedField?
    
    @Binding var showingEditingProfile: Bool

    @State var name = ""
    @State var phone = ""
    @State var email = ""
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
    @State private var anonymously = false
    
    let restrictedUsernameSet = "!@#$%^&*()+?/.>,<~`±§}{[]|\"÷≥≤µ˜∫√ç≈Ω`åß∂ƒ©˙∆˚¬…æ«‘“πøˆ¨¥†®´∑œ§¡™£¢∞§¶•ªº–≠"
    let restrictedEmaileSet = "!@#$%^&*()+?/.>,<~`±§}{[]|\"÷≥≤µ˜∫√ç≈Ω`åß∂ƒ©˙∆˚¬…æ«‘“πøˆ¨¥†®´∑œ§¡™£¢∞§¶•ªº–≠"
    let maxLength = 20
    
    var db = Firestore.firestore()
    var auth = Auth.auth()
    
    var backgroundType: String {
        if let strModel = strings.first(where: { $0.name == "backgroundType" }) {
            return strModel.string
        }else {
            return "none"
        }
    }
    
    var body: some View {
        NavigationStack{
            ZStack(alignment: email == "" ? .center : .top){
                List{
                    Section(header:
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
                                            Circle().stroke(K.Colors.mainColor, lineWidth: 2)
                                        )
                                        .padding(15)
                                    
                                }else{
                                    Image(systemName: "person.fill.viewfinder")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 100, height: 100)
                                        .foregroundColor(K.Colors.mainColor)
                                        .padding(15)
                                        .fontWeight(.regular)
                                }
                            }
                            Text("tap-to-change-image")
                                .foregroundColor(K.Colors.mainColor)
                                .font(.system(size: 14))
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
                    Section{
                        HStack{
                            TextField("name", text: $name)
                                .focused($focus, equals: .name)
                                .disableAutocorrection(true)
                                .textInputAutocapitalization(.words)
                                .keyboardType(.default)
                                .textContentType(.name)
                                .textSelection(.enabled)
                            Spacer()
                            Image(systemName: "person")
                        }
                    }header: {
                        Text("full-name")
                    }footer: {
                        Text(name.isEmpty ? "rrequired" :"")
                    }
                    .listRowBackground(
                        GlassListRow()
                    )
                    Section(header: Text("username")){
                        HStack{
                            TextField("username", text: $username)
                                .ignoresSafeArea(.keyboard, edges: .bottom)
                                .focused($focus, equals: .username)
                                .disableAutocorrection(true)
                                .textInputAutocapitalization(.never)
                                .keyboardType(.namePhonePad)
                                .textCase(.lowercase)
                                .textContentType(.username)
                                .textSelection(.enabled)
                                .foregroundStyle(username == "" ? Color(K.Colors.text) : (authModel.isAvailable ? Color( K.Colors.text) : Color(red: 1, green: 0.39, blue: 0.49)))
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
                                authModel.checkUsernameAvailability(username: newValue)
                            }
                        })
                    }
                    .listRowBackground(
                        GlassListRow()
                    )
                    Section(header: Text("country")){
                        HStack{
                            TextField("country", text: $country)
                                .ignoresSafeArea(.keyboard, edges: .bottom)
                                .focused($focus, equals: .country)
                                .disableAutocorrection(true)
                                .textInputAutocapitalization(.never)
                                .textContentType(.countryName)
                                .textSelection(.enabled)
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
                    if !(viewModel.currentUser?.profileImageUrl ?? "").isEmpty{
                        Section{
                            HStack{
                                Image(systemName: anonymously ? "checkmark.square.fill" : "square")
                                    .foregroundColor(.primary)
                                Text("rremove-iimage")
                            }
                            .onTapGesture {
                                anonymously.toggle()
                            }
                        }
                        .listRowBackground(
                            GlassListRow()
                        )
                    }
                    Section{
                        Text("save")
                            .foregroundStyle(!name.isEmpty && !username.isEmpty ? Color.white : Color.black)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(!name.isEmpty && !username.isEmpty ? K.Colors.mainColor : Color.secondary)
                            .cornerRadius(10)
                            .onTapGesture(perform: {
                                updateFunc()
                            })
                            .listRowInsets(EdgeInsets())
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
                        focus = .country
                    case .country:
                        focus = .phone
                    case .phone:
                        updateFunc()
                    default:
                        break
                    }
                }
                if email == ""{
                    ProgressView()
                        .frame(alignment: .center)
                }
            }
            .opacity(email == "" ? 0.5 : 1)
            .onAppear(perform: {
                fetchDictionary()
            })
            .modifier(DismissingKeyboard())
            .toolbar(content: {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {updateFunc()}){
                        Text("save")
                            .foregroundStyle(K.Colors.mainColor)
                    }
                }
                ToolbarItem(placement: .principal) {
                    Text(email)
                }
            })
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
        }
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
        
        if name != "" && username != "" && authModel.isAvailable{
            if anonymously{
                viewModel.deleteImageFromCurrentUser()
                viewModel.currentUser?.profileImageUrl = ""
                image = nil
            }
            viewModel.updateProfile(image: image, name: name, username: username, country: country, phone: phone, documentId: documentId, oldImageLink: profileImage, userId: Auth.auth().currentUser?.uid ?? "")
            self.fetchDictionary()
            errReg = viewModel.err
            viewModel.isProfileFinished = true
            if errReg == ""{
                self.showingEditingProfile = false
            }
            self.showingEditingProfile = false
            viewModel.currentUser?.name = name
            viewModel.currentUser?.username = username
            self.dismiss()
        }else if !authModel.isAvailable{
            //            showError(error: String(localized: "username-is-not-available"))
            Toast.shared.present(
                title: String(localized: "username-is-not-available"),
                symbol: "exclamationmark.circle.fill",
                isUserInteractionEnabled: true,
                timing: .long
            )
        }else if name != "" && username == ""{
            //            showError(error: String(localized: "username-is-empty"))
            Toast.shared.present(
                title: String(localized: "username-is-empty"),
                symbol: "questionmark.square",
                isUserInteractionEnabled: true,
                timing: .long
            )
        }else if name == "" && username != ""{
            //            showError(error: String(localized: "name-is-empty"))
            Toast.shared.present(
                title: String(localized: "name-is-empty"),
                symbol: "questionmark.square",
                isUserInteractionEnabled: true,
                timing: .long
            )
        }else{
            //            showError(error: String(localized: "some-fields-are-empty"))
            Toast.shared.present(
                title: String(localized: "some-fields-are-empty"),
                symbol: "questionmark.square",
                isUserInteractionEnabled: true,
                timing: .long
            )
        }
    }
    
    enum FocusedField:Hashable{
        case name, username, phone, country
    }
}

//#Preview {
//    EditProfileView()
//}
